#!/usr/bin/env bash
#
# Forge - Homebrew Formula Development Toolkit
#
# A comprehensive tool for developing, testing, and managing Homebrew formulas.
# Provides a streamlined workflow for formula creation, auditing, installation,
# and testing with proper error handling and validation.
#
# Usage: forge <command> [arguments]
#
# Author: benbenbang
# Repository: https://github.com/benbenbang/homebrew-forge
export HOMEBREW_NO_INSTALL_FROM_API=1

# Initialize a new Homebrew formula from a source URL
# Creates the formula file and sets up basic structure
# Args:
#   $1 - Source URL (tarball, zip, git repository)
#   $2 - Formula name (will be used as class name and binary name)
function init() {
    local url="$1"
    local name="$2"

    if [[ -z $url ]]; then
        echo "Error: URL is required"
        echo "Usage: forge init <url> <name>"
        echo "Example: forge init https://github.com/user/repo/archive/v1.0.tar.gz myapp"
        exit 1
    fi

    if [[ -z $name ]]; then
        echo "Error: Formula name is required"
        echo "Usage: forge init <url> <name>"
        echo "Example: forge init https://github.com/user/repo/archive/v1.0.tar.gz myapp"
        exit 1
    fi

    echo "🔨 Initializing formula '$name' from $url"
    brew tap --force homebrew/core
    brew create "$url" --set-name="$name"
    echo "✅ Formula '$name' created successfully"
}

# Run Homebrew audit on a formula to check for issues
# Validates formula syntax, style, and common problems
# Args:
#   $1 - Formula name to audit
audit() {
    local name="$1"
    if [[ -z $name ]]; then
        echo "Error: Formula name is required"
        echo "Usage: forge audit <name>"
        echo "Example: forge audit myapp"
        exit 1
    fi

    echo "🔍 Auditing formula '$name'..."
    brew audit --new "$name"
    echo "✅ Audit completed for '$name'"
}

# Install a formula from source with verbose output
# Builds the formula locally to test compilation and installation
# Args:
#   $1 - Formula name to install
install() {
    local name="$1"
    if [[ -z $name ]]; then
        echo "Error: Formula name is required"
        echo "Usage: forge install <name>"
        echo "Example: forge install myapp"
        exit 1
    fi

    echo "📦 Installing formula '$name' from source..."
    brew install --build-from-source --verbose --debug "$name"
    echo "✅ Installation completed for '$name'"
}

# Run the formula's test suite
# Executes the test block defined in the formula to verify functionality
# Args:
#   $1 - Formula name to test
test_formula() {
    local name="$1"
    if [[ -z $name ]]; then
        echo "Error: Formula name is required"
        echo "Usage: forge test <name>"
        echo "Example: forge test myapp"
        exit 1
    fi

    echo "🧪 Testing formula '$name'..."
    brew test "$name"
    echo "✅ Tests passed for '$name'"
}

# Complete validation workflow: audit + install + test
# Runs the full quality assurance pipeline for a formula
# Args:
#   $1 - Formula name to validate
validate() {
    local name="$1"
    if [[ -z $name ]]; then
        echo "Error: Formula name is required"
        echo "Usage: forge validate <name>"
        echo "Example: forge validate myapp"
        exit 1
    fi

    echo "🚀 Starting complete validation for '$name'..."
    audit "$name"
    install "$name"
    test_formula "$name"
    echo "🎉 Complete validation successful for '$name'"
}

# Create development directory structure for a new formula
# Sets up organized workspace for formula development and testing
# Args:
#   $1 - Formula name to create dev structure for
dev() {
    local name="$1"
    if [[ -z $name ]]; then
        echo "Error: Formula name is required"
        echo "Usage: forge dev <name>"
        echo "Example: forge dev myapp"
        exit 1
    fi

    local repo=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
    echo "🏗️  Creating development structure for '$name'..."

    mkdir -p "$repo/formula/$name/tests"
    touch "$repo/formula/$name/$name.rb"

    echo "Created directories:"
    echo "  📁 $repo/formula/$name/"
    echo "  📁 $repo/formula/$name/tests/"
    echo "  📄 $repo/formula/$name/$name.rb"
    echo "✅ Development structure ready for '$name'"
}

# Display help information and available commands
usage() {
    echo "🔨 Forge - Homebrew Formula Development Toolkit"
    echo ""
    echo "USAGE:"
    echo "    forge <command> [arguments]"
    echo ""
    echo "COMMANDS:"
    echo "    init <url> <name>     Create initial formula from source URL"
    echo "    audit <name>          Run brew audit to check for formula issues"
    echo "    install <name>        Build and install formula from source"
    echo "    test <name>           Run formula test suite"
    echo "    validate <name>       Complete workflow: audit + install + test"
    echo "    dev <name>            Create development directory structure"
    echo ""
    echo "EXAMPLES:"
    echo "    forge init https://github.com/user/repo/archive/v1.0.tar.gz myapp"
    echo "    forge audit myapp"
    echo "    forge install myapp"
    echo "    forge test myapp"
    echo "    forge validate myapp  # Runs audit, install, and test"
    echo "    forge dev newproject  # Creates development structure"
    echo ""
    echo "ENVIRONMENT:"
    echo "    HOMEBREW_NO_INSTALL_FROM_API=1  # Forces build from source"
    echo ""
    echo "For more information, visit: https://github.com/benbenbang/homebrew-forge"

    exit 1
}

# Main execution - parse command and dispatch to appropriate function
main() {
    local command="$1"

    # Show usage if no command provided
    if [[ -z "$command" ]]; then
        usage
    fi

    # shift  # Remove command from arguments

    case "$command" in
        init)
            init "$1" "$2"
            ;;
        audit)
            audit "$1"
            ;;
        install)
            install "$1"
            ;;
        test)
            test_formula "$1"
            ;;
        validate)
            validate "$1"
            ;;
        dev)
            dev "$1"
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            echo "❌ Unknown command: '$command'"
            echo ""
            usage
            ;;
    esac
}

# Run main function with all arguments
main "$@"
