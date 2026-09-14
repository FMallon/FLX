display_all_apps() {


  # don't ever remove this again! Waste of fkn time and tears trying to find out why nothing works anymore
  #- this needs to be here to get the command before, even though get_app_data calls it again afterwards;
  #--  but this is for the lua get_all_app_names call that preceeds the call again.
  init_commands

  validate_lua || return $?

  local app
  local apps=()
  local _cmd_get_all_app_names=("${CMD_GET_ALL_APP_NAMES[@]}")

    
  # -------------------------------------------------------------------------
  # Get all application names
  # -------------------------------------------------------------------------

  while IFS= read -r app; do

    [[ -z "${app//[[:space:]]/}" ]] && continue

    apps+=("${app}")

  done <<< "$("${_cmd_get_all_app_names[@]}")"

    
  # -------------------------------------------------------------------------
  # Nothing to display
  # -------------------------------------------------------------------------

  if (( ${#apps[@]} == 0 )); then
      
    \printf '\nThere are no apps to display.\n\n'
    return 0
    
  fi

  
  # -------------------------------------------------------------------------
  # Display applications
  # -------------------------------------------------------------------------

  for app in "${apps[@]}"; do

    display_app "${app}" || return $?

  done
  

}