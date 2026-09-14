print_app_info(){


    local value
    local formatted_args=""
    local formatted_wrapper_args=""
    local i

    # -------------------------------------------------------------------------
    # Format normal arguments
    # -------------------------------------------------------------------------

    for i in "${!args[@]}"; do

        \printf -v value '"%s"' "${args[i]}"

        if (( i > 0 )); then

            formatted_args+=", "

        fi

        formatted_args+="${value}"

    done

    # -------------------------------------------------------------------------
    # Format wrapper arguments
    # Only display them when a wrapper actually exists.
    # -------------------------------------------------------------------------

    if [[ -n "${wrapper:-}" ]]; then
        
        for i in "${!wrapper_args[@]}"; do
        
            \printf -v value '"%s"' "${wrapper_args[i]}"

            if (( i > 0 )); then

                formatted_wrapper_args+=", "

            fi

            formatted_wrapper_args+="${value}"

        done

    fi


    # -------------------------------------------------------------------------
    # Calculate table width
    # -------------------------------------------------------------------------

    local label_width=14
    local value_width=55
    local total_width=$(( label_width + value_width + 5 ))

    local line

    \printf -v line '%*s' "${total_width}" ''

    line="${line// /─}"


    # -------------------------------------------------------------------------
    # Application header
    # -------------------------------------------------------------------------

    \printf '\n'
    \printf '╭%s╮\n' "${line}"
    \printf '│%*s%*s│\n' \
        $(( (total_width + 12) / 2 )) 'APPLICATION' \
        $(( (total_width - 12) / 2 )) ''
    \printf '├%s┤\n' "${line}"


    # -------------------------------------------------------------------------
    # Application data
    # -------------------------------------------------------------------------

    \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Name' \
        "${value_width}" "${app_name}"

    [[ -n "${target:-}" ]] &&
        \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Target' \
        "${value_width}" "${target}"

    [[ -n "${formatted_args}" ]] &&
        \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Args' \
        "${value_width}" "${formatted_args}"

    [[ -n "${background:-}" ]] &&
        \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Background' \
        "${value_width}" "${background}"

    [[ -n "${wrapper:-}" ]] &&
        \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Wrapper' \
        "${value_width}" "${wrapper}"

    [[ -n "${formatted_wrapper_args}" ]] &&
        \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Wrapper Args' \
        "${value_width}" "${formatted_wrapper_args}"

    \printf '╰%s╯\n\n' "${line}"

    
}

# This is the zShell equivelent to get rid of that bad substition error caused by the use of ${!array[@]}
#- zShell uses a different method completely, so I will see if i can alias a function;
#-- but that might be a bad idea and could lead to a lot of unknowns and hidden bugs
#- So I will just do a true/false, then an if statement, should work fine because it's only used in one place;
print_app_info_zsh(){

    local value
    local formatted_args=""
    local formatted_wrapper_args=""
    local i

    # -------------------------------------------------------------------------
    # Format normal arguments
    # -------------------------------------------------------------------------

    for i in {1..${#args}}; do
        \printf -v value '"%s"' "${args[i]}"

        if (( i > 1 )); then
            formatted_args+=", "
        fi

        formatted_args+="${value}"
    done

    # -------------------------------------------------------------------------
    # Format wrapper arguments
    # -------------------------------------------------------------------------

    if [[ -n "${wrapper:-}" ]]; then
        for i in {1..${#wrapper_args}}; do
            \printf -v value '"%s"' "${wrapper_args[i]}"

            if (( i > 1 )); then
                formatted_wrapper_args+=", "
            fi

            formatted_wrapper_args+="${value}"
        done
    fi

    # -------------------------------------------------------------------------
    # Calculate table width
    # -------------------------------------------------------------------------

    local label_width=14
    local value_width=55
    local total_width=$(( label_width + value_width + 5 ))

    local line

    \printf -v line '%*s' "${total_width}" ''

    line="${line// /─}"

    # -------------------------------------------------------------------------
    # Application header
    # -------------------------------------------------------------------------

    \printf '\n'
    \printf '╭%s╮\n' "${line}"
    \printf '│%*s%*s│\n' \
        $(( (total_width + 12) / 2 )) 'APPLICATION' \
        $(( (total_width - 12) / 2 )) ''
    \printf '├%s┤\n' "${line}"

    # -------------------------------------------------------------------------
    # Application data
    # -------------------------------------------------------------------------

    \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Name' \
        "${value_width}" "${app_name}"

    [[ -n "${target:-}" ]] &&
        \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Target' \
        "${value_width}" "${target}"

    [[ -n "${formatted_args}" ]] &&
        \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Args' \
        "${value_width}" "${formatted_args}"

    [[ -n "${background:-}" ]] &&
        \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Background' \
        "${value_width}" "${background}"

    [[ -n "${wrapper:-}" ]] &&
        \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Wrapper' \
        "${value_width}" "${wrapper}"

    [[ -n "${formatted_wrapper_args}" ]] &&
        \printf '│ %-*s │ %-*s │\n' \
        "${label_width}" 'Wrapper Args' \
        "${value_width}" "${formatted_wrapper_args}"

    \printf '╰%s╯\n\n' "${line}"

}   