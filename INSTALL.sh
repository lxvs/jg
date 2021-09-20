#!/bin/bash
set -o nounset
set -o pipefail

Usage(){
cat <<USG

    $NAME $VER
    $LINK

Install with one of below command:
    ./INSTALL.sh 1
    ./INSTALL.sh install
    ./INSTALL.sh deploy

Uninstall:
    ./INSTALL.sh 0
    ./INSTALL.sh uninstall
    ./INSTALL.sh remove
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
        >&2 Prompt red "ERROR: Unknown color argument - $COLOR_ARG"
        return 1
        ;;
    esac
    printf "${color}%s${RST}\n" "$@"
}

Install () {
    test -d "$target_dir" || mkdir "$target_dir" || return
    cp jg "$target_dir" || return
    chmod +x "$target_dir/jg"
    Prompt green "Complete."
}

Uninstall () {
    if test ! -e "$target_dir/jg"
    then
        Prompt red "ERROR: not installed yet."
        return 1
    fi
    RemoveDeprecated
    rm --force -- "$target_dir/jg"
    rmdir "$target_dir" 2>/dev/null
    Prompt green "Complete."
}

RemoveDeprecated () {
    # test ! -d "$target_dir" && return
    # Prompt yellow "Removing deprecated commands..."
    pushd "$target_dir" 1>/dev/null
    rm --force -- jgamendlastcommit jgcommitnumber jgforeachrepodo \
        jgjustpullit jggrepacommit jgjustpullit jgmakesomediff \
        jgnumberforthehistory jgpush jgstash jgversion
    popd 1>/dev/null
}

GetTargetDir () {
    if grep -qi '^win' <<<"$OS"
    then
        target_dir="$HOME/bin"
    else
        target_dir="/usr/local/bin"
    fi
}

ParseArgs () {
    if test ! $# -eq 1
    then
        Usage
        return
    fi
    case "$1" in
    1|install|deploy) Install ;;
    0|uninstall|remove) Uninstall ;;
    *) Usage ;;
    esac
}

main () {
    local -r NAME="Johnny's Git Kit"
    local -r LINK="https://github.com/lxvs/jg"
    local -r VER="2.0.0"
    local target_dir
    pushd "$(dirname "$0")" 1>/dev/null
    GetTargetDir
    ParseArgs "$@"
}

main "$@"
