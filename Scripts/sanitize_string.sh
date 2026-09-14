sanitize_string() {

    # So this will do what was previously happening, outputting the Lua value, but it should sanitize before hand
    # The main issue was newlines being generated;
    #- any vars passed through here will have all those spaces removed.

    local value="${1}"

    # remove any tabs, newlines etc.
    value="${value//$'\r'/}"
    value="${value//$'\n'/}"
    value="${value//$'\t'/}"

    # trim any whitespace
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"

    \printf "%s" "${value}"

    
}