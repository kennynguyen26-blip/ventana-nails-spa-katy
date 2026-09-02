#!/bin/bash
# =============================================================================
#  optimize-images.sh  —  Ventana Nails & Spa Katy
#
#  WHAT IT DOES (plain English):
#   1. Copies every original photo it hasn't seen before from  images/
#      into  images-originals/  so nothing is ever lost.
#   2. Shrinks every photo in  images/  (working from the saved original):
#        drinks   -> max 1200 px wide, JPEG quality 65
#        gallery  -> max 1200 px wide, JPEG quality 65
#        services -> max  900 px wide, JPEG quality 78
#        logo.png -> left untouched
#   3. If the optional WebP tool (cwebp) is installed it also writes .webp
#      copies next to each .jpg. (It is not installed on this Mac, so it skips.)
#   4. Rebuilds the browser icons + social-share image from images/logo.png:
#        favicon.ico   apple-touch-icon.png   images/og-image.jpg
#   5. Prints the folder size before and after.
#
#  HOW TO RUN (Terminal, from this folder):
#        bash optimize-images.sh
#  Safe to run again any time, e.g. after you drop in new Katy photos —
#  it only touches files that are new or changed. To rebuild EVERYTHING
#  from the saved originals (e.g. after changing the quality numbers):
#        bash optimize-images.sh --force
#
#  Uses only `sips`, which is built into every Mac. Nothing to install.
# =============================================================================
set -euo pipefail
cd "$(dirname "$0")"

SRC="images-originals"        # untouched originals live here
OUT="images"                  # the site reads from here
MAX_DRINK=1200
MAX_GALLERY=1200
MAX_SERVICE=900
Q_PHOTO=65                    # JPEG quality for drinks + gallery (0–100)
Q_SERVICE=78                  # JPEG quality for the 4 service side photos
CROP_EMBLEM=1                 # 1 = favicon uses just the round emblem at the top of the logo
                              # 0 = favicon uses the whole logo (set this if a new logo is laid out differently)

FORCE=0; [ "${1:-}" = "--force" ] && FORCE=1
MANIFEST="$SRC/optimized-sizes.txt"
mkdir -p "$SRC"; touch "$MANIFEST"

size_of()  { stat -f %z "$1"; }
width_of() { sips -g pixelWidth "$1" | awk '/pixelWidth/{print $2}'; }
mb()       { awk -v k="$1" 'BEGIN{printf "%.1f", k/1024}'; }
is_done()  { grep -qx "$1 $2" "$MANIFEST"; }
record()   { { grep -v "^$1 " "$MANIFEST" || true; echo "$1 $2"; } > "$MANIFEST.tmp"; mv "$MANIFEST.tmp" "$MANIFEST"; }

BEFORE_KB=$(du -sk "$OUT" | cut -f1)
echo "== Optimizing photos in $OUT/  (originals kept in $SRC/) =="

optimize_one() {   # $1 = file name   $2 = max width   $3 = JPEG quality
  local name="$1" maxw="$2" q="$3"
  local cur="$OUT/$name" orig="$SRC/$name"
  [ -e "$cur" ] || { echo "  missing, skipped        $name"; return; }
  if [ $FORCE -eq 0 ] && is_done "$name" "$(size_of "$cur")"; then
    echo "  already optimized       $name"; return
  fi
  # A file we haven't optimized yet is a genuine original -> keep a safe copy
  if [ $FORCE -eq 0 ] || [ ! -e "$orig" ]; then cp -p "$cur" "$orig"; fi
  local w before tmp
  w="$(width_of "$orig")"; before="$(size_of "$orig")"
  tmp="$OUT/.tmp-$name"
  if [ "$w" -gt "$maxw" ]; then
    sips -s format jpeg -s formatOptions "$q" --resampleWidth "$maxw" "$orig" --out "$tmp" >/dev/null
  else
    sips -s format jpeg -s formatOptions "$q" "$orig" --out "$tmp" >/dev/null
  fi
  # never make a file bigger than the original
  if [ "$(size_of "$tmp")" -ge "$before" ]; then cp -p "$orig" "$tmp"; fi
  mv "$tmp" "$cur"
  if command -v cwebp >/dev/null 2>&1; then
    cwebp -quiet -q 75 "$cur" -o "${cur%.jpg}.webp"
  fi
  record "$name" "$(size_of "$cur")"
  printf "  %-24s %5s px wide  %6d KB -> %5d KB\n" "$name" "$(width_of "$cur")" $((before/1024)) $(( $(size_of "$cur")/1024 ))
}

for i in $(seq 1 6);  do optimize_one "gallery-$i.jpg" "$MAX_GALLERY" "$Q_PHOTO"; done
for n in manicure pedicure nails waxing; do optimize_one "service-$n.jpg" "$MAX_SERVICE" "$Q_SERVICE"; done
for i in $(seq 1 32); do optimize_one "drink-$i.jpg" "$MAX_DRINK" "$Q_PHOTO"; done

# ---- Icons + social share image, always rebuilt from images/logo.png --------
echo "== Building favicon.ico, apple-touch-icon.png, images/og-image.jpg from logo.png =="
LOGO="$OUT/logo.png"; TMPD="$(mktemp -d)"
if [ "$CROP_EMBLEM" = "1" ]; then
  # the round emblem sits in the top ~2/3 of the 600x600 logo; crop a 400x400 square around it
  W=$(sips -g pixelWidth "$LOGO" | awk '/pixelWidth/{print $2}'); S=$((W*94/100)); X=$((W*3/100)); sips -c "$S" "$S" --cropOffset 0 "$X" "$LOGO" --out "$TMPD/emblem.png" >/dev/null 2>&1   # square from the top of the logo = the round emblem
else
  cp "$LOGO" "$TMPD/emblem.png"
fi
sips -s format ico -Z 48 "$TMPD/emblem.png" --out favicon.ico >/dev/null
sips -Z 180 "$TMPD/emblem.png" --out apple-touch-icon.png >/dev/null
sips -Z 560 "$LOGO" --out "$TMPD/og.png" >/dev/null
sips -p 630 1200 --padColor 1A1A1A "$TMPD/og.png" --out "$TMPD/og-pad.png" >/dev/null 2>&1
sips -s format jpeg -s formatOptions 85 "$TMPD/og-pad.png" --out "$OUT/og-image.jpg" >/dev/null
rm -rf "$TMPD"
if command -v cwebp >/dev/null 2>&1; then echo "  (cwebp found: .webp copies were written)"; else echo "  (cwebp not installed: no .webp copies, the site uses plain .jpg)"; fi

AFTER_KB=$(du -sk "$OUT" | cut -f1)
echo "== Done =="
echo "  $OUT/ before : $(mb "$BEFORE_KB") MB"
echo "  $OUT/ after  : $(mb "$AFTER_KB") MB"
echo "  originals    : $(mb "$(du -sk "$SRC" | cut -f1)") MB in $SRC/ (safe to delete once you're happy)"
