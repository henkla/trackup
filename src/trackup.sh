#!/usr/env/bin bash

# Author: Henrik Larsson
# E-mail: lthlarsson@gmail.com
# Full documentation can be found at github.com/henkla/trackup
# ---

readonly SCRIPT=$(basename $0)
readonly TRACKED_FILES="${HOME}/.local/bin/${SCRIPT}.list"
readonly OPTIONS=":shla:r:c"

OPT_ADD=
ARG_ADD=()
OPT_REMOVE=
ARG_REMOVE=()
OPT_CLEAN=
OPT_LIST=
OPT_STATUS=
OPT_HELP=

parse_options () {

    for arg in "$@"; do
        shift
        case "$arg" in

            "--help")                                   set -- "$@" "-h";;
            "--list"|"--list-files"|"--list-all")       set -- "$@" "-l";;
            "--status"|"--show-status"|"--list-status") set -- "$@" "-s";;
            "--add"|"--add-file")                       set -- "$@" "-a";;
            "--remove"|"--remove-file")                 set -- "$@" "-r";;
            "--clean"|"--clean-files")                  set -- "$@" "-c";;
            "--"*)                                      print_error "option \"${arg}\" is unknown"; exit 1;;
            *)                                          set -- "$@" "$arg"

        esac
    done

    while getopts "${OPTIONS}" arg; do
        case "$arg" in

            h) OPT_HELP=1;;
            l) OPT_LIST=1;;
            s) OPT_STATUS=1;;
            a) OPT_ADD=1;       ARG_ADD+=( ${OPTARG} );;
            r) OPT_REMOVE=1;    ARG_REMOVE+=( ${OPTARG} );;
            c) OPT_CLEAN=1;;
            :) print_error "option -\"${OPTARG}\" demands an argument"; exit 1;;
           \?) print_error "option -\"${OPTARG}\" is unknown"; exit 1;;

        esac
    done

    shift $((OPTIND-1))
    [[ -z $@ ]] || {
        print_error "option \"${@}\" is unknown"; exit 1
    }
}

init () {

    [[ -f $TRACKED_FILES ]] || touch $TRACKED_FILES
}

print_usage () {

cat <<- EOF
    USAGE: 
    ${SCRIPT} [-hlsc] [-ar ARG]
    DESCRIPTION:
    Keeps track of files that you want to backup. It does so by
    storing their path, so that it easily can be retrieved at a
    later point. Also has the ability to check the validity of 
    the paths, and also to remove any path that is no longer 
    valid.
    OPTIONS:
        -h, --help              displays this help section
        -l, --list              prints all stored paths to stdout
        -s, --status            checks the validity of each stored path
        -a, --add       [PATH]  add a new file to be tracked
        -r, --remove    [PATH]  removes a previously tracked file
        -c, --clean             will remove any stored path that is not valid
    * Note that combined short options are allowed: "-cl" will be
      interpreted the same way as "--clean --list".
    
    EXAMPLES:
    - Clean all non-valid paths and display all tracked paths after this operation:
        ${SCRIPT} -cl
    - Add a new file to be tracked:
        ${SCRIPT} -a somefile
        
    DOCUMENTATION:
    Full documentation can be found at github.com/henkla/trackup
    
EOF

}

print_error () {

    echo "${SCRIPT}: ${@}. Use \"--help\" for more info."
}

path_is_valid () {

    [[ -f $1 ]] || return 1
    return 0
}

file_is_tracked () {

    while read -r line; do
        [[ ${line} == ${1} ]] && return 0
    done < $TRACKED_FILES
    return 1
}

remove_file_from_list () {

    if file_is_tracked "${1}"; then
        temp_file=$(mktemp)
        while read -r line; do
            [[ $line != ${1} ]] && echo "$line"
        done <$TRACKED_FILES > $temp_file
        mv $temp_file $TRACKED_FILES
    fi
}

sort_tracked_files () {
 
    temp_file=$(mktemp)
    sort -n $TRACKED_FILES > $temp_file
    mv $temp_file $TRACKED_FILES
}

list_files () {

    cat $TRACKED_FILES | xargs
}

list_file_status () {

    while read -r line; do
        status=" "
        [[ -f ${line} ]] && status="x"
        printf "[${status}] ${line}\n"
    done < $TRACKED_FILES
}

add_files () {

    for path in "${ARG_ADD[@]}"; do

        local full_path=$(readlink -e $path)
        if path_is_valid "$path"; then

            if file_is_tracked "$full_path"; then
                echo "[!] \"${full_path}\" is already being tracked..."
            else
                echo "[+] \"${full_path}\""
                echo ${full_path} >> "$TRACKED_FILES"
                sort_tracked_files
            fi

        else
            echo "[!] \"${path}\" is not a valid file..."
        fi

    done

}

remove_files () {

    for path in "${ARG_REMOVE[@]}"; do

        local full_path=$(readlink -f $path)
        if file_is_tracked "${full_path}"; then
            echo "[-] \"${full_path}\""
            remove_file_from_list "${full_path}"
        else
            echo "[!] \"${path}\" is not being tracked..."
        fi

    done
}

clean_tracked_files () {
        
    temp_file=$(mktemp)
    local counter=0
    
    while read -r line; do
        if [[ -f $line ]]; then
            echo "$line"
        else
            ((counter++))
        fi
    done <$TRACKED_FILES > $temp_file
    mv $temp_file $TRACKED_FILES

    if [[ $counter -gt 0 ]]; then
        local entry="entries"
        [[ $counter -eq 1 ]] && entry="entry"
        echo "Cleaned out ${counter} ${entry}"
    fi
}

# main
# ______________________

init
parse_options "$@"


[[ $OPT_HELP -eq 0 ]] || { print_usage; exit 0; }

[[ $OPT_STATUS -eq 0 ]] || list_file_status
[[ $OPT_CLEAN -eq 0 ]] || clean_tracked_files
[[ $OPT_LIST -eq 0 ]] || list_files

[[ $OPT_ADD -eq 0 ]] || add_files
[[ $OPT_REMOVE -eq 0 ]] || remove_files


exit 0
