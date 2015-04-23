mkdir -p outpng
for svg in [0-9]*.svg
do
    inkscape --export-background=white --export-png "outpng/${svg%.svg}.png" "${svg}"
done
