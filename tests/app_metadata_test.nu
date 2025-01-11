# tests/app_metadata_test.nu
use std assert

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
