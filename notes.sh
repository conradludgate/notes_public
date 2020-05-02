#!/bin/bash

NOTES_DIR=${NOTES_DIR:-$HOME/.local/notes}
REMOTE_URL=${REMOTE_URL:-"https://github.com/conradludgate/notes_public/blob/master/"}

menu() {
    rofi -dmenu -p "$1"
}

menu_force() {
    rofi -dmenu -p "$1" -only-match -no-custom
}

show_notes() {
    pwd=$(pwd)
    cd "$NOTES_DIR" || exit 1
    find . -name "*.md" -printf "%T@ %p\n" |\
        sort -rn |\
        sed "s/^.\{24\}//" |\
        sed s/.md$// |\
        awk \!/README/ |\
        menu "$1"
    cd "$pwd" || exit 1
}

# Convert most strings I care about into snake case file names
# Eg "Foo Bar, Baz! " => "foo_bar_baz"
into_snake_case() {
    echo "$@" |\
        sed "s/[^a-zA-Z0-9_ ]//g" |\
        sed "s/^  *//" |\
        sed "s/  *$//" |\
        sed "s/  */_/g" |\
        tr '[:upper:]' '[:lower:]'
}

edit_file() {
    TERMINAL_EDITOR=${TERMINAL_EDITOR:-0}
    if [[ $TERMINAL_EDITOR != 0 ]]; then
        $TERMINAL -e "$SHELL -c \"$EDITOR $1\""
    else
        $EDITOR "$1"
    fi
}

# Open a new terminal to run the git commands
# Might help to diagnose some git issues
# Also allows for password entry etc
save() {
    $TERMINAL -e "$SHELL -c \" \
        cd $NOTES_DIR; \
        git add $1; \
        git commit -m 'Update $1'; \
        git push\""
}

main_menu() {
    # Show available notes files
    if ! note=$(show_notes notes); then
        exit 1
    fi

    sc=$(into_snake_case "$note")

    # Exit if no input
    if [[ -z $sc ]]; then
        exit 1
    fi

    file_name="$sc.md"

    file="$NOTES_DIR/$file_name"

    # Create a new file and edit it if it's not present
    # Else, as for action
    if [[ ! -f $file ]]; then
        echo -e "# $note" > "$file"
        edit_file "$file"
        save "$file_name"
    else
        action=$(echo -e "edit\nopen\ndelete" | menu_force "$note")
        case $action in
            "edit") edit_file "$file"; save "$file_name" ;;
            "open") xdg-open "$REMOTE_URL$file_name" ;;
            "delete")
                confirm=$(echo -e "yes\nno" | menu_force "confirm")
                case $confirm in
                    "yes") rm "$file"; save "$file_name";;
                esac
        esac
    fi
}

main_menu
