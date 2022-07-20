#!/bin/sh
set -o nounset

Logo () {
cat <<EOF

    $name
    $link

EOF
}

Usage () {
cat <<EOF
usage: ./$script_name
   or: ./$script_name uninstall
EOF
}

Install () {
    test -d "$target_dir" || mkdir -p "$target_dir" || return
    install jg "$target_dir" || return
    printf "Install complete.\n"
}

Uninstall () {
    if test ! -d "$target_dir"
    then
        >&2 printf "error: not installed\n"
        return 1
    fi
    rm -f "$target_dir/jg" || return
    rmdir "$target_dir" 2>/dev/null
    printf "Uninstall complete.\n"
}

ParseArgs () {
    local val
    if test $# -eq 0
    then
        Install
        return
    elif test $# -eq 1
    then
        case $1 in
        -h|--help)
            Logo
            Usage
            exit 0
            ;;
        0|uninstall)
            Uninstall
            return
            ;;
        1|install)
            Install
            return
            ;;
        *)
            >&2 printf "error: invalid argument \`%s'\n" "$1"
            >&2 Usage
            exit 1
            ;;
        esac
    else
        >&2 printf "error: too many arguments\n"
        >&2 Usage
        exit 1
    fi
}

GetTargetDir () {
    local OS=${OS-}
    if printf "%s" "$OS" | grep -qi "win"
    then
        target_dir="$HOME/bin"
    else
        target_dir="/usr/local/bin"
    fi
}

main () {
    local script_name=$(basename "$0")
    local script_dir=$(dirname "$0")
    local name="jg installation script"
    local link="https://lxvs.net/jg"
    local target_dir
    cd "$script_dir" || return
    GetTargetDir
    ParseArgs "$@" || return
}

main "$@"
