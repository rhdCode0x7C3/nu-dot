# dirs/core.nu
# Operations on base and destination directories

export def show [env_vars] {
    use ../config/core.nu *
    use ../config/paths.nu *
    ensure-config (config-filepath $env_vars)
    let config = (open (config-filepath $env_vars))
    print $config.defaults
}
