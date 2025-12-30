#!/usr/bin/env bash

set -e
shopt -s dotglob

function main {
    DIRNAME="$(dirname "$(readlink -f "${0}")")"
    cd "${DIRNAME}"

    create_env_files
    setup_subdirs
    docker_update
    setup_rclone
    echo "setup SUCCESS"
}


function create_env_files {
    local example dot_env
    for example in *.env.example; do
        if [ "${example}" = '*.env.example' ]; then
            echo 'no *.env.example files provided'
            break
        fi

        dot_env="${example%%\.example}"
        if [ -f "${dot_env}" ]; then
            echo "'${dot_env}' already exists"
            continue
        fi

        cp "${example}" "${dot_env}"
        read -ei "Press any key to fill '${dot_env}'"
        nano "${dot_env}"
    done
}

function setup_subdirs {
    for dir in */; do
        echo "Setting .env files for ${dir}"
        pushd "${dir}"
            create_env_files
        popd
    done
}

function docker_update {
    docker compose build --pull
    docker compose pull
}

function setup_rclone {
    docker compose run --rm rclone config
}


main
