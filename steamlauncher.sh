#!/bin/bash
# RecRoom Revival Launcher for Linux

cd "$(dirname "$0")" || exit 1
GAME_DIR="$(pwd)"

PLUGINS_DIR="$GAME_DIR/BepInEx/plugins"
CACHE_FILE="$GAME_DIR/BepInEx/cache/chainloader_typeloader.dat"

REVIVAL_NAME="Unknown"
REVIVAL_EXE="RecRoom.exe"
REVIVAL_COLOR="\e[97m"
CHECK_RUNNING=0

# Detect installed revival/patch
if [ -f "$PLUGINS_DIR/WoofPatch.dll" ] || [ -f "$PLUGINS_DIR/MeowPatch.dll" ] || [ -f "$PLUGINS_DIR/MeowNet.dll" ]; then
    REVIVAL_NAME="Meow.net"
    REVIVAL_COLOR="\e[96m"
    REVIVAL_EXE="RecRoom.exe"
elif [ -f "$PLUGINS_DIR/Radeon.Core.BasePatch.dll" ] || [ -f "$PLUGINS_DIR/RadiumPatch.dll" ] || [ -f "$PLUGINS_DIR/Radium.dll" ]; then
    REVIVAL_NAME="Radium"
    REVIVAL_COLOR="\e[93m"
    REVIVAL_EXE="Radium.exe"
    CHECK_RUNNING=1
elif [ -f "$PLUGINS_DIR/VanillaPatch.dll" ] || [ -f "$PLUGINS_DIR/VanillaClient.dll" ]; then
    REVIVAL_NAME="Vanilla"
    REVIVAL_COLOR="\e[92m"
    REVIVAL_EXE="RecRoom.exe"
elif [ -f "$PLUGINS_DIR/RROPlugin.dll" ] || [ -f "$PLUGINS_DIR/RecRoomOpen.dll" ]; then
    REVIVAL_NAME="RecRoomOpen"
    REVIVAL_COLOR="\e[95m"
    REVIVAL_EXE="RecRoom.exe"
elif [ -f "$PLUGINS_DIR/EverestPatch.dll" ] || [ -f "$PLUGINS_DIR/Everest.dll" ]; then
    REVIVAL_NAME="Everest"
    REVIVAL_COLOR="\e[94m"
    REVIVAL_EXE="RecRoom.exe"
fi

FULL_EXE_PATH="$GAME_DIR/$REVIVAL_EXE"

# Check if executable exists
if [ ! -f "$FULL_EXE_PATH" ]; then
    echo -e "\n\e[91m[ERROR]\e[0m Could not find $REVIVAL_EXE"
    echo "Looked in: $FULL_EXE_PATH"
    echo "Make sure this script is in your RecRoom game folder."
    echo
    read -r -p "Press Enter to exit..."
    exit 1
fi

# Radium already running check
if [ "$CHECK_RUNNING" -eq 1 ]; then
    if pgrep -f "$REVIVAL_EXE" > /dev/null; then
        echo -e "\n${REVIVAL_COLOR}$REVIVAL_NAME is already running!\e[0m"
        echo "If no window appears, it may still be patching."
        echo
        read -r -p "Press Enter to exit..."
        exit 0
    fi

    if [ ! -f "$CACHE_FILE" ]; then
        echo -e "\e[33mFirst run detected - BepInEx will patch in the background.\e[0m"
        echo "A window should appear within a few minutes."
        echo
    fi
fi

# Menu
clear
echo
echo "==========================================="
echo "     RecRoom Revival Launcher (Linux)"
echo "==========================================="
echo
echo -e "   Revival : ${REVIVAL_COLOR}$REVIVAL_NAME\e[0m"
echo "   Exe     : $REVIVAL_EXE"
echo
echo "   Plugins loaded:"
for plugin in "$PLUGINS_DIR"/*.dll; do
    [ -f "$plugin" ] && echo "     - $(basename "$plugin" .dll)"
done
echo
echo "-------------------------------------------"
echo "   How do you want to launch?"
echo
echo "     1  -  Screen (Desktop)"
echo "     2  -  VR"
echo "     3  -  Cancel"
echo
read -r -p "  Enter 1, 2 or 3: " CHOICE

case "$CHOICE" in
    1)
        echo -e "\nLaunching $REVIVAL_NAME - Screen mode..."
        "$FULL_EXE_PATH" +forcemode:screen
        ;;
    2)
        echo -e "\nLaunching $REVIVAL_NAME - VR mode..."
        "$FULL_EXE_PATH" +forcemode:vr
        ;;
    3|"")
        echo -e "\nCancelled."
        exit 0
        ;;
    *)
        echo -e "\nInvalid choice."
        exit 1
        ;;
esac
