#!/bin/bash

# Core analysis functions with logging
source "$(dirname "$0")/../config/config.sh"

# 1. Most Frequent Commands
show_frequent() {
    log "INFO" "Starting frequency analysis"
    colorize "CYAN" "Most Frequent Commands:"
    
    if [ ! -f "$HISTORY_FILE" ]; then
        log "ERROR" "History file not found: $HISTORY_FILE"
        colorize "RED" "Error: History file not found!"
        return 1
    fi

    analyze_frequency | head -n 10 | awk -v color="${COLORS[GREEN]}" '{
        printf "%s[%d] %s%s\n", color, $1, $2, "\033[0m"
    }' || {
        log "WARNING" "Frequency analysis failed"
        colorize "YELLOW" "No frequent commands found"
    }
    
    log "INFO" "Frequency analysis completed"
}

# 2. Commands with sudo
show_sudo() {
    log "INFO" "Analyzing sudo commands"
    colorize "CYAN" "Commands Run with sudo:"
    
    if ! grep -q "sudo" "$HISTORY_FILE"; then
        log "WARNING" "No sudo commands found"
        colorize "YELLOW" "No sudo commands detected"
        return 0
    fi
    
    grep -i 'sudo' "$HISTORY_FILE" | sort | uniq -c | sort -nr | awk '{
        printf "%s[%d] %s%s\n", "\033[0;33m", $1, $2, "\033[0m"
    }' || {
        log "ERROR" "Sudo command analysis failed"
        colorize "RED" "Error analyzing sudo commands"
    }
    
    log "INFO" "Sudo command analysis completed"
}

# 3. Unique Commands
show_unique() {
    log "INFO" "Analyzing unique commands"
    colorize "CYAN" "Unique Commands:"
    
    awk '{print $1}' "$HISTORY_FILE" | sort | uniq | awk '{
        printf "%s%s%s\n", "\033[0;35m", $1, "\033[0m"
    }' | {
        read -r first_line
        if [ -z "$first_line" ]; then
            log "WARNING" "No unique commands found"
            colorize "YELLOW" "No commands detected"
        else
            cat
        fi
    }
    
    log "INFO" "Unique command analysis completed"
}

# 4. Potentially Dangerous Commands
show_dangerous() {
    log "INFO" "Checking for dangerous commands"
    colorize "CYAN" "Potentially Dangerous Commands:"
    
    dangerous_patterns='\<(rm|mv|dd|shutdown|reboot|mkfs|chmod|chown)\>'
    if ! grep -Eq "$dangerous_patterns" "$HISTORY_FILE"; then
        log "INFO" "No dangerous commands found"
        colorize "GREEN" "No dangerous commands detected"
        return 0
    fi
    
    grep -E "$dangerous_patterns" "$HISTORY_FILE" | sort | uniq | awk '{
        printf "%s%s%s\n", "\033[0;31m", $0, "\033[0m"
    }' || {
        log "ERROR" "Dangerous command analysis failed"
        colorize "RED" "Error analyzing dangerous commands"
    }
    
    log "INFO" "Dangerous command check completed"
}

# 5. Total Commands
show_total() {
    log "INFO" "Calculating total commands"
    local total=$(wc -l < "$HISTORY_FILE" 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        log "ERROR" "Failed to read history file"
        colorize "RED" "Error reading history file!"
        return 1
    fi
    
    colorize "CYAN" "Total Commands Executed: $total"
    log "INFO" "Total command count: $total"
}

# 6. Generate Visualization
generate_visualization() {
    log "INFO" "Starting visualization generation"
    
    if ! command -v gnuplot &>/dev/null; then
        log "ERROR" "GNUplot not found"
        colorize "RED" "Error: GNUplot is not installed!"
        return 1
    fi
    
    local tmp_file="$TEMP_DIR/frequency_data.txt"
    analyze_frequency | head -n 10 | awk '{print $2, $1}' > "$tmp_file"
    
    gnuplot -e "
        set terminal png size 800,600;
        set output '$TEMP_DIR/command_usage.png';
        set title 'Top 10 Most Frequent Commands';
        set xlabel 'Command';
        set ylabel 'Frequency';
        set xtics rotate by -45;
        plot '$tmp_file' using 2:xtic(1) with boxes notitle;
    " && {
        colorize "CYAN" "Visualization saved to $TEMP_DIR/command_usage.png"
        log "INFO" "Visualization generated successfully"
    } || {
        log "ERROR" "Visualization generation failed"
        colorize "RED" "Error creating visualization"
    }
}

