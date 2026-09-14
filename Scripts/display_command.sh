display_command(){


  build_command "${@}"

  local i=0
  for _cmd_arg in "${_cmd_run_app[@]}"; do
  
    \printf "\n[Arg%s] %s\n" "$i" "${_cmd_arg}"
    ((i++))
  
  done

  \printf "\n[Full Arg] %s\n\n" "${_cmd_run_app[*]}"


}
