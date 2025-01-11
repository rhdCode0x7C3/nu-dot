            # module manifest
            # module manifest
# nudot/config/core.nu
# Config file operations

# Returns a default config
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
        files: {}
    }
}

# Ensures a config file exists
# Creates one if not
export def ensure-config [filepath: string] {
    use ../app_metadata.nu *
    let app_name = (manifest (find-nupm .) name)
    let app_version = (manifest (find-nupm .) version)
    if not ($filepath | path exists) {
        try {
            if not (dirname ($filepath) | path exists) {
                mkdir (dirname ($filepath))
            }
            use ./paths.nu *
            (default-config $app_name $app_version (config-path $env) "")
            | to nuon --indent 2
            | save $filepath
        } catch {
            error make {msg: $"Unable to create config at ($filepath)"}
        }
    }
}
