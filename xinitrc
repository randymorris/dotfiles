#!/bin/bash

exec /usr/bin/xmodmap ${HOME}/.Xmodmap &
exec urxvtd -o &

if [[ $1 == "flux" ]]
then
  exec /usr/bin/startfluxbox
elif [[ $1 == "dwm" ]]
then
  exec ~/bin/startdwm
elif [[ $1 == "windows" ]]
then
  exec ~/bin/startwinxp
else
  exec /usr/bin/ratpoison
fi
