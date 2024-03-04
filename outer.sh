#!/bin/bash
echo() {
    command echo "$1"
    sleep 0.5
}

os_name=$(uname)
echo "checking system needs"

if [ "$os_name" = "Linux" ]; then
    echo "Linux detected."
    customgrep() {
        grep "$@"
    }
elif [ "$os_name" = "Darwin" ]; then
    echo "macOS detected."
    echo "Checking if ggrep is installed..."
    if command -v ggrep &> /dev/null; then
        echo "ggrep is installed."
        customgrep() {
            ggrep "$@"
        }
    else
        echo "GNU grep is not installed or does not support -P option."
        echo "Please install grep for macOS (brew install grep)"
        exit
    fi
else
    echo "Unknown OS: $os_name"
    exit
fi

sleep 0.5
echo "running script"

extract_urls() {
    customgrep -oP 'https?://\S+' "$1"
}

search_urls() {
    local file="$1"

    if [ -f "$file" ]; then
        urls=$(extract_urls "$file")
        if [ -n "$urls" ]; then
            echo "URLs found in $file:"
            echo "$urls"
            echo "-----------------------------"
        fi
    elif [ -d "$file" ]; then
        for f in "$file"/*; do
            search_urls "$f"
        done
    fi
}

main() {
    if [ $# -ne 1 ]; then
        echo "Usage: $0 DIRECTORY"
        exit 1
    fi

    if [ ! -d "$1" ]; then
        echo "$1 is not a directory."
        exit 1
    fi

    search_urls "$1"
}

main "$@"
