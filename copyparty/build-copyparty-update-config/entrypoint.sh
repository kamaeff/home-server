TEMPLATE_CONFIG_PATH=/copyparty.conf.template
ORIGINAL_CONFIG_PATH=/cfg/copyparty.conf

function print_new_config {
    envsubst < "${TEMPLATE_CONFIG_PATH}"
}

function print_original_config {
    if [ -f "${ORIGINAL_CONFIG_PATH}" ]; then
        cat "${ORIGINAL_CONFIG_PATH}"
    fi
}

new_config_text="$(print_new_config)"
original_config_text="$(print_original_config)"

# only write on changes
if [ "${original_config_text}" != "${new_config_text}" ]; then
    echo "Updating config '${ORIGINAL_CONFIG_PATH}' with env variables."
    echo "${new_config_text}" > "${ORIGINAL_CONFIG_PATH}"
else
    echo "Config '${ORIGINAL_CONFIG_PATH}' is up to date."
fi

unset TEMPLATE_CONFIG_PATH ORIGINAL_CONFIG_PATH new_config_text original_config_text

exec python3 -m copyparty -c /z/initcfg
