# nudot/config/core.nu
# Config file operations

# Returns a default configuration record
# Parameters:
#  - app_name: string
#  - app_version: string
# Return: record - Default configuration record
export def default-config [
    app_name: string,
    app_version: string,
] {
    {
        title: $app_name
        version: $app_version
        base_dirs: {}
    }
}

# Ensures a config file exists at $filepath
# Creates one if not
#The user must have write permission to the parent directory
# Parameters:
# - filepath: string
export def ensure-config [filepath: string] {
    use ../app_metadata.nu *
    # let app_name = (manifest (find-nupm .) name)
    # let app_version = (manifest (find-nupm .) version)
    let app_name = "nudot"
    let app_version = "0.1.0"
    if not ($filepath | path exists) {
        try {
            if not (dirname ($filepath) | path exists) {
                mkdir (dirname ($filepath))
            }
            use ./paths.nu *
            (default-config $app_name $app_version)
            | to nuon --indent 2
            | save $filepath
        } catch {
            error make {msg: $"Unable to create config at ($filepath)"}
        }
    }
    $filepath
}
