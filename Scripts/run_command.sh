run_command(){


  build_command "${@}" || return $?

  #-debug echo "${_cmd_run_app[*]}"
  #if run in background an error wont return obviously

  #ok, so:
  #- command -v || test -f the launcher field && continue or return error
  #- if file, test exectuable or return error.
  #- it will be a binary, so if sudo is needed; a user should be able to run sudo flx and it will work, or add that as the launcher - test this


  # For background:
  #- now keeping in line with my Noctalia issue yesterday, it may be best to run in a subshell to account for pttys;
  #-- that being said, not ideal, so:
  #--- command -v setsid, then nohup, then revert to subshell & execution and warn user of this.
  
  #- this seems like the best way to solve this issue, though I haven't even come to it yet and dunno if it's the best way... just an idea

  

\printf "\n"
\printf "┌─ FLX ────────────────────────────────────────────────────────┐\n"
\printf "│ ✓ Launch completed successfully.                             │\n"
\printf "│   Application output and errors are handled by the target.   │\n"
\printf "└──────────────────────────────────────────────────────────────┘\n"
\printf "\n"



  case "$background" in
    
    true)

      if command -v setsid &>/dev/null; then

        setsid "${cmd_run_app[@]}" \
          </dev/null \
          >/dev/null \
          2>&1 &

          return $?

      elif command -v nohup &>/dev/null; then

        nohup "${cmd_run_app[@]}" \
        </dev/null \
        >/dev/null \
        2>&1 &

        return $?

      else

        \printf "\n[INFO] No setsid or nohup available, resorting to subshell background execution!\n\n"

        (
          "${cmd_run_app[@]}" \
          </dev/null \
          >/dev/null \
          2>&1 &
        )

          return $?

      fi

    ;;

    *)
    
      "${cmd_run_app[@]}"
      return $?
    
    ;;

esac

}