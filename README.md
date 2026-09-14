<div align="center">
FLX

A lightweight App Launcher and Local Bin, configured and managed in Lua for launching AppImages, Scripts, Commands through User-Defined Aliases for Bash and Zsh.
</div>

---
## Note

This is in the testing stages.  It's functional, but still... it's public so I can test it on other systems.

---

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
sudo ln -sf ./FLX/Main/flx.sh /usr/local/bin/flx;
flx --generate-default-config;
```

### Note:

FLX is configured with Zsh compatibility, however, due to the fact that there is no Shebang, usually it will run in Bash 3.2 on MacOS - and I am sure Shell on other systems where Bash doesn't exist.  This is due to Zsh apparently being hardcoded to run files without a Shebang with Shell as the default entrypoint.  Therefore, in order to make it fully Zsh native, you will either have to manually add the Shebang "#!/usr/bin/env zsh" at the top of the ./Main/flx.sh file; or create an alias in your ~/.zshrc file: alias flx='zsh /usr/local/bin/flx'.

---

## Quick Guide

Now that FLX is installed, and the Default Config has been generated, you will have two entries set in your Config:

1) Runs flx -d flx via bash -x.  This was how I used FLX to test itself during testing....
2) Runs echo hello.

----
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
----

If we run:

```
flx -da
```

We should see a list of all the Application entries in out Config outputted to the terminal.

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

Therefore any return codes after this point are handled by your script or application - a warning will tell you of this in the CLI.



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

### Config Variables

#### target:
Must be a valid executable path, or a command.  FLX validates these properties at runtime and exits if not variable.  It is the default variable and must always be set by the User.

#### args: 
These will be the arguments of the target executable to be launched at runtime.  This is optional, and can be left empty in cases where a User wishes to launch something with different args at different points in time - this will be expanded upon below.

#### background:
By default, this will always be false, unless true is specified by the User.  This defines whether or not the App is to be ran as a seperate background process, or a foreground process whose lifespan will depend on the TTY that launched it.

#### wrapper:
One of FLX's purposes is to be used as a local bin; in the event of testing a script, one may wish to use "bash -x" or "source" to launch their script/program.  This entry gives the user a quick entry-point to achieve this without rewriting the target/args variables to achieve this.  Like target, this will go through validation to make sure it's an executable path/command

Note: this is for this specific use-case, but be aware, if using source, a script won't need to be executable, however, if using FLX to source a script, it is advised to always use source as the target, as target validation requires executable functionality.  #(explain this a little better) 

#### wrapper_args:
This will be the args of the wrapper entry, so if using "bash -x" to do some basic shell checks, 

```

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

----

### Additional Lua Config Possibilities


----

Another hidden entry in the Lua config is editor = {}.

This allows the User to configure a desired text-editor of choice for the --edit flag.

Note: if the config file is invalid, the editor name is unexecutable/invlalid, or the editor = {} block is unset, the editor will default to 

local editors=(
    "nano"
    "nvim"
    "neovim"
    "emacs"
    "vim"
    "vi"
  )

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

----


Because Lua is a programming language in-and-of-itself, and not just a text-based format for parsing, it is possible for a User to create their own variables for use within the Config.

```lua

vars = {

    -- this is the home directory of a User
    home = os.getenv("HOME") .. "/",
    
}

```

Using os.getenv("HOME"), we can get the environment variable for our home directory.  The '..' appends to the string a '/' so our full path is now "/home/user/".  You don't have to do that here exactly, and can account for that elsewhere.

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

---

## Running Apps in the Background

By the default, FLX entries will be run in the foreground unless explicitly called in their options: background = "true".

In the event where a User wishes to launch a FLX entry in the background, I configured the program to go by 2 methods, plus the default.

First, setsid will be attempted; if this fails, nohup will then be attempted; if this fails, then it will default to a subshell.

The reason for this default being set the way it is: it's the best way I know to detach from a Pseudo-Terminal.  I don't know if it's the best way to do it, but if I don't do it this way, an App will always be attached to the PTS that the FLX entry was launched from - therefore, if a User is to close the PTS, the App will also shutdown... which is not ideal.  But usually a linux system will have setsid, and Unix systems will have nohup.   

---

## Return Codes

Return 1  - Error: Unsupported environment                                                                            
Return 2  - Error: Unmet dependency
Return 3  - Error: Invalid arg
Return 4  - Error: Invalid no. of args                                 
Return 5  - Config file does not exist
Return 6  - Invalid config file format
Return 7  - Application name not found
Return 8  - Invalid query
Return 9  - Error: Sourcing required external Scripts
Return 10 - Error: Finding Lua_Query script
Return 11 - Error: Lua Config doesn't exist
Return 12 - Error: Failure to pass validate_lua() check - there is an error in the config file
Return 13 - Error: Empty app name passed to get_app_data()
Return 14 - Error: The arg passed to validate_is_executable() is empty
Return 15 - Error: The target/wrapper, if a file, is not executable
Return 16 - Error: The target/wrapper is not a valid executable path/command
Return 17 - Error: User-defined editor is invalid, resorting to defaults
Return 18 - Error: No supported editor found on User's System
Return 19 - Error: Failed running the editor to edit the Config File
Return 20 - Error: Failure to create Config Directory
Return 21 - Error: Failure to Generate Default Config

---

## TODO: 

Clean up Readme, re-formulate etc. and better explanations.
Test the install
Test the guide
Make a nice Return block
Explain Issues, or figure a way to fix them - maybe the latter is better option?

