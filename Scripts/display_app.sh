display_app(){
  
  get_app_data "${@}" || return $?

  if [[ "${IS_ZSH}" == "true" ]]; then
  
    print_app_info_zsh || return $?

  else 

    print_app_info || return $?

  fi


}
