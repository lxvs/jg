#!/bin/bash

rev=$(cat VERSION 2>/dev/null)
[[ -z $rev ]] && echo "Warning: failed to get version"
pushd $(dirname $0) 1>/dev/null
echo "Johnny's Git Kit $rev Deployment"
echo "https://github.com/lxvs/jg"
echo ""

script_name="./$(basename $0)"
if [ "${OS:0:7}" == "Windows" ]; then
    target_dir="/c/Users/$USERNAME/bin"
else
    target_dir="/usr/local/bin"
fi

if [[ $# -eq 1 ]]; then
    if [[ "$1" == "1" || "$1" == "deploy" ]]; then
        if [[ ! -d $target_dir ]]; then
            mkdir $target_dir
        fi

        echo "Copying..."

        for jgfile in ./bin/jg*
        do
            cp $jgfile $target_dir || exit 102
            chmod +x $target_dir/$(basename $jgfile)
        done

        if [[ ! -z $rev ]]; then
            echo "#!/bin/bash" > $target_dir/jgversion
            echo "echo \"Johnny's Git Kit $rev\"" >> $target_dir/jgversion
            echo "echo \"https://github.com/lxvs/jg\"" >> $target_dir/jgversion
        fi

        chmod +x $target_dir/jgversion

        echo "Deployment finished"
        exit 0

    elif [[ "$1" == "0" || "$1" == "remove" ]]; then

        if ! compgen -G "$target_dir/jg*" >/dev/null; then
            echo "ERROR: there is no Johnny's Git Kit deployed" >&2
            exit 2
        fi

        echo "Removing deprecated commands..."
        rm -f "$target_dir/jg" || exit 103
        rm -f "$target_dir/jgstash" || exit 103

        echo "Removing Johnny's Git Kit..."

        for jgfile in ./bin/jg*
        do
            rm -f $target_dir/$(basename $jgfile) || exit 103
        done
        rm -f $target_dir/jgversion || exit 103

        echo "Removal finished"
        exit 0

    else
        echo "invalid option: $1" >&2
        echo "To deploy, use command 'sudo $script_name 1' or 'sudo $script_name deploy'" >&2
        echo "To remove, use command 'sudo $script_name 0' or 'sudo $script_name remove'" >&2
        exit 1
    fi
elif [[ $# -eq 0 ]]; then
    echo "To deploy, use command 'sudo $script_name 1' or 'sudo $script_name deploy'"
    echo "To remove, use command 'sudo $script_name 0' or 'sudo $script_name remove'"
    exit 0
else
    echo "invalid option: $@" >&2
    echo "To deploy, use command 'sudo $script_name 1' or 'sudo $script_name deploy'" >&2
    echo "To remove, use command 'sudo $script_name 0' or 'sudo $script_name remove'" >&2
    exit 1
fi
