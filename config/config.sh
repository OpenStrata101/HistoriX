#!/bin/bash

# Colors
declare -A COLORS=(
    ["RED"]="\033[0;31m"
    ["GREEN"]="\033[0;32m"
    ["YELLOW"]="\033[1;33m"
    ["CYAN"]="\033[0;36m"
    ["MAGENTA"]="\033[0;35m"
    ["RESET"]="\033[0m"
)

# Function to colorize text
colorize() {
    echo -e "${COLORS[$1]}$2${COLORS[RESET]}"
}

# Paths
HISTORY_FILE="$HOME/.bash_history"
LOG_DIR="$HOME/.historix/logs"
LOG_FILE="$LOG_DIR/historix.log"
ARCHIVE_DIR="$LOG_DIR/archived"
TEMP_DIR="/tmp/historix"

# Create directories if they don't exist
mkdir -p "$LOG_DIR" "$ARCHIVE_DIR" "$TEMP_DIR"

# Logging settings
LOG_LEVEL="INFO"    # DEBUG/INFO/WARNING/ERROR
LOG_MAX_SIZE="10M"  # Rotate at 10MB
LOG_RETENTION="30"  # Days to keep logs

# Logging function
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date +"%Y-%m-%d %T")
    local log_entry="[${timestamp}] [${level}] ${message}"

    # Check log level hierarchy
    declare -A level_order=( ["DEBUG"]=0 ["INFO"]=1 ["WARNING"]=2 ["ERROR"]=3 )
    if [ ${level_order[$LOG_LEVEL]} -gt ${level_order[$level]} ]; then
        return
    fi

    # Write to log file
    echo "$log_entry" >> "$LOG_FILE"
    
    # Rotate logs if needed
    if [ $(stat -c %s "$LOG_FILE") -ge $(numfmt --from=iec "$LOG_MAX_SIZE") ]; then
        rotate_logs
    fi
}

rotate_logs() {
    local timestamp=$(date +"%Y%m%d%H%M%S")
    mv "$LOG_FILE" "$ARCHIVE_DIR/historix_${timestamp}.log"
    find "$ARCHIVE_DIR" -type f -mtime +"$LOG_RETENTION" -delete
    touch "$LOG_FILE"
}