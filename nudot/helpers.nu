# helpers.nu

export def guard [guards: list do: closure else: closure] {
    if ($guards | all {$in == true}) {
        do $do
    } else { do $else }
}
