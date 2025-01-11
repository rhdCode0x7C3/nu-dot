# app_metadata.nu

def params [] {
    [name type version description license]
} 

# Searches recursively up the filetree for a nupm.nuon file
export def find-nupm [dir: string] {
    let abs_dir = ($dir | path expand)
    let l = (ls $abs_dir | find 'nupm.nuon')
    match ($l | length) {
        1 => {
            return ($l| get 0 | get name | ansi strip)
        }
        _ => {
            find-nupm ($abs_dir | path parse | get parent)
        }
    }
}

# Returns metadata from a manifest file
# Usually nupm.nuon
export def manifest [filepath: string param: string@params] {
    if ($filepath | path exists) {
        let manifest = (open $filepath)
        $manifest | get $param
    } else {
        error make {msg: $"Manifest file not found at ($filepath)"}
    }
}
