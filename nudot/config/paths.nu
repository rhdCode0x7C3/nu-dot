# nudot/config/path.nu
# Path management

# Returns the config path for some arbitrary environment
# For system config use env_vars = $env
export def config-path [env_vars: record] {
    if ('XDG_CONFIG_HOME' in $env_vars) and (not ($env_vars.XDG_CONFIG_HOME == null)) {
       return $env_vars.XDG_CONFIG_HOME
    } else {
        $env_vars.HOME | path join ".config"
    }
}

# Returns the path of the nudot config file
# For system config env_vars = $env
export def config-filepath [env_vars: record] {
    config-path $env_vars | path join "nudot/config.nuon"
}
