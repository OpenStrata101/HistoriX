#!/bin/bash

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