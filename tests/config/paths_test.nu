# tests/config/paths_test.nu
use std assert

export def test_system-config-path_with_xdg [] {
    # setup
    let test_env = {
        TESTING: true,
        XDG_CONFIG_HOME: "some/path"
    }
    use ../../nudot/config/paths.nu *
    let result = (_system-config-path_aux $test_env)
    assert ($result == "some/path")
    
}

export def test_system-config-path_without_xdg [] {
    # setup
    let test_env = {
        TESTING: true,
        HOME: "some/path"
    }
    use ../../nudot/config/paths.nu *
    let result = (_system-config-path_aux $test_env)
    assert ($result == "some/path/.config")
    
}

export def test_system-config-path_null_xdg [] {
    # setup
    let test_env = {
        TESTING: true,
        HOME: "some/path"
        XDG_CONFIG_HOME: null,
    }
    use ../../nudot/config/paths.nu *
    let result = (_system-config-path_aux $test_env)
    assert ($result == "some/path/.config")
    
}
