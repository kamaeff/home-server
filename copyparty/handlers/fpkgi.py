# on404 handler
# sends a custom response instead of the usual 404
# from https://github.com/kamaeff/copyparty-dumb-fpkgi-handler/blob/master/fpkgi.py

import json
from collections import namedtuple
from pathlib import Path
from urllib.parse import quote
import re


permissions_fields = ('read', 'write', 'move', 'delete', 'get', 'upget', 'html', 'admin', 'dot')
Permissions = namedtuple('Permissions', permissions_fields, defaults=(False,) * len(permissions_fields))

# any of these is fine
REQUIRED_PERMISSIONS = [
    Permissions(read=True),
    Permissions(get=True),
    Permissions(upget=True),
    Permissions(html=True),
    Permissions(admin=True),
]
CUSA_PATTERN = re.compile(r"CUSA\d{5}")
ANY_PATTERN = re.compile(r"[A-Z]{4}\d{5}")


def extract_package_id(filename: str) -> str:
    match = CUSA_PATTERN.search(filename) or ANY_PATTERN.search(filename)
    return match[0] if match else 'UNKNOWN'



def main(cli, vn, rem):
    if rem != '__FPKGi.json':
        return cli.tx_404()

    protocol = "https" if cli.is_https else "http"
    basic_auth=''
    if cli.uname != '*' or cli.pw:
        basic_auth = f'{cli.uname}:{cli.pw}@'
    base_url = f"{protocol}://{basic_auth}{cli.host}/"


    response = {}
    for walk_result in vn.walk('', '', [], cli.uname, REQUIRED_PERMISSIONS, 0, False, False, True):
        vfs_subdir = walk_result[2]
        fs_parent_dir = walk_result[3]
        files = (f for f in walk_result[4] if f[0].endswith('.pkg'))
        for file_name, stat in files:
            url = base_url + quote(f'{vn.vpath}/{vfs_subdir}/{file_name}')
            param_sfo = extract_param_sfo(Path.join(fs_parent_dir, file_name))
            title_id = param_sfo.get('TITLE_ID') or extract_package_id(file_name)
            content_id = param_sfo.get(content_id)
            response[url] = {
                "title_id": title_id,
                "region": REGIONS.get(content_id[0].upper()) if content_id else None,
                "name": param_sfo.get('TITLE') or file_name[:-4],
                "version": param_sfo.get('VERSION'),
                "release": None,
                "size": stat.st_size,
                "min_fw": param_sfo.get('SYSTEM_VER'),
                "cover_url": None,
            }

    response_body = json.dumps({"DATA": response})

    return str(cli.reply(response_body.encode("utf-8"), 200, "application/json"))




### FPKG PARAM.SFO ###

from enum import Enum
import struct


PARAM_SFO_ENTRY_ID = 0x00001000
REQUIRED_PARAMS = {'TITLE_ID', 'TITLE', 'CONTENT_ID', 'VERSION', 'SYSTEM_VER'}
REGIONS = {
    'U': 'USA',
    'J': 'JAP',
    'E': 'EUR',
    'H': 'ASIA',

    # 'I': 'INT',
    # 'K': 'KOREA'
    'K': 'ASIA'
}

class SfoParamType(Enum):
    UTF8_NULL_TERMINATED = 0x4
    UTF8_FIXED_LENGTH = 0x204
    INT = 0x404


class BinaryFile(object):
    def __init__(self, file):
        self.file = file

    def seek(self, offset, whence=0, /):
        self.file.seek(offset, whence)
        return self
    
    def read_struct(self, format):
        size = struct.calcsize(format)
        return struct.unpack(format, self.file.read(size))

    def uint_be(self):
        return self.read_struct('>I')[0]

    def int_le(self):
        return self.read_struct('<i')[0]

    def uint_le(self):
        return self.read_struct('<I')[0]

    def ushort_le(self):
        return self.read_struct('<H')[0]

    # no need to sacrifice readability I guess
    def ascii(self):
        res = bytearray()
        while True:
            byte = self.file.read(1)[0]
            if byte == 0:
                return res.decode('ASCII')
            res.append(byte)

    def utf8(self, length):
        length = length - 1 if length > 0 else 0
        if length > 1:
            return self.file.read(length - 1).decode('utf-8')
        return None

    def __getattr__(self, name):
        return getattr(self.file, name)


def extract_param_sfo(filepath: str):
    with open(filepath, 'rb') as f:
        file = BinaryFile(f)
        param_sfo_location = find_param_sfo_location(file)
        if param_sfo_location is None:
            return create_empty_params()
        param_sfo = collect_sfo_params(file, param_sfo_location)
    return(param_sfo)


def find_param_sfo_location(file: BinaryFile):
    # read pkg header to get pkg entries details
    entry_count = file.seek(0x10).uint_be()
    entry_table_position = file.seek(0x18).uint_be()

    # look for param.sfo metadata entry in metadata entries
    file.seek(entry_table_position)
    for _ in range(entry_count):
        if file.uint_be() == PARAM_SFO_ENTRY_ID:
            break
        file.seek(28, 1)
    else:
        return None

    # extract actual param.sfo entry location
    return file.seek(12, 1).uint_be()


def collect_sfo_params(file: BinaryFile, param_sfo_start: int):
    file.seek(param_sfo_start)

    # check SFO magic
    if file.uint_be() == 0x53434543:
        param_sfo_start += 0x800

    if file.seek(param_sfo_start).uint_be() != 0x00505346:
        return None

    params = create_empty_params()

    # obtain params info
    key_table_offset = file.seek(param_sfo_start + 8).int_le()
    data_table_offset = file.int_le()
    values_count = file.int_le()

    for idx in range(values_count):
        key_offset = file.seek(idx * 0x10 + 0x14 + param_sfo_start).ushort_le()
        format_ = file.ushort_le()
        length = file.int_le()
        file.seek(4, 1)
        data_offset = file.uint_le()

        try:
            name = file.seek(param_sfo_start + key_table_offset + key_offset).ascii()
        except:
            continue

        if name not in REQUIRED_PARAMS:
            continue

        file.seek(param_sfo_start + data_table_offset + data_offset)

        if format_ == SfoParamType.INT.value:
            if name == 'SYSTEM_VER':
                _, _, minor, major = file.read_struct('4b')
                value = f'{major:x}.{minor:02x}'
            else:
                value = file.int_le()
        elif format_ == SfoParamType.UTF8_FIXED_LENGTH.value:
            value = file.utf8(length + 1)
        elif format_ == SfoParamType.UTF8_NULL_TERMINATED.value:
            value = file.utf8(length)
        else:
            value = None

        params[name] = value

    return params

def create_empty_params():
    return dict.fromkeys(REQUIRED_PARAMS, None)
