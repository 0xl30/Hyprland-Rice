#!/bin/env bash

engine=$(ibus engine)
path=$HOME/.cache/ibus-layout

if [ ! -f "$path" ]; then
  touch "$path"
fi

if [ "$engine" == "xkb:us::eng" ]; then
  ibus engine OpenBangla - OpenBangla Keyboard 
  echo "𝐁𝐍" > "$path"
else
  ibus engine xkb:us::eng - English
  echo "𝐄𝐍" > "$path"
fi

