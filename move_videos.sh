#!/bin/bash

SOURCE="/home/runner/work/Linux/Linux/Mega"
DEST="/home/runner/work/Linux/Linux/input"

mkdir -p "$DEST"

find "$SOURCE" -type f \( \
    -iname "*.mp4" -o \
    -iname "*.mkv" -o \
    -iname "*.mov" -o \
    -iname "*.avi" -o \
    -iname "*.wmv" -o \
    -iname "*.webm" -o \
    -iname "*.flv" -o \
    -iname "*.m4v" -o \
    -iname "*.mpeg" -o \
    -iname "*.mpg" \
\) ! -path "$DEST/*" -print0 | while IFS= read -r -d '' file; do

    filename=$(basename "$file")
    name="${filename%.*}"
    extension="${filename##*.}"

    destination="$DEST/$filename"
    counter=1

    while [ -e "$destination" ]; do
        destination="$DEST/${name}_${counter}.${extension}"
        ((counter++))
    done

    echo "Moving: $file"
    echo "     -> $destination"

    mv -- "$file" "$destination"
done

echo
echo "================================"
echo "Finished!"
echo "Videos are in:"
echo "$DEST"
echo "================================"
