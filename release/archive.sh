#!/bin/sh

# SC1007: Allow space after variable=
# Allow local at it is supported on most shells
# shellcheck disable=SC1007,SC3043

# Install below things before use:
#  * Ruby
#  * asciidoctor-pdf (with `gem install asciidoctor-pdf')
#  * fonts used in theme file
#  * 7-zip, or jai, to its default location
#  * Git 2.36.0 or any later version

set -o nounset

archive_cleanup () {
    cd "$scriptdir" || exit
    rm -rf tmp/
}

is_windows () {
    test "${_is_windows++}" && { test "$_is_windows" && return || return; }
    case $(uname -s) in
        CYGWIN*|MINGW*|MSYS*)
            _is_windows=1
            return 0
            ;;
        *)
            _is_windows=
            return 1
            ;;
    esac
}

archive () {
    local exe_from_7zip exe_from_jai
    local description toplevel
    if type 7za >/dev/null 2>&1; then
        exe7z=7za
    elif is_windows; then
        exe_from_7zip="C:/Program Files/7-Zip/7z.exe"
        exe_from_jai="C:/Users/$USERNAME/AppData/Local/Programs/jai/7za.exe"
        if test -x "$exe_from_7zip"; then
            exe7z=$exe_from_7zip
        elif test -x "$exe_from_jai"; then
            exe7z=$exe_from_jai
        else
            >&2 printf "error: no 7-Zip excutable available\n"
            return 1
        fi
    else
        >&2 printf "error: no 7-Zip excutable available\n"
        return 1
    fi
    printf "using %s\n" "$exe7z"
    rm -rf tmp/ || return
    mkdir tmp || return
    trap archive_cleanup INT TERM
    toplevel=$(git rev-parse --show-toplevel) || return
    description=$(git describe --always HEAD) || return
    description=${description#v}
    fname="$name-$description"
    mkdir "tmp/$fname" || return
    (
        cd "$toplevel" || return
        git ls-files --recurse-submodules -t \
            | grep '^H ' \
            | cut -d' ' -f2- \
            | git check-attr --stdin export-ignore \
            | grep -v ': set$' \
            | cut -d':' -f1 \
            | tr '\n' '\0' \
            | xargs -0 cp --parents -r -t "$scriptdir/tmp/$fname" \
            || return
    ) || return
    (
        set -e
        set +o noglob
        cd "tmp/$fname"
        (
            cd ..
            tar -zcf "../$fname.tgz" "$fname"
            "$exe7z" a -mx9 "../$fname.7z" "$fname"
        )
        "$exe7z" a -mx9 "$name.7z" -- *
        if is_windows; then
            cmd //c "copy /b ..\\..\\$name.sfx + $name.7z $(cygpath -w "../../$fname.exe")"
        else
            cat "../../$name.sfx" "$name.7z" >"../../$(basename "$PWD").exe"
        fi
    ) || return
}

print_adoc () {
    ls ../*.adoc 1>/dev/null 2>&1 || return 0
    asciidoctor -a scripts=cjk \
        -a webfonts! \
        -a toc=left \
        ../readme.adoc \
        -D . \
        -o "$name/index.html" || return
    "$exe7z" a -mx9 "$fname-site.7z" -- "$name"
}

main () {
    local scriptdir name fname exe7z _is_windows
    scriptdir=$(cd "$(dirname "$0")" && pwd) || exit
    name=$(basename -- "$(cd "$(git rev-parse --show-toplevel)" && pwd)") || exit
    cd "$scriptdir" || exit
    archive || return
    print_adoc
    archive_cleanup
}

main "$@"
