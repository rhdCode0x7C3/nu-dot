# nudot/config.nu
# Config file management

export def system-config-path [] {
    if 'XDG_CONFIG_HOME' in $env {
        $env.XDG_CONFIG_HOME
    }
    $env.HOME | path join ".config"
}

export def config-path [] {
    system-config-path | path join "nudot"
}

export def config-filepath [] { config-path | path join config.nuon }

export def default-config [] {
    let app_name = "nudot"
    let app_version = "0.1.0"
    let default_src = "" # Empty until set by user
    let default_dest = system-config-path

    {
        title: $app_name
        version: $app_version
        defaults: {
            src: $default_src
            dest: $default_dest
        }
        files: {}
    }
}


export def ensure-config [] {
    let filepath = config-filepath
    if not ($filepath | path exists) {
        mkdir (config-path)
        default-config
        | to nuon --indent 2
        | save $filepath
    }
}
