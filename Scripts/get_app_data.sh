get_app_data(){


  local alias="${1}"
  shift

  # extra_args being the any other entries which are taken as flags of the target at runtime
  extra_args=("${@}")

  init_commands
  validate_lua || return $?

  local _cmd_get_app_name=("${CMD_GET_APP_NAME[@]}")
  local _cmd_get_app_background=("${CMD_GET_APP_BACKGROUND[@]}")
  local _cmd_get_app_target=("${CMD_GET_APP_TARGET[@]}")
  local _cmd_get_app_args=("${CMD_GET_APP_ARGS[@]}")
  local _cmd_get_app_wrapper=("${CMD_GET_APP_WRAPPER[@]}")
  local _cmd_get_app_wrapper_args=("${CMD_GET_APP_WRAPPER_ARGS[@]}")


  # ------------------------------------------------------------
  # Required: app name
  # ------------------------------------------------------------

  if [[ -z "${alias//[[:space:]]/}" ]]; then

    \printf "\n[ERROR] App name is empty!\n\n"
    return 13

  fi


  # NOTE: _status cannot be named status because it's actaully a zsh built-in readonly var, so never use status again.
  local output
  local _status

  output="$("${_cmd_get_app_name[@]}" 2>&1)"
  _status=$?

  #\printf "[DEBUG] _status=%s\n" "$_status" >&2
  #\printf "[DEBUG] output=%q\n" "$output" >&2

  if (( _status != 0 )); then

    \printf '%s\n\n' "$output" >&2
    return  "$_status"

  fi

  app_name="$(sanitize_string "$("${_cmd_get_app_name[@]}" 2>/dev/null)")"



  # ------------------------------------------------------------
  # Optional: args
  # ------------------------------------------------------------

  args=()

  while IFS= read -r arg; do

    arg="$(sanitize_string "${arg}")"

    [[ -n "${arg}" && "${arg}" != "nil" ]] &&
      args+=("${arg}")

  done <<< "$("${_cmd_get_app_args[@]}" 2>/dev/null)"



  # ------------------------------------------------------------
  # Optional: background
  # ------------------------------------------------------------

  background="$(sanitize_string "$("${_cmd_get_app_background[@]}")")"

  # false unless true is specified
  if [[ "${background}" != "true" ]]; then
    
    background="false"

  fi



  # ------------------------------------------------------------
  # Optional: wrapper_args
  # ------------------------------------------------------------

  wrapper_args=()

  while IFS= read -r wrapper_arg; do

    wrapper_arg="$(sanitize_string "${wrapper_arg}")"

    if [[ -n "${wrapper_arg}" && "${wrapper_arg}" != "nil" ]]; then

      wrapper_args+=("${wrapper_arg}")

    fi

  done <<< "$("${_cmd_get_app_wrapper_args[@]}" 2>/dev/null)"



  # ------------------------------------------------------------
  # Optional: wrapper
  # ------------------------------------------------------------

  wrapper="$(sanitize_string "$("${_cmd_get_app_wrapper[@]}" 2>/dev/null)")"

  # Lua nil means no wrapper
  if [[ "${wrapper}" == "nil" ]]; then

    wrapper=""
  
  fi


  if [[ -n "${wrapper}" ]]; then

    validate_is_executable "wrapper" "${wrapper}" || return $?
      
  fi



  # ------------------------------------------------------------
  # Required: target
  # ------------------------------------------------------------

  target="$(sanitize_string "$("${_cmd_get_app_target[@]}" 2>/dev/null)")"
  #Test with windows path, if it removes any spaces, could if mess up the paths in windows, make sure.. though not my focus

  validate_is_executable "target" "${target}" || return $?

}