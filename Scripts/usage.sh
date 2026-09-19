usage() {

    \printf "\nFLX - App Launcher & Local Bin\n\n"

    \printf "Usage:\n\n"
    \printf "  flx <arg>\n"
    \printf "  flx <arg> <app_name>\n"
    \printf "  flx <arg> <app_name> <extra_args...>\n\n"

    \printf "General Options:\n\n"
    \printf "  %-40s %s\n" "-h, --help" "Show usage"

    \printf "\nConfig Options:\n\n"
    \printf "  %-40s %s\n" "--generate-default-config" "Generate a default config"
    \printf "  %-40s %s\n" "-vc, --validate-config" "Validate the Lua config"
    \printf "  %-40s %s\n" "-e, --edit" "Edit the config file"
    \printf "  %-40s %s\n" "-ed, --edit-defaults" "Edit the config file with default editor - in the event where the User's editor choice won't launch due to a switch from Graphical Environment to a TTY"


    \printf "\nDisplay Options:\n\n"
    \printf "  %-40s %s\n" "-da, --display-all-apps" "Display all apps in the Lua config with their info"
    \printf "  %-40s %s\n" "-d, --display-app <app_name>" "Display information for the specified app"

    \printf "\nExecution:\n\n"
    \printf "  %-40s %s\n" "-- <app_name> <optional_extra_args>" "Run the program, command, script or app"

    \printf "\nDebug Options:\n\n"
    \printf "  %-40s %s\n" "--debug <app_name> <optional_extra_args>" "Print the args in array format for debugging"

    \printf "\n"

    return 0
    
}
