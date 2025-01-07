# nu-dot/symlink.nu

def open-conf [] {
    use ./config.nu *

    if (config-filepath | path exists) {
        open (config-filepath)
    } else {
        ensure-config
        open (config-filepath)
    }
}

def dir-type [] { [src dest] }

def get-dir [dir: string@dir-type] {
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

def get-dest [src: string dest_dir: string] {
    ($"($dest_dir)/(basename $src)")
}

def dest-ready [dest: string] {
    let dest_dir_exists = ($dest | path dirname | path exists)
    $dest_dir_exists and (not ($dest | path exists))
}

def get-file-info [path: string] {
    ls -l ($path | path dirname) | where name =~ ($path | path basename)
}

def correctly-linked [src: string dest: string] {
    if not ($dest | path exists) { return false }
    let dest_info = (get-file-info $dest)
    $dest_info.target.0 == $src
}

def get-symlink-status [src: string dest: string] {
    if (dest-ready $dest) { return "Ready" }
    if (correctly-linked $src $dest) { return "Linked" }
    "Conflict"
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
            status: (get-symlink-status $in.name (get-dest $in.name $dest_dir))
        }
    }
    open-conf 
    | upsert items $items_list 
    | to nuon --indent 2 
    | save -f (config-filepath)
}
