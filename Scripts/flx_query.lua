-- Exit codes
-- Exit 5 - Config file does not exist
-- Exit 6 - Invalid config file format
-- Exit 7 - Application name not found
-- Exit 8 - Invalid query

ERR_CONFIG_NOT_FOUND = 5
ERR_CONFIG_INVALID_FORMAT = 6
ERR_APP_NOT_FOUND = 7
ERR_INVALID_QUERY = 8


-- ============================================================
-- CONFIG VALIDATION
-- ============================================================

function validate_config_format(config_env)

    if type(config_env.apps) ~= "table" then

        io.stderr:write(
            "\n[INFO] Invalid config: 'apps' table not found!\n"
        )

        os.exit(ERR_CONFIG_INVALID_FORMAT)

    end

end


function verify_config()

    local file = io.open(config, "r")

    if not file then

        io.stderr:write(
            "\n[INFO] Config file does not exist or cannot be read\n"
        )

        os.exit(ERR_CONFIG_NOT_FOUND)

    end

    file:close()

end


function load_config()

    local env = setmetatable({

        print = function()

            error("\n[INFO] print() is not allowed in the Lua config!", 2)

        end

    }, {

        __index = _G

    })


    local chunk, err = loadfile(config, "t", env)

    if not chunk then

        io.stderr:write(
            "\n[INFO] " .. err .. "\n"
        )

        os.exit(ERR_CONFIG_INVALID_FORMAT)

    end

    local ok, exec_err = pcall(chunk)

    if not ok then

        io.stderr:write(
           "\n[INFO] " .. exec_err .. "\n"
        )

        os.exit(ERR_CONFIG_INVALID_FORMAT)

    end


    return env

end


function validate_lua()

    local config_env = load_config()

    validate_config_format(config_env)

end

-- ============================================================
-- APPLICATION FUNCTIONS
-- ============================================================

function get_app(alias)

    if alias == nil or alias == "" then

        io.stderr:write(
            "\n[ERROR] Application name was not provided\n"
        )

        os.exit(ERR_APP_NOT_FOUND)

    end

    if apps[alias] == nil then

        io.stderr:write(
            "\n[ERROR] Application not found: " .. tostring(alias) .. "\n"
        )

        os.exit(ERR_APP_NOT_FOUND)

    end

    return apps[alias]

end


function get_app_name(alias)

    -- This also validates that the application exists.
    get_app(alias)

    print(alias)

end


function get_app_target(alias)

    local app = get_app(alias)

    print(tostring(app.target))

end


function get_app_args(alias)

    local app = get_app(alias)

    for _, arg in ipairs(app.args or {}) do

        print(arg)

    end

end


function get_app_background(alias)

    local app = get_app(alias)

    print(tostring(app.background))

end


function get_app_wrapper(alias)


    local app = get_app(alias)

    print(tostring(app.wrapper))

    
end


function get_app_wrapper_args(alias)

    local app = get_app(alias)

    for _, arg in ipairs(app.wrapper_args or {}) do

        print(arg)

    end

end


function get_all_app_names()

    for app_name, _ in pairs(apps) do

        print(app_name)

    end

end


-- ============================================================
-- EDITOR FUNCTIONS
-- ============================================================

function get_editor_name()

    print(editor.name)

end


function get_editor_args()

    for _, editor_arg in ipairs(editor.args or {}) do

        print(editor_arg)

    end

end


-- ============================================================
-- MAIN
-- ============================================================

function main()

    query = arg[1]
    config = arg[2]

    if config == nil then

        io.stderr:write(
            "\n[ERROR] Config path was not provided!\n"
        )

        os.exit(ERR_CONFIG_NOT_FOUND)

    end

    verify_config()

    if query == "validate_lua" then

        validate_lua()
        return

    end

    local config_env = load_config()

    validate_config_format(config_env)

    apps = config_env.apps
    editor = config_env.editor

    -- Query dispatcher
    
    -- arg 3 is the alias of the app name

    if query == "get_app_name" then

        alias = arg[3]
        get_app_name(alias)


    elseif query == "get_app_background" then

        alias = arg[3]
        get_app_background(alias)


    elseif query == "get_app_target" then

        alias = arg[3]
        get_app_target(alias)


    elseif query == "get_app_args" then

        alias = arg[3]
        get_app_args(alias)


    elseif query == "get_app_wrapper" then

        alias = arg[3]
        get_app_wrapper(alias)


    elseif query == "get_app_wrapper_args" then

        alias = arg[3]
        get_app_wrapper_args(alias)
        

    elseif query == "get_all_app_names" then

        get_all_app_names()


    elseif query == "get_editor_name" then

        get_editor_name()


    elseif query == "get_editor_args" then

        get_editor_args()

    else

        io.stderr:write(
            "Unknown query: " .. tostring(query) .. "\n"
        )

        os.exit(ERR_INVALID_QUERY)

    end

end


main()