#!/usr/bin/env bash

export HOMEBREW_NO_INSTALL_FROM_API=1

function init() {
    local url="$1"
    local name="$2"

    if [[ -z $url ]]; then
        echo "missing arg: url"
        exit 1
    fi

    if [[ -z $name ]]; then
        echo "missing arg: name"
        exit 1
    fi

    brew tap --force homebrew/core
    brew create "$url" --set-name="$name"
}

audit() {
    brew audit --new tomlv
}

install() {
    brew install --build-from-source --verbose --debug tomlv
}

test_formula() {
    brew test tomlv
}

all() {
    audit
    install
    test_formula
}

usage() {
    echo "Usage: $0 {init|audit|install|test|all}"
    echo ""
    echo "Commands:"
    echo "  init     - Create initial formula (tap homebrew/core and create formula)"
    echo "  audit    - Run brew audit on the formula"
    echo "  install  - Build and install from source"
    echo "  test     - Run brew test on the installed formula"
    echo "  all      - Run audit, install, and test in sequence"
    exit 1
}

# Main execution
command="$1"
shift
case "$command" in
    init) init "$1" "$2";;
    audit) audit;;
    install) install;;
    test) test_formula;;
    all) all;;
    *)
        echo "DEBUG: Unknown command: '$command'"
        usage
        ;;
esac
