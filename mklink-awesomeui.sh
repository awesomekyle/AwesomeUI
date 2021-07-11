#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
FILES=(auraTracker.lua AwesomeUI.xml main.lua auras.lua)
VERSIONS=(_classic_ _classic_era_ _classic_ptr_ _retail_ _ptr_)

HARD_LINK=false
RESET=false

for var in "$@"
do
    if [[ "$var" = '--hard' ]]; then
        echo "Creating hard links"
        HARD_LINK=true
    elif [[ $var = '--reset' ]]; then
        echo "Deleting existing links first"
        RESET=true
    fi
done

echo $SCRIPT_DIR
for version in ${VERSIONS[*]}; do
    VERSION_PATH="$SCRIPT_DIR/../$version"
    ADDON_PATH="$VERSION_PATH/Interface/AddOns/AwesomeUI"
    if [[ -d "$VERSION_PATH" ]]; then
        if [[ "$RESET" = true ]]; then
            rm -r "$ADDON_PATH"
        fi
        if [[ ! -d "$ADDON_PATH" ]]; then
            echo "Creating $ADDON_PATH..."
            mkdir -p "$ADDON_PATH"
        else
            echo "$ADDON_PATH already exists"
        fi
        if [[ "$HARD_LINK" = true ]]; then
            ln "$SCRIPT_DIR/AwesomeUI.$version.toc" "$ADDON_PATH/AwesomeUI.toc"
        else
            ln -s "$SCRIPT_DIR/AwesomeUI.$version.toc" "$ADDON_PATH/AwesomeUI.toc"
        fi
        for file in ${FILES[*]}; do
            if [[ "$HARD_LINK" = true ]]; then
                ln "$SCRIPT_DIR/$file" "$ADDON_PATH/$file"
            else
                ln -s "$SCRIPT_DIR/$file" "$ADDON_PATH/$file"
            fi
        done
    fi
done