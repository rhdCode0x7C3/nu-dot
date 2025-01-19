# tests/types_test.nu
# Test suite for types.nu
use std [assert log]

export def test_is-file-status_valid [] {
    # setup
    let ready = 'Ready'
    let linked = 'Linked'
    let conflict = 'Conflict'

    # test
    use ../nudot/types.nu *
    assert (is-file-status $ready)
    assert (is-file-status $linked)
    assert (is-file-status $conflict)
}

export def test_is-file-status_invalid [] {
    # setup
    let foo = 'Bar'

    # test
    use ../nudot/types.nu *
    assert not (is-file-status $foo)
}

export def test_is-base_dir-status_valid [] {
    # setup
    let active = 'Active'
    let inactive = 'Inactive'

    # test
    use ../nudot/types.nu is-base_dir-status
    assert (is-base_dir-status $active)
    assert (is-base_dir-status $inactive)
}

export def test_is-base_dir-status_invalid [] {
    # setup
    let foo = 'Bar'

    # test
    use ../nudot/types.nu is-base_dir-status
    assert not (is-base_dir-status $foo)
}

# is-base_dir-record
export def test_is-base_dir-record_valid [] {
    # setup
    let tmp = mktemp
    let r = {base: $tmp, dest: /path/to/dest, status: active}

    # test
    use ../nudot/types.nu is-base_dir-record
    assert (is-base_dir-record $r)

    # cleanup
    rm $tmp
}

export def test_is-base_dir-record_wrong-fields [] {
    # setup
    let tmp = mktemp
    let r = {base: $tmp, dest: /path/to/dest, foo: bar}

    # test
    use ../nudot/types.nu is-base_dir-record
    assert not (is-base_dir-record $r)

    # cleanup
    rm $tmp
}

export def test_is-base_dir-record_invalid-path [] {
    # setup
    let tmp = mktemp
    rm $tmp
    let r = {base: $tmp, dest: /path/to/dest, status: active}

    # test
    use ../nudot/types.nu is-base_dir-record
    assert not (is-base_dir-record $r)

    # cleanup
}

# is-config
export def test_is-config_valid [] {
    # setup
    let tmp = mktemp -d
    let c = {title: nudot, version: "0.1.0", base_dirs: {nudot: {base: $tmp, dest: /path/to/dest, status: active}}}
    
    # test
    use ../nudot/types.nu is-config
    assert (is-config $c)

    #cleanup
    rm -rf $tmp
}

export def test_is-config_invalid [] {
    # setup
    let tmp = mktemp -d
    rm -rf $tmp
    let c = {title: nudot, version: "0.1.0", base_dirs: {nudot: {base: $tmp, dest: /path/to/dest, status: active}}}
    
    # test
    use ../nudot/types.nu is-config
    assert not (is-config $c)
}

# is-file-record
export def test_is-file-record_valid [] {
    # setup
    let src = mktemp -d
    let dest = mktemp -d
    let r = {src:$src,dest:$dest,status:Ready,tracked:false}

    # test
    use ../nudot/types.nu is-file-record 
    assert (is-file-record $r)

    # cleanup
    rm -rf $src $dest
}

export def test_is-file-record_wrong-fields [] {
    # setup
    let src = mktemp -d
    let dest = mktemp -d
    let r = {foo:$src,bar:$dest,status:Ready,tracked:false}

    # test
    use ../nudot/types.nu is-file-record 
    assert not (is-file-record $r)

    # cleanup
    rm -rf $src $dest
}

export def test_is-file-record_invalid-path [] {
    # setup
    let src = mktemp -d
    let dest = mktemp -d
    rm -rf $dest
    let r = {src:$src,dest:$dest,status:Ready,tracked:false}

    # test
    use ../nudot/types.nu is-file-record 
    assert not (is-file-record $r)

    # cleanup
    rm -rf $src
}

# is-base-file
export def test_is-base-file_valid [] {
    # setup
    let b = {name:"",files:{}}
    # test
    use ../nudot/types.nu is-base-file
    assert (is-base-file $b)
}

export def test_is-base-file_invalid [] {
    # setup
    let b = {name:"",files:{foo:"bar"}}
    # test
    use ../nudot/types.nu is-base-file
    assert not (is-base-file $b)
}
