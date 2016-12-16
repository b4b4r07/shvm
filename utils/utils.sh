shvm_filter()
{
    if [ -z "$1" ]; then
        return 1
    fi

    candidates="$1:"
    while [ -n "$candidates" ]
    do
        # the first remaining entry
        x=${candidates%%:*}
        # reset candidates
        candidates=${candidates#*:}
        if type "${x%% *}" >/dev/null 2>&1; then
            echo "$x"
            return 0
        else
            continue
        fi
    done

    return 1
}
