# on404 handler
# sends a custom response instead of the usual 404
# from https://github.com/kamaeff/copyparty-dumb-fpkgi-handler/blob/master/fpkgi.py

import json
from collections import namedtuple
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
        files = (f for f in walk_result[4] if f[0].endswith('.pkg'))
        for file_name, stat in files:
            url = base_url + quote(f'{vn.vpath}/{vfs_subdir}/{file_name}')
            response[url] = {
                "title_id": extract_package_id(file_name),
                "region": None,
                "name": file_name[:-4],
                "version": None,
                "release": None,
                "size": stat.st_size,
                "min_fw": None,
                "cover_url": None,
            }

    response_body = json.dumps({"DATA": response})

    return str(cli.reply(response_body.encode("utf-8"), 200, "application/json"))

