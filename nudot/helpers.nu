# helpers.nu

export def guard [guards: list func: closure] {
    if ($guards | all {$in == true}) {
        do $func
    } else { null }
}
