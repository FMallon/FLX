check_file_exists(){


  local file="${1}"

  if [[ -z "${file//[[:space:]]/}" ]]; then

    \printf "\n[ERROR] The filename is empty!\n\n"
    return 2

  fi


  if [[ ! -f "${file}" ]]; then

    \printf "\n[ERROR] The file %s does not exist!\n\n" "${file}"
    return 1

  fi

  return 0


}