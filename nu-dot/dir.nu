# nu-dot/dir.nu
# Set src and destination directories

export def show [] {
    use ./config.nu *
    ensure-config
    let config = (open (config-filepath))
    print $config.dirs
}

def dir-type [] {
    [src dest]
}

export def set [type: string@dir-type, path: string] {
    use ./config.nu *
    let expanded_path = ($path | path expand)
    open (config-filepath)
    | match $type {
        src => {
            upsert defaults.src $expanded_path
        }
        dest => {
            upsert defaults.dest $expanded_path
        }
    }
    | to nuon --indent 2
    | save (config-filepath) -f
}
