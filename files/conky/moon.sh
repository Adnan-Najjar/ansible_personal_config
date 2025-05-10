#!/usr/bin/env bash
HEMISPHERE=north
CONKY_PATH="$HOME/.config/conky"

#------------------------ Revieve Moon Data --------------------------------------------

# xidel -s "https://www.moongiant.com/phase/today" -e "<td id='today_'>{inner-html()}</td>" > "$CONKY_PATH/tmp/moon_data"
# xidel -s "https://www.moongiant.com" -e "<h2>{inner-html()}</h2>" -e '//h2' >> "$CONKY_PATH/tmp/moon_data"
part1=$(curl -s "https://www.moongiant.com/phase/today" | htmlq "#today_")
# Phase Name
echo "$part1" | htmlq img -a alt | sed "s/on.*//" > "$CONKY_PATH/tmp/moon_data"
# Illumination
echo "$part1" | htmlq span -t >> "$CONKY_PATH/tmp/moon_data"
# Next Full Moon
curl -s "https://www.moongiant.com" | htmlq "h2" -t | sed 's/,.*//' | head -n1 >> "$CONKY_PATH/tmp/moon_data"

# Make sure no empty lines
sed -i '/^$/d' "$CONKY_PATH/tmp/moon_data"

IMG=$(basename $(echo "$part1" | htmlq img -a src) | sed "s/jpg/png/g")
cp "$CONKY_PATH/images/$IMG" "$CONKY_PATH/tmp/current_moon.png"
