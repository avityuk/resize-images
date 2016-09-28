#!/bin/bash

set -e

BASEDIR="."
if [ -n "WERCKER_RESIZE_IMAGES_BASEDIR" ]; then
  BASEDIR="${BASEDIR}/${WERCKER_RESIZE_IMAGES_BASEDIR}"
fi

SUFFIX=""
if [ -n "$WERCKER_RESIZE_IMAGES_RESIZED_SUFFIX" ]; then
  SUFFIX=$WERCKER_RESIZE_IMAGES_RESIZED_SUFFIX
fi

if [ -n "$WERCKER_RESIZE_IMAGES_EXCLUDE_PATTERN" ]; then
  files=$(find "$BASEDIR" -name '*.jpg' -and -not -name "$WERCKER_RESIZE_IMAGES_EXCLUDE_PATTERN")
else
  files=$(find "$BASEDIR" -name '*.jpg')  
fi

for file in $files; do
  convert "$file" \
    -filter Lanczos \
    -define filter:lobes=4 \
    -resize "${WERCKER_RESIZE_IMAGES_GEOMETRY}" \
    -sampling-factor 1x1 \
    -unsharp 1.5x1+0.7+0.02 \
    -quality "${WERCKER_RESIZE_IMAGES_QUALITY}" \
    -interlace none \
    -colorspace sRGB \
    -strip \
    "${file%.*}${SUFFIX}.jpg"
done
