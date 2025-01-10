# tests/config/paths_test.nu
use std assert

export def test_config-path_with_xdg [] {
    # setup
    let test_env = {
        XDG_CONFIG_HOME: "some/path"
    }
    use ../../nudot/config/paths.nu *
    let result = (config-path $test_env)
    assert ($result == "some/path")
    
}

export def test_config-path_without_xdg [] {
    # setup
    let test_env = {
        HOME: "some/path"
    }
    use ../../nudot/config/paths.nu *
    let result = (config-path $test_env)
    assert ($result == "some/path/.config")
    
}

export def test_config-path_null_xdg [] {
    # setup
    let test_env = {
        HOME: "some/path"
        XDG_CONFIG_HOME: null,
    }
    use ../../nudot/config/paths.nu *
    let result = (config-path $test_env)
    assert ($result == "some/path/.config")
    
}

export def test_config-filepath [] {
    # setup
    let test_env = {
        XDG_CONFIG_HOME: "some/path",
    }
    use ../../nudot/config/paths.nu *
    let result = (config-filepath $test_env)
    assert ($result == "some/path/nudot/config.nuon")
}
