# tests/app_metadata_test.nu
use std [assert log]

export def test_find-nupm_valid-path [] {
    # setup
    let temp = ((mktemp -d) | path expand)
    let filepath = ($temp | path join nupm.nuon)
    let testpath = ($temp | path join path/to/test)
    touch $filepath
    mkdir $testpath
    log debug $filepath
    # test
    use ../nudot/app_metadata.nu *
    let result = (find-nupm $testpath)
    log debug $result
    assert ($result == $filepath) 
    
    # cleanup
    rm -rf $temp
    
}


export def test_find-nupm_invalid-path [] {
    # setup
    let temp = ((mktemp -d) | path expand)
    let filepath = ($temp | path join nupm.nuon)
    touch $filepath
    # test
    use ../nudot/app_metadata.nu *
    let result = (find-nupm ($temp | path join path/not/exists))
    log debug $result
    assert ($result == "Invalid path") 
    
    # cleanup
    rm -rf $temp
    
}

export def test_manifest_valid-path [] {
    # setup
    let filepath = (mktemp --suffix .nuon)
    "{name: foo, version: bar}" | save $filepath -f
    let expected = 'foo'

    # test
    use ../nudot/app_metadata.nu *
    let result = (manifest $filepath 'name')

    assert ($result == $expected)

    # cleanup
    rm $filepath

}
