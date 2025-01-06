# nu-dot/symlink.nu

export def create-symlinks [] {
    use ./config.nu *
    let conf = try { open (config-filepath) } catch { "Config file not found" }
    let source = try { $conf.dirs.source } catch { "Source directory not defined" }
    let dest = try { $conf.dirs.dest } catch { "Destination directory not defined" }
    for item in (ls $conf.dirs.source) {
        let record = {
            "source": $item.name,
            "dest": ($dest | path join ($item.name | path basename))}
        $conf.items | upsert item $record
        print $conf
    }
}
