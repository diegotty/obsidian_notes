#!/bin/bash
# thanks [github]@aglaianorza 4 the script !
# script to push my handwritten notes to my gh repo
# latex="$HOME/Documents/uni/latex"

drive="$HOME/diego/notes_drive"
dest="$HOME/diego/uni/obsidian_notes"

declare -A notes

hname="PC"

if [ "$(uname -n )" = "laptop" ]; then
    hname="laptop"
elif ! mount | grep "gdrive" > /dev/null; then
    echo "mounting drive"
    rclone mount --daemon notes_drive:notability/y3s2/ ~/diego/notes_drive
    notes["$drive/optimization/optimization notes.pdf"]="year 3, semester 2/optimization notes.pdf"
else
    echo "drive is mounted"
    notes["$drive/optimization/optimization notes.pdf"]="year 3, semester 2/optimization notes.pdf"
fi

# notes["$latex/logmat/logmat.pdf"]="terzo anno/logica matematica.pdf"
# notes["$latex/logmat/logmat.tex"]="terzo anno/tex/logica matematica.tex"

for file in "${!notes[@]}"; do
    cp "$file" "$dest/${notes[$file]}" || { echo "$file failed"; exit 1; }
done

echo "updating notes repo"

cd "$dest" && git pull

if [ $? -eq 0 ] && [[ $(git status --porcelain) ]]; then

    # while read -r reads line by line from stdin and stores in 'f'
    # basename strips
    # paste -sd ',' - pastes lines with ',' delimiter
    # (just having fun w/bash)
    #pdf_list=$(git diff --name-only -- '*.pdf' | while read -r f; do
    #    basename "$f" .pdf
    #done | paste -sd '/' -)

    pdf_list=$(git -c core.quotepath=false diff --name-only -- '*.pdf' | while read -r f; do
    basename "$f" .pdf
done | paste -sd '/' -)

git add . && git commit -m "sync $(date +'%d-%m'): $pdf_list [$hname]" && git push
else
    echo "no changes in handwritten notes !"
fi
