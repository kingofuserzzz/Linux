#!/bin/bash

# Create folders
mkdir -p input output watermark

echo
echo "========================================"
echo "    Vertical Watermark Scroller"
echo "========================================"
echo

# Find first PNG watermark
WM=$(find watermark -maxdepth 1 -type f -iname "*.png" | head -n 1)

if [ -z "$WM" ]; then
    echo "[ERROR] No PNG file found in the 'watermark' folder!"
    exit 1
fi

echo "[INFO] Using watermark: $WM"
echo "[INFO] Vertical scrolling (top to bottom)"
echo

count=0

for file in input/*; do

    # Skip directories
    [ -f "$file" ] || continue

    count=$((count + 1))

    filename=$(basename "$file")
    name="${filename%.*}"

    echo "[$count] Processing: $filename"

    ffmpeg -i "$file" -i "$WM" \
        -filter_complex "overlay=x=(W-w)/2:y=mod(t*40\,H+h)-h" \
        -c:v libx264 -crf 18 -preset slow \
        -c:a copy \
        "output/${name}.mp4"

    if [ $? -ne 0 ]; then
        echo "    > Failed"
    else
        echo "    > Done"
    fi
done

echo
echo "========================================"
echo "Finished! $count file(s) processed."
echo "Output folder ready."
echo "========================================"