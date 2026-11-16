#!/usr/bin/env bash

echo "================================================"
echo "        NLP + SNA Lab"
echo "        Lab File Downloader"
echo "================================================"
echo ""

# Base URL of the GitHub repo (raw content)
# NLPSNA_REPO_BASE can override it (used only for local testing)
REPO_BASE="${NLPSNA_REPO_BASE:-https://raw.githubusercontent.com/ashbiry/nlp-sna-suite/main}"

# Practicals definition
# Format: ID|FOLDER|DESCRIPTION|FILE1,FILE2,...
# Files are downloaded from <REPO_BASE>/<FOLDER>/<FILE> into ./<FOLDER with / replaced by ->/<FILE>
PRACTICALS=(
    "s1|sna/1|SNA 1: Coding Social Networks (igraph, ggraph)|exp1.ipynb,NOTES.md,sample-output.txt,plot-c-network-3plus.png,plot-d-senators.png"
    "s2|sna/2|SNA 2: Working with APIs (senator tweets)|exp2.ipynb,NOTES.md,sample-output.txt"
    "s3|sna/3|SNA 3: Modeling a Network (box plot, scatter, regression)|exp3.ipynb,NOTES.md,sample-output.txt,plot-a-boxplot.png,plot-b-scatter.png"
    "s4|sna/4|SNA 4: Introduction to Text Analysis (mentions)|exp4.ipynb,NOTES.md,sample-output.txt"
    "s5|sna/5|SNA 5: Tools for Social Network Analysis (theory)|NOTES.md"
    "n1|nlp/1|NLP 1: Text Preprocessing & Frequent Terms (AG News)|exp1.ipynb,NOTES.md"
    "n2|nlp/2|NLP 2: Bag of Words Review Classification (IMDb)|exp2.ipynb,NOTES.md"
    "n3|nlp/3|NLP 3: TF-IDF Tweet Sentiment Analysis (Sentiment140)|exp3.ipynb,NOTES.md"
    "n4|nlp/4|NLP 4: Named Entity Recognition (spaCy)|exp4.ipynb,NOTES.md"
    "n5|nlp/5|NLP 5: Topic Modelling with LDA (20 Newsgroups)|exp5.ipynb,NOTES.md"
    "n6|nlp/6|NLP 6: Text Generation with RNN, LSTM, GRU (GPU)|exp6.ipynb,NOTES.md"
    "n7|nlp/7|NLP 7: Transformer Summarization + ROUGE (GPU)|exp7.ipynb,NOTES.md"
)

# Resource files (downloaded keeping their folder, e.g. ./data/congress.RData)
RESOURCES=(
    "d|data/congress.RData,data/committees.RData,data/senator_tweets.RData,data/senator_wiki.RData|SNA datasets (.RData)"
    "99|SETUP.md|Google Colab Setup Guide"
)

FAILED=0

get() {   # get <repo path> <local path>
    mkdir -p "$(dirname "$2")"
    if curl -fsSL "$REPO_BASE/$1" -o "$2"; then
        echo "  ✅ $2"
    else
        echo "  ❌ Failed: $1"
        FAILED=1
    fi
}

download_practical() {
    local id folder desc files out_dir file
    IFS='|' read -r id folder desc files <<< "$1"
    out_dir="${folder//\//-}"
    echo ""
    echo "Downloading $out_dir ($desc)..."
    IFS=',' read -ra file_array <<< "$files"
    for file in "${file_array[@]}"; do
        get "$folder/$file" "$out_dir/$file"
    done
}

download_resource() {
    local id names desc name
    IFS='|' read -r id names desc <<< "$1"
    echo ""
    echo "Downloading $desc..."
    IFS=',' read -ra name_array <<< "$names"
    for name in "${name_array[@]}"; do
        get "$name" "$name"
    done
}

finish() {
    echo ""
    if [ "$FAILED" -eq 1 ]; then
        echo "⚠️  Some files failed to download. Check your internet / the repository link."
    else
        echo "✅ $1"
        if [ -n "${2:-}" ]; then
            echo ""
            echo "$2"
        fi
    fi
    echo ""
    echo "Done!"
    exit "$FAILED"
}

# Display menu
echo "Available Practicals:"
echo "---------------------"
for entry in "${PRACTICALS[@]}"; do
    IFS='|' read -r id folder desc files <<< "$entry"
    echo "  $id. $desc"
    echo "     [${folder//\//-}] ${files//,/, }"
done

echo ""
echo "Resource Files:"
echo "---------------"
for entry in "${RESOURCES[@]}"; do
    IFS='|' read -r id names desc <<< "$entry"
    echo "  $id. $desc  [${names//,/, }]"
done

echo ""
echo "   0. Download everything (all practicals + resources)"

VALID_IDS=""
for entry in "${PRACTICALS[@]}" "${RESOURCES[@]}"; do
    IFS='|' read -r id _ <<< "$entry"
    VALID_IDS="${VALID_IDS:+$VALID_IDS, }$id"
done
VALID_IDS="$VALID_IDS, 0"

echo ""
# Read from the terminal so this also works with: curl ... | bash
read -rp "Enter your choice [$VALID_IDS]: " CHOICE < /dev/tty
CHOICE="$(echo "${CHOICE//[[:space:]]/}" | tr '[:upper:]' '[:lower:]')"

if [[ "$CHOICE" == "0" ]]; then
    for entry in "${PRACTICALS[@]}"; do download_practical "$entry"; done
    for entry in "${RESOURCES[@]}"; do download_resource "$entry"; done
    finish "Everything downloaded to $(pwd)/"
fi

for entry in "${RESOURCES[@]}"; do
    IFS='|' read -r id _ <<< "$entry"
    if [[ "$id" == "$CHOICE" ]]; then
        download_resource "$entry"
        finish "Saved in $(pwd)/"
    fi
done

for entry in "${PRACTICALS[@]}"; do
    IFS='|' read -r id folder _ <<< "$entry"
    if [[ "$id" == "$CHOICE" ]]; then
        download_practical "$entry"
        finish "All files downloaded to ./${folder//\//-}/" "Next: open the .ipynb in Google Colab (File → Upload notebook) and read NOTES.md"
    fi
done

echo "Invalid choice! Please enter one of: $VALID_IDS"
exit 1
