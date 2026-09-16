<div align="center">
    
<h1>FLX</h1>

A lightweight App Launcher and Local Bin, configured and managed in Lua for launching AppImages, Scripts, Commands through User-Defined Aliases for Bash and Zsh.
</div>


---

## Table of Contents

- [Description](#description)
- [Installation](#install)
- [Requirements](#requirements)
- [Quick Guide](#quick-guide)
- [Lua Config](#lua-config)
  - [Config Variables](#config-variables)
  - [Editor](#editor)
  - [Additional Lua Config Possibilities](#additional-lua-config-possibilities)
- [Running Apps in the Background](#running-apps-in-the-background)
- [Known Issues](#known-issues)
- [Return Codes](#return-codes)

## Description

FLX is a lightweight application launcher and local bin that uses a Lua configuration file to define user-created aliases for launching applications, scripts and commands.

FLX can also be used as a convenient testing environment for scripts and applications. Instead of repeatedly creating symlinks in directories contained in `$PATH`, creating shell aliases, or modifying and re-sourcing shell configuration files, applications can be added to the FLX configuration and launched immediately using their assigned alias.

The project was originally created as a simple way to test and launch AppImages before committing them to a permanent location. It has since evolved into a more general-purpose launcher and local bin.

The configuration is written in Lua, allowing users to define applications and their arguments using a simple and flexible configuration format.

---

## Install

cd to the directory where you want to install the repo:

```
git clone https://github.com/FMallon/FLX;
[[ ! -x ./FLX/Main/flx.sh ]] && chmod +x ./FLX/Main/flx.sh;
sudo ln -sf "$(pwd)/FLX/Main/flx.sh" /usr/local/bin/flx;
flx --generate-default-config;
```
---

## Requirements

FLX requires:

- Bash or Zsh
- Lua

---

## Quick Guide

Now that FLX is installed, and the Default Config has been generated, you will have two entries set in your Config:

1) Runs flx -d flx via bash -x.  This was how I used FLX to test itself during testing....
2) Runs echo hello.

So to verify our entry exists, we can display it's info to the terminal using 
```
flx -d flx
```
This should give the expected output of the Lua Config entry in a nice table format.

Now to run this, we enter:

```
flx -- flx
```

And bash -x's output should show everything going on under the hood to the terminal.


If we run:

```
flx -da
```

We should see a list of all the Application entries in our Config outputted to the terminal.

"hello" should be one of these.  This will simply print "hello" to the terminal.

```
flx -- hello
```

Since it just uses "echo hello", we can enter extra args to this.  Anything after the Alias to the Application Name will be appended to as args.

```
flx -- hello world
```
or

```
flx -- hello $(whoami) 
```
These will be counted as args towards the echo command, not towards FLX.

So the usage is: flx -- \<alias\> \<args\>

This allows dynamic runtime-usage of scripts/programs during testing where a User needs to dynamically pass args at run-time.

A User can run Python scripts, or Commands, or quickly append an Shell interperetor by adding "zsh" as a "wrapper" entry during testing.

Any return codes after the point of FLX passing validation and Alias handling are handled by your script or application - a warning will tell you of this in the CLI.

---

## Lua Config

```lua


apps = {

    app_name = {

        -- required
        target = "/path/to/script",

        -- optional
        args = {
            "arg1",
            "arg2",
        },

        background = true,

        wrapper = "bash",

        wrapper_args = {

            "-x",
        },

    }

}

```
---

### Config Variables

#### `target`

Must be a valid executable path or command. FLX validates the target at runtime and exits if it is not valid.

This is the default and required variable, and must always be set by the User.

#### `args`

Defines the arguments passed to the `target` executable at runtime.

This is optional and can be left empty when the User wishes to provide different arguments at different points in time. Runtime arguments can be passed directly when launching an application through FLX; this is expanded upon below.

#### `background`

By default, `background` is set to `false` unless explicitly set to `true` by the User.

This defines whether the application is launched as a separate background process or as a foreground process whose lifetime is tied to the process that launched it.

#### `wrapper`

One of FLX's purposes is to function as a local bin. When testing or debugging a script, for example, a User may wish to launch it using a wrapper such as `bash -x` or `source`.

The `wrapper` entry provides a convenient way to do this without having to modify the `target` and `args` variables.

Like `target`, the wrapper is validated to ensure that it is a valid executable path or command.

**Note:** `source` is a special case. A script being sourced does not need to have its executable permission set because it is being interpreted by the current shell rather than executed directly. However, because FLX validates `target` and `wrapper` as executable paths or commands, `source` should be used as the `target` when sourcing a script, rather than relying on the script itself being executable.

----

For example:

```lua
target = "source"
args = {
    "/path/to/script.sh",
}
```

Should a User wish to add a bash -x check quickly:

```lua
target = "path/to/script.sh",

args = {"--help"},

wrapper = "bash",

wrapper_args = {"-x"}
```
Then the flow will be:

```
bash -x path/to/script.sh --help
```
Now the script's usage function should run via bash -x.

---

### Editor

Another possible entry in the Lua config is editor = {}.

This allows the User to configure a desired text-editor of choice for the --edit flag.

**Note:** if the config file is invalid, the editor name is unexecutable/invalid, or the editor = {} block is unset, the editor will default to 
```bash
local editors=(
    "nano"
    "nvim"
    "neovim"
    "emacs"
    "vim"
    "vi"
  )
```

in the edit_config() function within the Program. 

The editor = {} block takes two args, the editor name, and the editor's args that the User wishes to pass:

```lua

editor = {

    name = "nvim",
    args = {
        "+80"
    }

}

```

This ensures that when I run 'flx -e' to edit the Config, it will open it at the 80th line with Nvim.

A User may also use Lua functionality to get the lines of the Config file, and use that to open the Config at its last line - more about extra Lua functionality will be expanded upon below.

---

### Additional Lua Config Possibilities

Because Lua is a programming language in-and-of-itself, and not just a text-based format for parsing, it is possible for a User to create their own variables for use within the Config.

```lua

vars = {

    -- this is the home directory of a User
    home = os.getenv("HOME") .. "/",
    
}

```

Using os.getenv("HOME"), we can get the environment variable for our home directory.  The '..' appends '/' to the string so our full path is now "/home/user/".  You don't have to do that here exactly, and can account for that elsewhere.

In Apps we can use this to avoid writing out full directory paths all the time: 

```lua

apps = {


    flx = {

        target = vars.home .. "MyProjects/FLX/Main/flx.sh",
        
        args = {
            "-d",
            "flx"
        },

        background = false,

        wrapper = "bash",
        wrapper_args = {
            "-x",
        },

    },

}


```

**Note:** Variables used from another Lua Table must be set above.  If vars = {} is defined under apps = {}, app = {} will not be able to see this variable.

---

## Running Apps in the Background

FLX runs applications in the foreground by default.

When `background = true` is specified, FLX attempts to detach the application from the terminal that launched it.

FLX attempts the following methods in order:

1. `setsid`
2. `nohup`
3. A subshell fallback

The purpose of this is to prevent the launched application from remaining unnecessarily attached to the terminal or pseudo-terminal from which FLX was invoked. This allows the application to continue running after the launching terminal is closed, where supported by the application and operating system.

---
## Known Issues

### Hang During Validation (`-vc`)

If a function in the Lua Config enters a state where it does not return — for example, due to an invalid value being passed to a File I/O function — the validation process can hang while Lua attempts to execute the function.

I am currently investigating a way to safely terminate validation after a defined timeout. Possible approaches include `timeout`/`gtimeout` or using Perl's `alarm` functionality. The main challenge is handling the timeout while still maintaining control over the command's output and exit status.

I am intentionally trying to avoid unnecessarily complicated solutions such as monitoring CPU usage or attempting to determine whether Lua is actively processing.

**Workaround:** Press `Ctrl+C` twice to terminate the validation process, then edit the Config to fix or remove the function causing the hang.

---

### Lua Debugging Output

The Lua Query script prevents `print()` from being used within the Lua Config because output written to `stdout` can interfere with the data FLX expects to receive from the Lua Query script.

However, Lua provides other debugging functionality that can also write to `stdout` and potentially interfere with this data.

For example, my FLX config uses `debug.getinfo()` internally to obtain information about the Config file, including functionality used to determine the number of lines in the Config. This is useful for features such as opening the Config at a specific line, so disabling the entire `debug` library is not desirable.

**Workaround:** Do not write debugging or other informational output to `stdout` from within the Lua Config. Any output intended for debugging should be avoided while the Config is being processed by FLX.

---

## Return Codes

| Code | Description |
|---:|---|
| `1` | Error: Unsupported environment |
| `2` | Error: Unmet dependency |
| `3` | Error: Invalid argument |
| `4` | Error: Invalid number of arguments |
| `5` | Config file does not exist |
| `6` | Invalid config file format |
| `7` | Application name not found |
| `8` | Invalid query |
| `9` | Error: Sourcing required external scripts |
| `10` | Error: Finding Lua Query script |
| `11` | Error: Lua Config does not exist |
| `12` | Error: Failure to pass `validate_lua()` check — there is an error in the config file |
| `13` | Error: Empty app name passed to `get_app_data()` |
| `14` | Error: The argument passed to `validate_is_executable()` is empty |
| `15` | Error: The target/wrapper, if a file, is not executable |
| `16` | Error: The target/wrapper is not a valid executable path/command |
| `17` | Error: User-defined editor is invalid, resorting to defaults |
| `18` | Error: No supported editor found on user's system |
| `19` | Error: Failed running the editor to edit the Config File |
| `20` | Error: Failure to create Config Directory |
| `21` | Error: Failure to Generate Default Config |

---


