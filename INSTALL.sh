#!/bin/bash
set -o nounset

Usage(){
cat <<USG
$NAME
$LINK

usage: ./INSTALL.sh [<options>]

options:
    -h, --help                  Get Help
    -p, --prefix <prefix>       Specify installation prefix
    -u, --uninstall             Uninstall

Default prefix is /usr/local in Linux or \$HOME in CYGWIN/MINGW.
USG
}

# $1    : Color - red/yellow/green
# ...   : string lines
Prompt () {
    local -r RED="[91m"
    local -r GRN="[92m"
    local -r YLW="[93m"
    local -r RST="[0m"
    local -r COLOR_ARG="$1"
    local color
    shift
    case "$COLOR_ARG" in
    r|red) color="$RED" ;;
    g|grn|green) color="$GRN" ;;
    y|ylw|yellow) color="$YLW" ;;
    *)
        >&2 Prompt red "error: unknown color - $COLOR_ARG"
        return 1
        ;;
    esac
    printf "${color}%s${RST}\n" "$@"
}

Install () {
    test -d "$bin" || mkdir -p "$bin" || return
    install jg "$bin" || return
    Prompt green "Complete."
}

Uninstall () {
    if test ! -e "$bin/jg"
    then
        >&2 Prompt red "error: not installed yet."
        return 1
    fi
    rm --force -- "$bin/jg" || return
    RemoveDeprecated
    rmdir "$bin" 2>/dev/null
    Prompt green "Complete."
}

RemoveDeprecated () {
    pushd "$bin" 1>/dev/null
    rm --force -- jgamendlastcommit jgcommitnumber jgforeachrepodo \
        jgjustpullit jggrepacommit jgjustpullit jgmakesomediff \
        jgnumberforthehistory jgpush jgstash jgversion
    popd 1>/dev/null
}

GetPrefix () {
    local uname
    test "${pfx-}" && return
    uname=$(uname -s)
    case "$uname" in
        Linux*)
            pfx="/usr/local"
            ;;
        CYGWIN*|MINGW*)
            pfx="$HOME"
            ;;
        *)
            >&2 Prompt red "error: unknown uname: $uname; please specify prefix with --prefix."
            return 1
            ;;
    esac
}

ParseArgs () {
    local val
    while test $# -ge 1
    do
        case "$1" in
        -h|--help)
            Usage
            exit
            ;;
        -p|--prefix)
            psv "$@" || return
            pfx="$val"
            shift 2
            ;;
        -u|--uninstall)
            uninst=1
            shift
            ;;
        *)
            >&2 Prompt red "error: invalid argument: $1"
            return 1
            ;;
        esac
    done
}

psv () {
    if test $# -ge 2 && ! grep -q '^-' <<<"$2"
    then
        val="$2"
        return 0
    fi
    >&2 Prompt red "error: $1 requires a value."
    return 1
}

main () {
    local -r NAME="Johnny's Git Kit"
    local -r LINK="https://github.com/lxvs/jg"
    local pfx uninst bin
    pushd "$(dirname "$0")" 1>/dev/null
    ParseArgs "$@" || return
    GetPrefix || return
    bin="$pfx/bin"
    if test "${uninst-}"
    then
        Uninstall
    else
        Install
    fi
}


main "$@"
