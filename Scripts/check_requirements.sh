
check_requirements(){



  if ! command -v lua &>/dev/null; then

    \printf "\n[ERROR] This Program cannot run due to a dependency issue!\n"
    \printf "\n[INFO] Just like the Mona Lisa required a canvas, paint and a paintbrush, this work of art requires Lua!\n\n"
    return 2

  fi


  if ! check_file_exists "${FILE_LUA_QUERY}"; then

   
    return 10


  fi


  if ! check_file_exists "${FILE_LUA_CONFIG}"; then


    \printf "[INFO] You can generate a default config file using flx --generate-default-config and flx -e to edit it.\n\n" 
    
    return 11


  fi

  return 0


}