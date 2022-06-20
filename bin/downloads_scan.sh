#!/bin/bash

TARGET=~/Downloads
QUARANTINE=~/.quarantine

echo "Watching $TARGET and scanning with clamav"

if ! which clamdscan; then
    echo "No clamdscan, unable to run"
    exit 1
fi

inotifywait -m "$TARGET" -e close_write | while read dirpath action file; do
    filepath="$dirpath$file"
    echo "Scanning $filepath"
    notify-send "Scanning $filepath"
    clamscanOutput="$(clamdscan --fdpass "$filepath" --move "$QUARANTINE" --infected)"
    infectedFiles="$(echo "$clamscanOutput" | grep "Infected files:" | sed 's/.*:\s*//')"

    if (( $infectedFiles == 0)); then
        notify-send "OK, $filepath not infected"
    else
        notify-send "!!! $filepath infected, moved to $QUARANTINE"
    fi
done
