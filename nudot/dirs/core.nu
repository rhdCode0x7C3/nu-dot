# dirs/core.nu
# Operations on base directories

def base_dir-status-completion [] {
    [active inactive]
}

# 
export def create-base_dir-record [
    base: string
    status: string@base_dir-status-completion
    key?: string
] {
    let valid_key = match $key {
        null => {
            ($env.PWD | path basename)
        }
        _ => {
            $key
        }
    }
    { $valid_key: {
        base: ($base | path expand)
        dest: null
        status: $status
    } }
}

# Check if a nudot.nuon file exists in a directory
# Create one if not.
# Parameters:
# - dir: string Must be a valid directory path
# Return: path to existing or newly created nudot.nuon file
export def ensure-nudot-file [dir: string] {
    let nudot_file_path = ($dir | path join 'nudot.nuon')
    if not ($nudot_file_path | path exists) {
        touch $nudot_file_path
    }
    $nudot_file_path
}

# Adds a single path to nudot's list of base directories
# Parameters:
# - dir: Path to the base directory. Defaults to PWD if not specified
# Flags:
# - --name (-n): Name of the nudot base
export def add [
    dir?: string
    --name (-n): string
] {
    # Input validation
    let dir_or_pwd = ($dir | default $env.PWD)
    use ../helpers.nu guard
    guard [
        ($dir_or_pwd | path exists)
        (($dir_or_pwd | path type) == dir)
    ] {
        # Create the record
        let record = (create-base_dir-record $dir_or_pwd active $name)

        # Merge it into the configuration file
        use ../config/paths.nu config-filepath
        use ../config/core.nu ensure-config
        let fp = ensure-config (config-filepath $env)
        open $fp
        | upsert base_dirs ($in.base_dirs | merge $record)
        | to nuon -i 2
        | save -f $fp
    }
}

export def remove [dir: string] {
    let dir_or_pwd = ($dir | default $env.PWD)
    use ../helpers.nu guard
    guard [
        ($dir_or_pwd | path join nudot.nuon | path exists)
    ] {

    }
}

export def show [env_vars] {
    use ../config/core.nu *
    use ../config/paths.nu *
    ensure-config (config-filepath $env_vars)
    let config = (open (config-filepath $env_vars))
    print $config.defaults
}
