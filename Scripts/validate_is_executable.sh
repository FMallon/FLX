validate_is_executable(){

    local use="${1}"
    local executable="${2}"

    
    if [[ "${executable}" == "nil" || "${executable}" == "" || -z "${executable}" ]]; then
    
        \printf "\n[ERROR] The %s option for %s is empty in the Lua Config!\n\n" "${use}" "${app_name}"
        return 14

    fi


    if [[ -f "${executable}" ]]; then

        if [[ ! -x "${executable}" ]]; then

            \printf "\n\n[ERROR] The file %s is not executable\n\n" "${executable}"
            \printf "The File must be executable to run!\n\n"
            return 15

        else 
        
            return 0

        fi

    fi


    if ! command -v "${executable}" &>/dev/null; then

        \printf "\n[ERROR] The %s option for %s is an invalid path or binary, please re-verify the Lua configuration!\n\n" "${use}" "${alias}"
        return 16

    fi

    return 0

}
