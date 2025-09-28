#!/bin/bash

if pgrep -x bemenu-run > /dev/null; then
    pkill -x bemenu-run
else
    bemenu-run
fi


