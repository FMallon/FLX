validate_lua_check(){

    # bug: if bad lua code, like a file open operation in the lua config, fkn thing hangs.  So...
    #- try gtimeout? wont be available on many systems tho...
    # fix this

    "${CMD_VALIDATE_LUA[@]}"
    
}

validate_lua(){

    local check

    validate_lua_check >/dev/null 2>&1
    check=$?

    if (( check != 0 )); then
        
        \printf "\n[ERROR] There is an error with the Lua Config:\n"

        validate_lua_check

        \printf "\n"

        return 12
    fi

    return 0

}

validate_lua_option(){

    init_commands
    
    if ! validate_lua; then

        return 12
    
    fi

    \printf "\n[SUCCESS] The Lua Config passed the validation check!\n\n"
    return 0

}

# validate_lua_check(){

#     # bug: if bad lua code, like a file open operation in the lua config, fkn thing hangs.  So...
#     #- try gtimeout? wont be available on many systems tho...
#     # this is a bad idea, don't know how to account for this issue.

#     # maybe i will see if I can figure it out in the Lua Query, gonna have to account for debug functions that print too in the lua. 

#     if command -v gtimeout >/dev/null; then
        
#         \printf "\n[INFO] Performing with gtimeout!\n"
#         \printf "If the error message displays no info, it means there was a hang.\n"
#         \printf "There may be caused by a bad function in your Lua Config causing this, which could be due to file-io etc.\n\n"

#         gtimeout 8 "${CMD_VALIDATE_LUA[@]}"
    
#     else

#         \printf "\n[INFO] Performing default check without gtimeout!\n"
#         \printf "If there is a hang with this function, use [ctrl+c] to exit.\n"
#         \printf "There may be caused by a bad function in your Lua Config causing this, which could be due to file-io etc.\n\n"

#     fi


# }