#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt

get_controls

GAMEDIR=/$directory/ports/flare
cd $GAMEDIR

$ESUDO rm -rf ~/.config/flare
ln -sfv /$directory/ports/flare/conf/.config/flare ~/.config/


$ESUDO chmod 666 /dev/uinput
$GPTOKEYB "flare" xbox360 &
LD_LIBRARY_PATH="$PWD/libs" SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig" ./flare 2>&1 | tee -a ./log.txt
$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &
printf "\033c" > /dev/tty0
