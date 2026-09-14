build_command(){


  get_app_data "${@}" || return $?

  cmd_run_app=()

  # wrapper - optional
  if [[ -n "${wrapper}" && "${wrapper}" != "nil" ]]; then

    cmd_run_app+=("${wrapper}")

    # wrapper_args - optional: can only be set if wrapper is good
    ((${#wrapper_args[@]})) && cmd_run_app+=("${wrapper_args[@]}")

  fi

  # target - this is absolutely necessary to run - return should be caught before so no need to check if empty etc.
  cmd_run_app+=("${target}")


  # args - optional: these are the pre-configured args for the target
  #- use an if to bypass the return 1, shorthand produces return 1 if empty, meaning if extra args is empty, constant return 1
  if (( ${#args[@]} > 0 )); then

    cmd_run_app+=("${args[@]}")

  fi

  # extra_args - optional: these are set by the user at runtime and will append args at the end
  if (( ${#extra_args[@]} > 0 )); then

    cmd_run_app+=("${extra_args[@]}")

  fi

}