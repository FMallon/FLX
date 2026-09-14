get_editor_data(){


  init_commands

  local _cmd_get_editor_name=("${CMD_GET_EDITOR_NAME[@]}")
  local _cmd_get_editor_args=("${CMD_GET_EDITOR_ARGS[@]}")


  # ------------------------------------------------------------
  # Optional: Editor Name
  # ------------------------------------------------------------

  editor_name="$(sanitize_string "$("${_cmd_get_editor_name[@]}" 2>/dev/null)")"


  # ------------------------------------------------------------
  # Optional: Editor Launch Options
  # ------------------------------------------------------------

  editor_args=()

  while IFS= read -r editor_arg; do

    editor_arg="$(sanitize_string "${editor_arg}")"

    [[ -n "${editor_arg}" && "${editor_arg}" != "nil" ]] &&
      editor_args+=("$(sanitize_string "${editor_arg}")")

  done <<< "$("${_cmd_get_editor_args[@]}" 2>/dev/null)"


  return 0



}


edit_config_user() {
    
  get_editor_data


  if ! validate_lua >/dev/null 2>&1; then
    
    \printf "\n[INFO] Resorting to defaults - there is an error in the Lua Config!\n\n"
    sleep 2
    return 17
    
  fi


  if ! command -v "${editor_name}" >/dev/null 2>&1; then
    
    \printf "\n[INFO] Resorting to defaults - the Lua Config entries, if set, for 'editor = {}' were invalid!\n\n"
    return 17
    
  fi

  local _editor_command=("${editor_name}")

  for _arg in "${editor_args[@]}"; do
  
    _editor_command+=("${_arg}")
  
  done

  _editor_command+=("${FILE_LUA_CONFIG}")

  "${_editor_command[@]}"

}


edit_config_default() {
  
  check_file_exists "${FILE_LUA_CONFIG}" || {
    
    \printf "[ERROR] %s doesn't exist!\n\n" "$FILE_LUA_CONFIG"
    return 11
    
  }

  
  local editor_to_use=""
  
  local editors=(
    "nano"
    "nvim"
    "neovim"
    "emacs"
    "vim"
    "vi"
  )

  for editor in "${editors[@]}"; do
    
    if command -v "$editor" &>/dev/null; then
      
      editor_to_use="$editor"
      break
    
    fi
    
  done

  if [[ -z "$editor_to_use" ]]; then
        
    \printf "[ERROR] No supported editor found: %s!\n" "${editors[*]}"
    return 18
  
  fi

  local cmd_launch_editor=(
    "$editor_to_use"
    "$FILE_LUA_CONFIG"
  )

  if ! "${cmd_launch_editor[@]}"; then
    
    \printf "\n[ERROR] Failed running editor: %s\n" "${cmd_launch_editor[*]}"
    return 19

  fi

    return 0

}



edit_config() {

  check_requirements || return $?
  
  if ! check_file_exists "${FILE_LUA_CONFIG}"; then
  
    \printf "[INFO] You can generate a default config using --generate-default-config\n\n"
    return 5

  fi

  if ! edit_config_user; then

    edit_config_default || return $?

  fi


  if ! validate_lua_check &>/dev/null; then

    \printf "\n[WARNING] There is an error in the Lua Config:\n\n"
    validate_lua_check
    \printf "\n"

  fi

  return 0

}