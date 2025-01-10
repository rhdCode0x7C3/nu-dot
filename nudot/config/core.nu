# nudot/config/core.nu
# Config file operations

# Pure function
export def default-config [
    app_name: string,
    app_version: string,
    default_src: string,
    default_dest: string
] {
    {
        title: $app_name
        version: $app_version
        defaults: {
            base: $default_src
            dest: $default_dest
        }
        overrides: {
            {
                # Not implemented in this version
            }
        }
        files: {}
    }
}

# Wrapper with system defaults
def system-default-config [] {
    use ./paths.nu *
    default-config "nudot" "0.1.0" "" (system-config-path)
}

# Private function
# Ensures a config file exists
# Creates one if not
export def ensure-config [filepath: string] {
    if not ($filepath | path exists) {
        try {
            mkdir (dirname ($filepath))
            system-default-config
            | to nuon --indent 2
            | save $filepath
        } catch {
            error make {msg: $"Unable to create config at ($filepath)"}
        }
    }
}

# Wrapper for system use
export def system-ensure-config [] {
    use ./paths.nu *
    ensure-config (system-config-path)
}