# 7. Filter by Date
filter_by_date() {
    log "INFO" "Starting date filter operation"
    local start_date end_date
    
    read -p "Enter start date (YYYY-MM-DD): " start_date
    read -p "Enter end date (YYYY-MM-DD): " end_date
    
    if ! [[ "$start_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || 
       ! [[ "$end_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        log "ERROR" "Invalid date format: $start_date - $end_date"
        colorize "RED" "Invalid date format! Use YYYY-MM-DD"
        return 1
    fi
    
    awk -v start="$start_date" -v end="$end_date" '
        /^[0-9]+/ {
            ts=strftime("%Y-%m-%d", $1);
            if (ts >= start && ts <= end) {
                print $0
            }
        }
    ' "$HISTORY_FILE" || {
        log "ERROR" "Date filtering failed"
        colorize "RED" "Error filtering commands by date"
    }
    
    log "INFO" "Date filter completed for $start_date to $end_date"
}

# 8. Group/Tag Commands
group_commands() {
    log "INFO" "Grouping commands by patterns"
    colorize "CYAN" "Grouping Commands by Patterns:"
    
    declare -A groups=(
        ["Git"]="git"
        ["Docker"]="docker"
        ["Python"]="python|pip|venv"
        ["System"]="(sudo|apt|yum|dnf|systemctl)"
        ["Network"]="ssh|curl|wget|ping"
    )
    
    for group in "${!groups[@]}"; do
        local pattern="${groups[$group]}"
        colorize "MAGENTA" "$group Commands:"
        grep -E "^\s*($pattern)" "$HISTORY_FILE" | sort | uniq || {
            log "WARNING" "No $group commands found"
            colorize "YELLOW" "No $group commands detected"
        }
        echo
    done
    
    log "INFO" "Command grouping completed"
}

# 9. Clean History File
clean_history() {
    log "INFO" "Initiating history cleaning process"
    colorize "YELLOW" "This will remove sensitive patterns from your history"
    
    read -p "Are you sure? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
        log "INFO" "History cleaning canceled by user"
        colorize "YELLOW" "Operation canceled"
        return 0
    fi
    
    local sensitive_patterns='password|token|secret|key=|pass=|api_key'
    sed -i -E "/($sensitive_patterns)/d" "$HISTORY_FILE" && {
        colorize "GREEN" "Sensitive data removed successfully"
        log "INFO" "History cleaned of sensitive patterns"
    } || {
        log "ERROR" "History cleaning failed"
        colorize "RED" "Error cleaning history file"
    }
}

# 10. Export Results
export_results() {
    log "INFO" "Starting export process"
    local format
    
    read -p "Export format (csv/json): " format
    case "$format" in
        csv)
            analyze_frequency | awk -F' ' '{print $2","$1}' > "$HOME/command_history.csv" && {
                colorize "GREEN" "Exported to CSV: $HOME/command_history.csv"
                log "INFO" "CSV export completed"
            } || {
                log "ERROR" "CSV export failed"
                colorize "RED" "CSV export failed"
            }
            ;;
        json)
            echo "[" > "$HOME/command_history.json"
            analyze_frequency | awk -F' ' '{
                printf "{\"command\": \"%s\", \"count\": %d},\n", $2, $1
            }' >> "$HOME/command_history.json"
            sed -i '$ s/,$//' "$HOME/command_history.json"
            echo "]" >> "$HOME/command_history.json" && {
                colorize "GREEN" "Exported to JSON: $HOME/command_history.json"
                log "INFO" "JSON export completed"
            } || {
                log "ERROR" "JSON export failed"
                colorize "RED" "JSON export failed"
            }
            ;;
        *)
            log "ERROR" "Invalid export format: $format"
            colorize "RED" "Invalid format! Choose 'csv' or 'json'"
            ;;
    esac
}

