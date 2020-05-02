# notes

A script that helps me make notes easier.

## How does it work

Run the script (I've included a .desktop entry that I use rofi+drun to open)
it then opens rofi, shows you all the files in your notes directory.

If you select a file, you can
* edit it in an `$EDITOR` of your choice
* open the file for rich markdown viewing, such as opening the file on github in browser
* delete the file

Otherwise, if your input is unique, it will create a new file with your input as the markdown title
and open it directly for editing

## Dependencies

* git
* rofi
* xdg-utils
* standard shell scripts like sed, awk, find, tr

## Installation

```sh
mkdir .local/notes # or any directory, custom locations require setting the $NOTES_DIR variable
cd .local/notes

git init                   # Initialise your git repository
git remote add origin ...  # And add a remote
```

You may also want to make an initial commit and push that.
The notes script wont do `--set-upstream` when pushing 

Next, set up a hotkey or a desktop entry to run the `notes.sh` script.
There are a few variables that you can set.

* `REMOTE_URl` is the location to open the file for viewing. ie `https://github.com/user/repo/blob/master/`
* `NOTES_DIR` The location to find and save the notes to
* `EDITOR` The editor to edit the file with. If you're using a terminal editor like vim, use this next variable
* `TERMINAL_EDITOR` If this is not 0, it will open your editor in a terminal first
* `TERMINAL` Terminal to use for the editor or for saving files with git
* `SHELL` Shell to launch terminal into

