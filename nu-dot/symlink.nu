# nu-dot/symlink.nu

export def open-conf [] {
    use ./config.nu *

    if (config-filepath | path exists) {
        open (config-filepath)
    } else {
        ensure-config
        open (config-filepath)
    }
}

def dir-type [] { [src dest] }

export def get-dir [dir: string@dir-type] {
    let conf = open-conf
    let dirs = $conf.dirs
    match $dir {
        src => {
            if ($dirs.src | is-empty) {
                error make { msg: "Source directory not defined.\n Run \"set src <path>\""}
            } else {return $dirs.src}
        }
        dest => {
            if ($dirs.dest | is-empty) {
                error make { msg: "Destination directory not defined.\n Run \"set dest <path>\"" }
            } else {return $dirs.dest}
        }
        _ => {
            error make { msg: "Invalid argument" }
        }
    }
}

export def generate-link-items [] {
    let src_files = ls (get-dir src) | get name
    let dest_dir = (get-dir dest)
    let link_dests = $src_files | each {$"($dest_dir)/(basename $in)"}
    print $link_dests
}

def get-dest [src: string dest_dir: string] {
    ($"($dest_dir)/(basename $src)")
}

export def get-symlink-status [src: string dest: string] {
    # Verify the destination file's parent directory exists
    let dest_dir_exists = ($dest | path dirname | path exists)
    let dest_exists = ($dest | path exists)
    let dest_info = if ($dest_exists) {
        ls -l ($dest | path dirname) | where name =~ ($dest | path basename)
    }
    # let is_symlink = if ($dest_exists) { $dest_info.type.0 == symlink }
    # print $target_is_src
    if ($dest_dir_exists and not $dest_exists) {
        "Ready"
    } else {
        let target_is_src = $dest_info.target.0 == $src
        if ($target_is_src) {
            "Linked"
        } else {
            "Conflict"
        }
    }
}

export def build-items-list [] {
    use ./config.nu *
    let dest_dir = (get-dir dest)
    let items_list = ls (get-dir src)
    | each {
        {
            src: ($in.name | path expand)
            dest: (get-dest $in.name $dest_dir)
            type: ($in.type)
            # status: get-symlink-status 
        }
    }
    open-conf 
    | upsert items $items_list 
    | to nuon --indent 2 
    | save -f (config-filepath)
}
