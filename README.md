<center>
FLX

A lightweight App Launcher and Local Bin, configured and managed in Lua for launching AppImages, Scripts, Commands through User-Defined Aliases for zShell and Bash.
</center>

---

## Description

FLX can be used as a local bin as a sandbox for testing scripts - making quick modifications without having to commit to symlinks in the $PATH directories, or aliases in .rc files, editing, sourcing, re-editing, re-sourcing and so on.  It's also a functional Application launcher.  Initially, FLX was concieved to launch AppImages and to be used as a testing ground before committing symlinks to my $PATH folders for stuff I was testing.  The first iterations were Bash-only, however, I decided to make it more User-Friendly and available for other Users, that I decided to go with Lua as I had to learn it anyways due to my Hyprland breaking caused by their Lua-only direction.  I did make multiple attempts to do Bash-only, but trying to make a parser and good config format was a nightmare; after seeing a video on YouTube of a guy writing a JSON parser in Bash.... I said nah, I'll use something else.  At this point, Lua was the only option due to my hardline anti-YAML stance with me being the Head of the Anti-YAML Movement's Military, Intelligence and Special Forces Branch.

---

## Install

cd to the directory where you want to install the repo:

```
git clone https://github.com/FMallon/FLX;
[[ ! -x ./FLX/Main/flx.sh ]] && chmod -x ./FLX/Main/flx.sh;
sudo ln -sf ./FLX/Main/flx.sh /usr/local/bin/flx;
flx --generate-default-config;
```
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

### target:
Must be a valid executable path, or a command.  FLX validates these properties at runtime and exits if not variable.  It is the default variable and must always be set by the User.

### args: 
These will be the arguments of the target executable to be launched at runtime.  This is optional, and can be left empty in cases where a User wishes to launch something with different args at different points in time - this will be expanded upon below.

### background:
By default, this will always be false, unless true is specified by the User.  This defines whether or not the App is to be ran as a seperate background process, or a foreground process whose lifespan will depend on the TTY that launched it.

### wrapper:
One of FLX's purposes is to be used as a local bin; in the event of testing a script, one may wish to use "bash -x" or "source" to launch their script/program.  This entry gives the user a quick entry-point to achieve this without rewriting the target/args variables to achieve this.  Like target, this will go through validation to make sure it's an executable path/command

Note: this is for this specific use-case, but be aware, if using source, a script won't need to be executable, however, if using FLX to source a script, it is advised to always use source as the target, as target validation requires executable functionality.  #(explain this a little better) 

### wrapper_args:
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

---

TODO:

    More Lua Stuff, examples on creating vars etc.

    Write a Description that isn't nonsense, needs to be clear and concise.

    Clean up the descriptions of everything the Lua Config so people can understand, needs to be in plainer English and not the way I think.

    Forgot the editor shite also.

    Details about the background and reason - setsid, nohup, subshell etc.

    Return Codes

    Also a little thing at the top that helps direct user's, just copy/paste from an other project somewhere - maybe PodBOI has one

    Test the Install and the guide on a clean system.

