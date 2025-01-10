# tests/config/core_test.nu
use std assert

export def test_default-config_valid_strings [] {
    #setup
    let app_name = "testapp"
    let app_version = "testversion"
    let default_src = "path/testsrc"
    let default_dest = "path/testdest"

    let expected = {
        title: testapp
        version: testversion
        defaults: {
            src: path/testsrc
            dest: path/testdest
        }
        files: {}
    }
    use ../../nudot/config/core.nu *
    let result = (default-config $app_name $app_version $default_src $default_dest)
    assert ($result == $expected)
}

export def test_default-config_empty_strings [] {
    #setup
    let app_name = ""
    let app_version = ""
    let default_src = ""
    let default_dest = ""

    let expected = {
        title: "",
        version: "",
        defaults: {
            src: "",
            dest: "",
        }
        files: {}
    }
    use ../../nudot/config/core.nu *
    let result = (default-config $app_name $app_version $default_src $default_dest)
    assert ($result == $expected)
}

# Calls ensure-config with a valid path
# where no pre-existing configuration file exists
export def test_ensure-config_valid_not_exists [] {
    #setup
    let filepath = (mktemp -d | path join config.nuon)
    print $filepath

    use ../../nudot/config/core.nu *
    ensure-config $filepath

    cat $filepath

    #cleanup
    rm -rf (dirname $filepath)
}
