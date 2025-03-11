#!/bin/bash

# Anomaly Detection using statistical analysis
detect_anomalies() {
    log "INFO" "Starting anomaly detection analysis"
    colorize "CYAN" "Detecting unusual command patterns..."

    # Check for required tools
    if ! command -v awk &>/dev/null; then
        log "ERROR" "awk not found for anomaly detection"
        colorize "RED" "Error: awk is required for this feature"
        return 1
    fi

    # Calculate statistical baseline
    local total_commands=$(wc -l < "$HISTORY_FILE")
    local avg=$(echo "scale=2; $total_commands / $(date +%d)" | bc)
    local threshold=$(echo "$avg * 1.5" | bc)

    # Detect daily anomalies
    awk -v threshold="$threshold" '
    /^[0-9]+/ {
        day = strftime("%Y-%m-%d", $1)
        counts[day]++
    }
    END {
        for (day in counts) {
            if (counts[day] > threshold) {
                printf "%s%s (Count: %d)%s\n", "\033[0;31m", day, counts[day], "\033[0m"
            }
        }
    }' "$HISTORY_FILE" || {
        log "ERROR" "Anomaly detection failed"
        colorize "RED" "Error analyzing command patterns"
    }

    log "INFO" "Anomaly detection completed"
}