# nudot/config/path.nu
# Path management

# Returns the config path for a given environment
# For system config use env_vars = $env
# $env.HOME must be set on Windows systems
export def config-path [env_vars?: record] {
    let $env_vars = ($env_vars | default $env)
    $env_vars | get --ignore-errors XDG_CONFIG_HOME | default ($env_vars.HOME | path join ".config")
}

# Returns the path of the nudot config file
# For system config env_vars = $env
export def config-filepath [env_vars?: record] {
    let $env_vars = ($env_vars | default $env)
    config-path $env_vars | path join "nudot/config.nuon"
}
