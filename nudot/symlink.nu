# nudot/symlink.nu

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

def get-dir [dir: string@dir-type] {
    let conf = open-conf
    let src = $conf.defaults.src
    let dest = $conf.defaults.dest
    match $dir {
        src => {
            if ($src | is-empty) {
                error make { msg: "Source directory not defined.\n Run \"set src <path>\""}
            } else {return $src}
        }
        dest => {
            if ($dest | is-empty) {
                error make { msg: "Destination directory not defined.\n Run \"set dest <path>\"" }
            } else {return $dest}
        }
        _ => {
            error make { msg: "Invalid argument" }
        }
    }
}

export def get-dest [src: string dest_dir: string] {
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

export def build-file-record [file: record dest_dir: string] {
    return {
        src: ($file.name | path expand)
        dest: (get-dest $file.name $dest_dir)
        status: (get-symlink-status $file.name (get-dest $file.name $dest_dir))
    }
}

export def scan-src-dir [] {
    use ./config.nu *
    let dest_dir = (get-dir dest)
    let files_record = ls -s (get-dir src)
    | each {|entry|
        {
        $entry.name: (build-file-record ($in | into record) $dest_dir)
        }
    } | reduce {|it, acc| $acc | merge $it}

        open-conf
        | upsert files $files_record
        | to nuon --indent 2 | inspect
        | save -f (config-filepath)
}
