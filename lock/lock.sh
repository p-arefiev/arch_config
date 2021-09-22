#!/bin/bash

# Stop dunst
# pkill -u $USER -USR1 dunst

scrot /tmp/screen.png
convert /tmp/screen.png -scale 5% -blur 0x4 -resize 2000% /tmp/screen.png

if [[ -f $HOME/Documents/arch_config/lock/lock.png ]]
then
	convert /tmp/screen.png $HOME/Documents/arch_config/lock/lock.png -composite /tmp/screen.png
fi

i3lock -e -n -i /tmp/screen.png \
	--insidever-color=2e2e2e6f --insidewrong-color=ff79687d --inside-color=ffffff00 \
	--ringver-color=b9b4aa8f --ringwrong-color=cd89688f --ring-color=ffffff00 \
	--line-uses-ring --keyhl-color=c9c4baff --bshl-color=ff7968ff \
	--separator-color=2e2e2edf --verif-color=efefefff --wrong-color=efefefff \
	--verif-text="verifying" --wrong-text="incorrect" --noinput-text="none"

# pkill -u $USER -USR2 dunst

rm /tmp/screen.png
