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
usage: ./install.sh
   or: ./install.sh uninstall
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
        0|uninstall|--uninstall)
            Uninstall
            return
            ;;
        1|install|--install)
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
    local name="jg installation script"
    local link="https://gitlab.com/lzhh/jg"
    local target_dir
    cd "$(dirname "$0")" || return
    GetTargetDir
    ParseArgs "$@" || return
}

main "$@"
