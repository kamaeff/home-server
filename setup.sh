#!/usr/bin/env bash

set -e
shopt -s dotglob

function main {
    DIRNAME="$(dirname "$(readlink -f "${0}")")"
    cd "${DIRNAME}"

    yes_or_no "Create .env files?" &&
    create_env_files
    
    yes_or_no "Build and pull docker images?" &&
    docker_update

    yes_or_no "Setup rclone?" &&
    setup_rclone

    yes_or_no "Setup caddy?" &&
    setup_caddy
    echo "setup SUCCESS"
}

function create_env_files {
    local files example dot_env dir

    files=(*.env.example)
    if [ "${files}" = '*.env.example' ]; then
        files=()
    else
        echo "${PWD}"
    fi

    for example in "${files[@]}"; do
        dot_env="${example%%\.example}"
        if [ -f "${dot_env}" ]; then
            echo "    '${dot_env}' already exists"
            continue
        fi
        if yes_or_no "    Create '${dot_env}'?"; then
            cp "${example}" "${dot_env}"
            nano "${dot_env}"
        fi
    done

    # recurse into subdirs
    # not using `find -name '*.env.example'` to avoid managing input redirection`
    for dir in */; do
        if [ "${dir}" = '*/' ] || [ ${dir} = '.git/' ]; then continue; fi
        pushd "${dir}" >/dev/null
            create_env_files
        popd >/dev/null
    done
}

function docker_update {
    docker compose build --pull
    docker compose pull
}

function setup_rclone {
    docker compose run --rm rclone config
}

function setup_caddy {
    echo "Settting up Caddy"
    echo "Building static files"
    docker compose run --rm caddy-build-static
    echo "Static files successfully built"
    echo "Caddy is set up"
}

function yes_or_no {
    local yn
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}


main
