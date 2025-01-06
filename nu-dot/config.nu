# nu-dot/config.nu
# Config file management

export def config-path [] {
    if 'XDG_CONFIG_HOME' in $env {
        $env.XDG_CONFIG_HOME | path join "nu-dot"
    }
    $env.HOME | path join ".config/nu-dot"

}

export def config-filepath [] { config-path | path join config.nuon }

export def ensure-config [] {
    let filepath = config-filepath
    if not ($filepath | path exists) {
        mkdir (config-path)
        {
            title: "nu-dot config",
            dirs: { source: "", dest: "", }
            items: {}
        }
        | to nuon --indent 2
        | save $filepath
    }
}
