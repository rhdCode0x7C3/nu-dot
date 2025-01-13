# dirs/basefile.nu
# Operations on the base.nuon file
# Each nudot base directory should have a basefile
use ../helpers.nu

def file-status-completion [] {
    [Ready Linked Conflict]
}

export def resolve-destination [r: record] {
    let dest = $r | get ($r | columns | get 0) | get dest 
    if ($dest == 'default') {
        use ./core.nu *
        use ../config/paths.nu *
        let src = $r | get ($r | columns | get 0) | get src 
        let base_name = (open ($src | path dirname | path join 'nudot.nuon') | get name)
        let entry = (open (config-filepath)) | get base_dirs | get $base_name
        $entry.dest
    }
}

# Creates a nudot file record for a single file or directory
# This function doesn't do any validation
# Always pass good data to this
# Parameters:
# - fp: string      Path to the file in question
# - status: string  Ready, Linked or Conflict
# - tracked: bool   Do you want nudot to track this file?
# - dest?: string   Path to the destination file, or 'default'
# Return:
# - A single record
export def create-file-record [
    fp: string
    status: string@file-status-completion
    tracked: bool
    dest?: string
] {
    {
        ($fp | path basename): {
            src: $fp
            dest: ($dest | default 'default')
            status: $status
            tracked: $tracked
        }
    }
}

export def create-basefile [dir?: string name?: string] {
    let dir = ($dir | default $env.PWD)
    let name = ($name | default ($dir | path basename))
    {
        name: $name
        files: (ls -a $dir | get name
        | each {create-file-record $in 'Ready' false}
        | into record)
    }
}
