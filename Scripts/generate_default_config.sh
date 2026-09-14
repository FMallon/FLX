default_config_template(){

\printf "
apps = {


    flx = {

       target = \"%s\",
        
        args = {
            \"-d\",
            \"flx\"
        },

        background = false,

        wrapper = \"bash\",
        wrapper_args = {
            \"-x\",
        },

    },


    hello = {

        target = \"echo\",
        args = {
            \"Hello\",
        },

        background = false,

    }

}" "${SOURCE}"

}

generate_default_config(){

    if [[ ! -d "${CONFIG_DIR}" ]]; then

        \printf "\n[INFO] Config Directory doesn't exist, creating now...\n"
        mkdir -p "${CONFIG_DIR}" || {

            \printf "\n[ERROR] An error occured trying to create the Config Directory %s\n" "${CONFIG_DIR}"
            return 20

        }
        \printf "[SUCCESS] Config Directory has been successfully created!\n\n"


    fi 

    default_config_template > "${FILE_LUA_CONFIG}" || {

        \printf "\n[ERROR] An error occured while generating the Default Lua Config Template %s\n\n" "${FILE_LUA_CONFIG}"
        return 21

        }

    \printf "\n[SUCCESS] The Default Config has been generated!\n\n"
    return 0

    

}