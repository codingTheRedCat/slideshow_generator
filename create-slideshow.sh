#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <text_file> <resolution> <output_file>"
    exit 1
fi

input_file="$1"
resolution="$2"
output_video="$3"
temp_dir=$(mktemp -d)
counter=0

# Iterate through each line in the text file
while IFS= read -r line; do
    let counter++
    # Generate a PNG image for each line
    convert -size 640x420 xc:transparent -pointsize 18 -fill white -draw "text 10,200 '$line'" "$temp_dir/$counter.png"
done < "$input_file"

# Use FFmpeg to create a video from the PNG images
ffmpeg -framerate 1 -pattern_type glob -i "$temp_dir/*.png" -c:v libx264 -r 10 -pix_fmt yuv420p -s "$resolution" "$output_video"

# Clean up temporary directory
rm -r "$temp_dir"

echo "Slideshow created: $output_video"

