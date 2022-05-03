UNAME="$(uname)"

if [[ $UNAME == MSYS* ]]; then
    # Use Windows-style TEMP/TMP
    export TEMP="$ORIGINAL_TEMP"
    export TMP="$ORIGINAL_TMP"
    # Delete lower-case temp/tmp because that triggers unrecovable error of Visual Studio
    unset temp tmp
fi