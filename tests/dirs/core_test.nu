# tests/core_test.nu
use std [assert log]

export def test_ensure-nudot-file_returns_correct_path [] {
    # setup
    let temp = (mktemp -d)
    let expected = ($temp | path join 'nudot.nuon')
    log debug $expected

    # test
    use ../../nudot/dirs/core.nu ensure-nudot-file
    let result = (ensure-nudot-file $temp)
    log debug $result
    assert ($result == $expected)

    # cleanup
    rm -rf $temp
    
}

export def test_ensure-nudot-file_created_successfully [] {
    # setup
    let temp = (mktemp -d)

    # test
    use ../../nudot/dirs/core.nu ensure-nudot-file
    let result = (ensure-nudot-file $temp)
    log debug $result
    assert ($result | path exists)

    # cleanup
    rm -rf $temp
    
}
