#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
FILES=(auraTracker.lua AwesomeUI.xml main.lua auras.lua)
# VERSIONS=(_retail_)
VERSIONS=(_classic_ _classic_era_ _classic_ptr_ _classic_era_ptr_ _retail_ _ptr_)

RESET=false

for var in "$@"
do
    if [[ $var = '--reset' ]]; then
        echo "Deleting existing links first"
        RESET=true
    fi
done

echo $SCRIPT_DIR
for version in ${VERSIONS[*]}; do
    VERSION_PATH="$SCRIPT_DIR/../$version"
    ADDON_FOLDER="$VERSION_PATH/Interface/AddOns"
    ADDON_PATH="$VERSION_PATH/Interface/AddOns/AwesomeUI"
    if [[ -d "$VERSION_PATH" ]]; then
        if [[ "$RESET" = true ]]; then
            rm -r "$ADDON_PATH"
        fi
        if [[ ! -d "$ADDON_FOLDER" ]]; then
            echo "Creating $ADDON_FOLDER..."
            mkdir -p "$ADDON_FOLDER"
        fi
        if [[ ! -d "$ADDON_PATH" ]]; then
            echo "Linking: $SCRIPT_DIR $ADDON_PATH"
            ln -s "$SCRIPT_DIR" "$ADDON_PATH"
        else
            echo "$ADDON_PATH already exists"
        fi
        # if [[ ! -d "$ADDON_PATH" ]]; then
        #     echo "Creating $ADDON_PATH..."
        #     mkdir -p "$ADDON_PATH"
        # else
        #     echo "$ADDON_PATH already exists"
        # fi
        # ln -s "$SCRIPT_DIR/AwesomeUI.$version.toc" "$ADDON_PATH/AwesomeUI.toc"
        # for file in ${FILES[*]}; do
        #     ln -s "$SCRIPT_DIR/$file" "$ADDON_PATH/$file"
        # done
    fi
done