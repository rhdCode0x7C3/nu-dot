# nudot/config/path.nu
# Path management

def system-config-path_aux [env_vars: record] {
    if ('XDG_CONFIG_HOME' in $env_vars) and (not ($env_vars.XDG_CONFIG_HOME == null)) {
       return $env_vars.XDG_CONFIG_HOME
    } else {
        $env_vars.HOME | path join ".config"
    }
}

export def system-config-path [] {
    system-config-path_aux $env
}

export def config-filepath [] { config-path | path join config.nuon }

# Export only when testing
export def _system-config-path_aux [$env_vars] {
    if ($env_vars.TESTING) {system-config-path_aux $env_vars}
}
