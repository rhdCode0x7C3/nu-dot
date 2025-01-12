# tests/config/core_test.nu
use std assert

export def test_default-config_valid_strings [] {
    #setup
    let app_name = "testapp"
    let app_version = "testversion"

    let expected = {
        title: testapp,
        version: testversion,
        base_dirs: {}
    }
    use ../../nudot/config/core.nu *
    let result = (default-config $app_name $app_version)
    assert ($result == $expected)
}

export def test_default-config_empty_strings [] {
    let expected = {
        title: "",
        version: "",
        base_dirs: {}
    }
    use ../../nudot/config/core.nu *
    let result = (default-config "" "")
    $"($result | to nuon)\n($expected | to nuon)"
    # assert (($result | to nuon) == ($expected | to nuon))
}

# Calls ensure-config with a valid path
# where no pre-existing configuration file exists
export def test_ensure-config_valid_not_exists [] {
    #setup
    let filepath = (mktemp -d | path join 'config.nuon')

    use ../../nudot/config/core.nu *
    ensure-config $filepath
    
    assert ($filepath | path exists)

    #cleanup
    rm -rf (dirname $filepath)
}

# Calls ensure-config with the path to an existing file
# ensure-config should leave the existing file in place
export def test_ensure-config_valid_exists [] {
    #setup
    let filepath = (mktemp -d | path join 'myfile')
    let content = "DON'T MODIFY ME"
    $content | save $filepath

    use ../../nudot/config/core.nu *
    ensure-config $filepath

    assert ((open $filepath) == $content)
    
    #cleanup
    rm -rf (dirname $filepath)
}
