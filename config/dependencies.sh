#!/bin/bash

# Source common functions and configurations
source "$(dirname "$0")/config.sh"

check_dependencies() {
    local required=("awk" "gnuplot" "parallel" "python3")
    local missing=()

    for cmd in "${required[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        log "ERROR" "Missing dependencies: ${missing[*]}"
        colorize "RED" "Please install: ${missing[*]}"
        exit 1
    fi
}