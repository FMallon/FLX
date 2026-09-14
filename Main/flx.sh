#########################################################################################################################
#                                                                                                                       # 
#                                                     FLX                                                               #
#
#   [DESCRIPTION] FLX is a lightweight App Launcher & Local Bin written in Lua to run Scripts, Commands, Programs and Apps
#                                                                                              
#
#   [Dependencies]
#       Lua
#       Bash 3.2
#       Zsh
#
#                                                                                                                       #
#                                                                                                    [AUTHOR] F. Mallon #
#                                                                                                 COPYRIGHT © F. Mallon #
#########################################################################################################################

####       Return Codes        ####

# Return 1  - Error: Unsupported environment                                                                            
# Return 2  - Error: Unmet dependency
# Return 3  - Error: Invalid arg
# Return 4  - Error: Invalid no. of args                                 
#
###########-From flx_query.lua-#############
#
# Return 5  - Config file does not exist
# Return 6  - Invalid config file format
# Return 7  - Application name not found
# Return 8  - Invalid query
#
###################################################################################################
#
# Return 9  - Error: Sourcing required external Scripts
# Return 10 - Error: Finding Lua_Query script
# Return 11 - Error: Lua Config doesn't exist
# Return 12 - Error: Failure to pass validate_lua() check - there is an error in the config file
# Return 13 - Error: Empty app name passed to get_app_data()
# Return 14 - Error: The arg passed to validate_is_executable() is empty
# Return 15 - Error: The target/wrapper, if a file, is not executable
# Return 16 - Error: The target/wrapper is not a valid executable path/command
# Return 17 - Error: User-defined editor is invalid, resorting to defaults
# Return 18 - Error: No supported editor found on User's System
# Return 19 - Error: Failed running the editor to edit the Config File
# Return 20 - Error: Failure to create Config Directory
# Return 21 - Error: Failure to Generate Default Config
#
###################################################################################################

# Don't double bracket, because if shell, it will print "[[: not found" error which looks like shit
if [ -n "${BASH_VERSION}" ]; then

  SOURCE="${BASH_SOURCE[0]}"

elif [ -n "${ZSH_VERSION}" ]; then

  SOURCE="${(%):-%x}"
  IS_ZSH="true"

else

  \printf "\n[ERROR] This is not a supported environment\n\n"
  return 1

fi


