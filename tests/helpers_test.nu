# tests/config/core_test.nu
use std assert

export def test_guard_all-true [] {
    # setup
    let guards = [(1 > 0) (10 / 2 == 5) true]
    let func = { 3 * 2}

    # test
    use ../nudot/helpers.nu *
    let result = (guard $guards $func)

    assert ($result == 6)
}

export def test_guard_not-true [] {
    # setup
    let guards = [(1 < 0) (10 / 2 == 5) true]
    let func = { 3 * 2}

    # test
    use ../nudot/helpers.nu *
    let result = (guard $guards $func)

    assert ($result == null)
}
