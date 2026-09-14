debug_display_args(){

    # better info - e.g. The target option is empty in the lua config is shite.  Try, the Target variable(?) for $alias is empty or some shit
    local args=("${@}")
    local i=0

    ((${#args[@]})) && \printf "\n\n[COMMAND] %s\n\n" "${args[*]}"

    for arg in "${args[@]}"; do

        \printf "[arg%d] %s\n" "$i" "${arg}"
        ((i++))

    done

}
