function __fuzzy-open-file-usage() {
    # Print usage
    echo "Usage: fuzzy-open-file [-a <application>] [-h] [-p <path>] [--vim] query"
    echo
    echo "Help: Search for, and open files from a shell."
    echo "\tBy default, opens specified file using the default application"
    echo "\tfor that file."
    echo "Options:"
    echo "\t-a\t\tOpens with the specified application."
    echo "\t-h, --help\tPrint this help message and exit."
    echo "\t-p, --path\tSearch only within the specified path (default: ~)."
    echo "\t--vim\t\tOpens file with vim."
}

function __fuzzy-open-file-unset-vars() {
    unset fof_vim_app_error
    unset fof_no_such_file_error
    unset fof_path
    unset fof_application
    unset fof_vim
    unset fof_query
    unset fof_filepath
}

function fuzzy-open-file() {
    fof_vim_app_error="-a and --vim are incompatible. Please only use one."
    fof_no_such_file_error="No matching files found."

    # Process arguments
    fof_path=$HOME
    while test $# != 0
    do
        case "$1" in
        -a)
            if [[ "$fof_vim" = true ]]; then
                echo $fof_vim_app_error
                echo
                __fuzzy-open-file-usage
                __fuzzy-open-file-unset-vars
                return 0
            else
                shift
                fof_application=$1
            fi ;;
        -h|--help)
            __fuzzy-open-file-usage
            __fuzzy-open-file-unset-vars
            return 0 ;;
        -p|--path)
            shift
            fof_path=$1 ;;
        --vim)
            if [[ ! -z $fof_application ]]; then
                echo $fof_vim_app_error
                echo
                __fuzzy-open-file-usage
                __fuzzy-open-file-unset-vars
                return 0
            else
                fof_vim=true
            fi ;;
        *)
            fof_query=$1 ;;
        esac
        shift
    done

    if [[ -z $fof_query ]]; then
        __fuzzy-open-file-usage
        __fuzzy-open-file-unset-vars
        return 0
    fi

    # Search for exact substring
    fof_filepath=$(mdfind -onlyin $fof_path "kMDItemDisplayName == '*$fof_query*'c" \
        | grep -v $HOME/Library \
        | head -1)

    # Fuzzy search
    if [[ -z $fof_filepath ]]; then
        fof_query="*$(echo "$fof_query" | sed 's/./&\*/g')" # query => *q*u*e*r*y*

        fof_filepath=$(mdfind -onlyin $fof_path "kMDItemDisplayName == '$fof_query'c" \
            | grep -v $HOME/Library \
            | head -1)

        if [[ -z $fof_filepath ]]; then
            # No matching file
            echo $fof_no_such_file_error
            __fuzzy-open-file-unset-vars
            return 0
        fi
    fi

    # Open file
    if [[ ! -z $fof_application ]]; then
        echo "Opening $fof_filepath in $fof_application"
        open -a "$fof_application" "$fof_filepath"
    elif [[ "$fof_vim" = true ]]; then
        echo "Opening $fof_filepath in vim"
        vim "$fof_filepath"
    else
        echo "Opening $fof_filepath"
        open "$fof_filepath"
    fi

    __fuzzy-open-file-unset-vars
}