while [[ -L "${SOURCE}" ]]; do

  DIR="$(cd -P "$(dirname "${SOURCE}")" && pwd)"

  SOURCE="$(readlink "${SOURCE}")"

  [[ "${SOURCE}" != /* ]] && SOURCE="${DIR}/${SOURCE}"

done


SOURCE_DIR="$(cd "$(dirname "${SOURCE}")/.." && pwd)"

MAIN_DIR="${SOURCE_DIR}/Main"
SCRIPTS_DIR="${SOURCE_DIR}/Scripts"
CONFIG_DIR="${SOURCE_DIR}/Configs"



################### FILES #####################

FILE_LUA_CONFIG="${CONFIG_DIR}/flx.lua"
FILE_LUA_QUERY="${SCRIPTS_DIR}/flx_query.lua"

###############################################


############## LUA COMMANDS ###################

init_commands(){


  CMD_VALIDATE_LUA=("lua" "${FILE_LUA_QUERY}" "validate_lua" "${FILE_LUA_CONFIG}")

  #- App
  CMD_GET_ALL_APP_NAMES=("lua" "${FILE_LUA_QUERY}" "get_all_app_names" "${FILE_LUA_CONFIG}")

  CMD_GET_APP_NAME=("lua" "${FILE_LUA_QUERY}" "get_app_name" "${FILE_LUA_CONFIG}" "${alias}")
  CMD_GET_APP_TARGET=("lua" "${FILE_LUA_QUERY}" "get_app_target" "${FILE_LUA_CONFIG}" "${alias}")
  CMD_GET_APP_ARGS=("lua" "${FILE_LUA_QUERY}" "get_app_args" "${FILE_LUA_CONFIG}" "${alias}")
  CMD_GET_APP_BACKGROUND=("lua" "${FILE_LUA_QUERY}" "get_app_background" "${FILE_LUA_CONFIG}" "${alias}")
  CMD_GET_APP_WRAPPER=("lua" "${FILE_LUA_QUERY}" "get_app_wrapper" "${FILE_LUA_CONFIG}" "${alias}")
  CMD_GET_APP_WRAPPER_ARGS=("lua" "${FILE_LUA_QUERY}" "get_app_wrapper_args" "${FILE_LUA_CONFIG}" "${alias}")



  #-Editor
  CMD_GET_EDITOR_NAME=("lua" "${FILE_LUA_QUERY}" "get_editor_name" "${FILE_LUA_CONFIG}")
  CMD_GET_EDITOR_ARGS=("lua" "${FILE_LUA_QUERY}" "get_editor_args" "${FILE_LUA_CONFIG}")


}

##########################################################


############## IMPORT EXTERNAL SCRIPTS ###################

import_scripts(){


  local scripts=(
    "${SCRIPTS_DIR}/build_command.sh"
    "${SCRIPTS_DIR}/check_file_exists.sh"
    "${SCRIPTS_DIR}/check_requirements.sh"
    "${SCRIPTS_DIR}/debug_display_args.sh"
    "${SCRIPTS_DIR}/debug_mode.sh"
    "${SCRIPTS_DIR}/display_all_apps.sh"
    "${SCRIPTS_DIR}/display_app.sh"
    "${SCRIPTS_DIR}/edit_config.sh"
    "${SCRIPTS_DIR}/generate_default_config.sh"
    "${SCRIPTS_DIR}/get_app_data.sh"
    "${SCRIPTS_DIR}/print_app_info.sh"
    "${SCRIPTS_DIR}/run_command.sh"
    "${SCRIPTS_DIR}/sanitize_string.sh"
    "${SCRIPTS_DIR}/usage.sh"
    "${SCRIPTS_DIR}/validate_is_executable.sh"
    "${SCRIPTS_DIR}/validate_lua.sh"
  )

  for script in "${scripts[@]}"; do

    source "${script}" || {

      \printf "\n[ERROR] There was an error sourcing an external script: '%s'\n" "${script}"
      \printf "\nJust like Leonardo Da Vinci cannot work without paint, a paint brush, and a canvas, FLX cannot work without this script present.\n"
      \printf "\nBackup your Config, and try re-cloning the repo to fix this issue.\n\n"
      return 9

    }

  done

}


##########################################################


flx_main(){

  import_scripts || return $?

  case "${1}" in

   #verify-app - a dry-run to see the laucher args
   #generate-default-config - gen a default config
   #

    -da | --display-all-apps)

      shift

      if (( $# > 0 )); then

        \printf "\n[ERROR] Invalid no. of args!\n\n"
        return 4

      fi

      display_all_apps "${@}" || return $?

    ;;

    -d | --display-app)

      shift

      if (( $# > 1 )); then

        \printf "\n[ERROR] Invalid no. of args!\n\n"
        return 4

      fi

      display_app "${@}" || return $?

    ;;

    -e | --edit)

      shift

      if (( $# > 0 )); then

        \printf "\n[ERROR] Invalid no. of args!\n\n"
        return 4

      fi

      edit_config || return $?

    ;;

    -h | --help)

      shift
      
      if (( $# > 0 )); then

        \printf "\n[ERROR] Invalid no. of args!\n\n"
        return 4

      fi

      usage

    ;;

    --generate-default-config)

      shift
      
      if (( $# > 0 )); then

        \printf "\n[ERROR] Invalid no. of args!\n\n"
        return 4

      fi
      
      generate_default_config

    ;;

    --debug)

      shift
      
      debug_mode "${@}" || return $?

    ;;

    -vc | --validate-config)

      validate_lua_option || return $?

    ;;

    --)

      shift
      run_command "${@}" || return $?

    ;;


    *)

      \printf "\n[ERROR] Invalid option!\n\n"
      return 3

    ;;

  esac


  return 0


}


flx_main "${@}"
