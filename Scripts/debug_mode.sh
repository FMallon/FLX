debug_mode(){

    get_app_data "${@}" || return $?
    

    build_command "${@}" || return $?

 
    debug_display_args "${cmd_run_app[@]}"

    \printf "\n"
    

}