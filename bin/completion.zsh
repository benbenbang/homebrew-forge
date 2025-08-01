#compdef forge

_forge() {
    local -a args
    args=(
        "init:Create initial formula (tap homebrew/core and create formula)"
        "audit:Run brew audit on the formula"
        "install:Build and install from source"
        "test:Run brew test on the installed formula"
        "validate:Run audit, install, and test in sequence"
        "dev:Create dev kit & some directories"
    )
    _describe -t commands "forge command" args
}

compdef _forge forge