# 11. Execution Statistics
execution_statistics() {
    log "INFO" "Calculating command execution statistics"
    colorize "CYAN" "Execution Statistics:"
    
    if ! grep -q "^[0-9]" "$HISTORY_FILE"; then
        log "WARNING" "No timestamps found in history"
        colorize "YELLOW" "No timestamp data available"
        return 0
    fi
    
    awk '
        /^[0-9]+/ {
            if (prev_ts) {
                diff = $1 - prev_ts
                printf "[%d seconds] %s\n", diff, $2
            }
            prev_ts = $1
        }
    ' "$HISTORY_FILE" | {
        read -r first_line
        if [ -z "$first_line" ]; then
            log "INFO" "No execution intervals found"
            colorize "YELLOW" "No execution intervals detected"
        else
            cat
        fi
    }
    
    log "INFO" "Execution statistics completed"
}

# 12. Detect Frequent Combinations
detect_combinations() {
    log "INFO" "Analyzing command combinations"
    colorize "CYAN" "Frequent Command Combinations:"
    
    awk '{
        combo=""
        for (i=1; i<=NF; i++) {
            combo = combo $i " "
        }
        print combo
    }' "$HISTORY_FILE" | sort | uniq -c | sort -nr | head -n 10 | awk '{
        printf "[%d] %s\n", $1, $2
    }' || {
        log "WARNING" "No command combinations found"
        colorize "YELLOW" "No frequent combinations detected"
    }
    
    log "INFO" "Command combination analysis completed"
}

# 13. Send Alerts
send_alerts() {
    log "INFO" "Configuring command alerts"
    colorize "YELLOW" "This feature requires mailutils installed"
    
    if ! command -v mail &>/dev/null; then
        log "ERROR" "mailutils not found"
        colorize "RED" "Error: mailutils not installed!"
        return 1
    fi
    
    read -p "Enter email address: " email
    if ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        log "ERROR" "Invalid email: $email"
        colorize "RED" "Invalid email address!"
        return 1
    fi
    
    log "INFO" "Starting alert monitoring (Ctrl+C to stop)"
    colorize "CYAN" "Monitoring for dangerous commands..."
    
    tail -Fn0 "$HISTORY_FILE" | while read -r line; do
        if echo "$line" | grep -qE '\<(rm|sudo|dd)\>'; then
            echo "Dangerous command detected: $line" | mail -s "Alert: Dangerous Command" "$email"
            log "WARNING" "Alert sent for command: $line"
        fi
    done
}

# 14. Process in Parallel
process_parallel() {
    log "INFO" "Starting parallel processing"
    
    if ! command -v parallel &>/dev/null; then
        log "ERROR" "GNU Parallel not found"
        colorize "RED" "Error: GNU Parallel not installed!"
        return 1
    fi
    
    colorize "CYAN" "Processing history in parallel (4 jobs)"
    cat "$HISTORY_FILE" | parallel --jobs 4 --bar 'echo {}' || {
        log "ERROR" "Parallel processing failed"
        colorize "RED" "Error during parallel processing"
    }
    
    log "INFO" "Parallel processing completed"
}

# 15. Track Real-time Commands
track_realtime() {
    log "INFO" "Starting real-time tracking (Ctrl+C to stop)"
    colorize "CYAN" "Real-time command tracking:"
    
    tail -Fn0 "$HISTORY_FILE" | while read -r line; do
        timestamp=$(date +"%Y-%m-%d %T")
        log "DEBUG" "Realtime command: $line"
        echo "[$timestamp] $line"
    done
}

# 16. User-Specific Analysis
user_specific_analysis() {
    log "INFO" "Starting user-specific analysis"
    local current_user=$(whoami)
    colorize "CYAN" "Analyzing commands for user: $current_user"
    
    grep "$current_user" "$HISTORY_FILE" | sort | uniq -c | sort -nr | awk '{
        printf "[%d] %s\n", $1, $2
    }' || {
        log "WARNING" "No user-specific commands found"
        colorize "YELLOW" "No commands found for current user"
    }
    
    log "INFO" "User-specific analysis completed"
}

# Helper functions
analyze_frequency() {
    awk '{print $1}' "$HISTORY_FILE" | sort | uniq -c | sort -nr
}