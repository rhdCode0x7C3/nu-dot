# types.nu
# Validation for common types and schemas
use ./helpers.nu *

# Sum type definitions

# def file-status
# file-status represents the status of a file in a base directory
# Ready:    File can be linked (destination does not exist)
# Linked:   File is correctly linked (symlink exists and point to source)
# Conflict: Destination exists but isn't linked to source
#
# Truth table:
# | Dest exists | Is symlink | Linked to src | Status   |
# | ----------- | ---------- | ------------- | -------- |
# | false       | -          | -             | Ready    |
# | true        | true       | true          | Linked   |
# | true        | false      | -             | Conflict |
# | true        | true       | false         | Conflict |
def file-status [] {
    [Ready Linked Conflict]
}

# def is-file-status
# Validates status field in a base file record
export def is-file-status [s: string]: string -> bool {
    $s in (file-status)
}

# def base_dir-status
# base_dir-status represents the status of a base directory
# Active:   Directory is tracked by nudot
# Inactive: Directory is not tracked by nudot
def base_dir-status [] {
    [Active Inactive]
}

# def is-base_dir-status
# Validates status field in a base_dir record
export def is-base_dir-status [s: string]: string -> bool {
    $s in (base_dir-status)
}

# Schema definitions for nudot files

# Global config (XDG_CONFIG_HOME/nudot/config.nuon)
# {
#   title: string,     # Application name
#   version: string,   # Application version
#   base_dirs: {       # Record containing base directories
#     {base_dir}
#     {base_dir}
#     ...
#   }
# }

# {base_dir} record
# Base directories are listed within the global config
# Create a base directory by running 'nudot add <path>?'
# 
#     name: {               # Unique identifier for the base directory
#       base: string,       # Absolute path to base directory
#       dest: string?,      # Default destination path
#       status: string      # Defined in base_dir-status
#                           # Inactive base directories are ignored by nudot
#     },

# Base file (root directory of every nudot base)
# 
# {
#   name: nudot,            # Unique identifier for the base directory
#   files: {                # Record containing files in the base directory
#    {file}
#    {file}
#    ...
#   }
#
# }
# {file} record 
# Files are listed within the base file
#     name: {
#       src: string         # Absolute path to the source file
#       dest: string,       # Absolute path to the destination file, or 'default'
#       status: string,     # Defined in file-status
#       tracked: bool       # Untracked files are ignored by nudot
#     },


# def is-base_dir-record
# Validates base_dir record
export def is-base_dir-record [r: record]: record -> bool {
    let fields = [base dest status]
    try {
        guard [
            ($fields | all {$in in $r})
            ($r.base | path exists)
        ] { true } { false }
    } catch { false }
}

# def is-config
# Validates the global config file
export def is-config [c: record]: record -> bool {
    let fields = [title version base_dirs]
    try {
        guard [
            ($fields | all {$in in $c})
            ($c.base_dirs | values | all {is-base_dir-record $in})
        ] { true } { false }
    } catch { false }
}

# Validates base file record
export def is-file-record [r: record]: record -> bool {
    let fields = [src dest status tracked]
    try {
        guard [ ($fields | all {$in in $r})
            ($r.src | path exists)
            ($r.dest == 'default' or ($r.dest | path exists))
            (is-file-status $r.status)
            (($r.tracked | describe) == bool)
        ] { true } { false }
    } catch { false }
}

# Validates base.nuon file
export def is-base-file [r: record]: record -> bool {
    let fields = [name files]
    try {
        guard [
            ($fields | all {$in in $r})
            (($r.files | describe) =~ 'record')
            ($r.files | values | all {is-file-record $in})
        ] { true } { false }
    } catch { false }
}
