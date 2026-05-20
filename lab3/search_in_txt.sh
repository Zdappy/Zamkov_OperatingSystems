#!/bin/bash
if [ -z "$1" ]; then
    echo "error"
    exit 1
fi

SEARCH="$1"
SEARCH_DIR="${2:-$1}"
RESULT="found_file.txt"

echo "$SEARCH_DIR" > "$SEARCH"
while read -r file; do
    if grep -q "$file" "$SEARCH_DIR"; then
        echo "$file" >> "$RESULT"
    fi
done

echo "ACCESS, result $RESULT"
cat "$RESULT"
