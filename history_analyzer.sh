#!/bin/bash

# HistoriX - Advanced Command History Analyzer
# Author: intrepidDev101
# Version: 2.1 (Improved)

# Configuration
HISTORY_FILE="$HOME/.bash_history"
TEMP_FILE="/tmp/frequency_data.txt"
TIME_OF_DAY_FILE="/tmp/time_of_day.txt"
LOG_FILE="/tmp/command_analyzer.log"

# Function to display ASCII art with 256 colors
display_ascii_art() {
    echo -e "\033[38;5;44m██╗  ██╗██╗███████╗████████╗ ██████╗ ██████╗ ██╗██╗  ██╗\033[0m"
    echo -e "\033[38;5;45m██║  ██║██║██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██║╚██╗██╔╝\033[0m"
    echo -e "\033[38;5;46m███████║██║███████╗   ██║   ██║   ██║██████╔╝██║ ╚███╔╝ \033[0m"
    echo -e "\033[38;5;47m██╔══██║██║╚════██║   ██║   ██║   ██║██╔══██╗██║ ██╔██╗ \033[0m"
    echo -e "\033[38;5;48m██║  ██║██║███████║   ██║   ╚██████╔╝██║  ██║██║██╔╝ ██╗\033[0m"
    echo -e "\033[38;5;49m╚═╝  ╚═╝╚═╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝\033[0m"
    echo ""
}

# Function to clear the terminal
clear_terminal() {
    clear
}

# Colors
declare -A COLORS=( ["RED"]="\033[0;31m" ["GREEN"]="\033[0;32m" ["YELLOW"]="\033[0;33m" ["CYAN"]="\033[0;36m" ["MAGENTA"]="\033[0;35m" ["RESET"]="\033[0m" )
colorize() { echo -e "${COLORS[$1]}$2${COLORS[RESET]}"; }

# IMPROVEMENT: Error handling for missing history file
if [[ ! -f "$HISTORY_FILE" ]]; then
    colorize "RED" "Error: History file not found at $HISTORY_FILE!"
    exit 1
fi

# Helper: Analyze Command Frequency
analyze_frequency() {
    awk '{print $1}' "$HISTORY_FILE" | sort | uniq -c | sort -nr
}

# Most Frequent Commands
show_frequent() {
    colorize "CYAN" "Most Frequent Commands:"
    analyze_frequency | head -n 10 | awk -v color="${COLORS[GREEN]}" '{printf "%s[%d] %s%s\n", color, $1, $2, "\033[0m"}'
    echo ""
}

# Commands with `sudo`
show_sudo() {
    colorize "CYAN" "Commands Run with sudo:"
    grep -i 'sudo' "$HISTORY_FILE" | sort | uniq -c | awk '{printf "%s[%d] %s%s\n", "\033[0;33m", $1, $2, "\033[0m"}'
    echo ""
}

# Unique Commands
show_unique() {
    colorize "CYAN" "Unique Commands:"
    awk '{print $1}' "$HISTORY_FILE" | sort | uniq | awk '{printf "%s%s%s\n", "\033[0;35m", $1, "\033[0m"}'
    echo ""
}

# Potentially Dangerous Commands
show_dangerous() {
    colorize "CYAN" "Potentially Dangerous Commands:"
    grep -E '\<(rm|mv|dd|shutdown|reboot|mkfs)\>' "$HISTORY_FILE" | sort | uniq | awk '{printf "%s%s%s\n", "\033[0;31m", $0, "\033[0m"}'
    echo ""
}

# Total Commands
show_total() {
    local total=$(wc -l < "$HISTORY_FILE")
    colorize "CYAN" "Total Commands Executed: $total"
    echo ""
}

# Generate Visualization (Frequency Chart)
generate_visualization() {
    # IMPROVEMENT: Check for gnuplot and provide fallback
    if ! command -v gnuplot &> /dev/null; then
        colorize "RED" "Error: GNUplot is not installed! Install it using 'sudo apt install gnuplot'."
        return
    fi
    analyze_frequency | head -n 10 | awk '{print $2, $1}' > "$TEMP_FILE"
    gnuplot -e "
        set terminal png size 800,600;
        set output '/tmp/command_usage.png';
        set title 'Top 10 Most Frequent Commands';
        set xlabel 'Command';
        set ylabel 'Frequency';
        set xtics rotate by -45;
        plot '$TEMP_FILE' using 2:xtic(1) with boxes notitle;
    "
    colorize "CYAN" "Visualization saved to /tmp/command_usage.png"
}

# Time-of-Day Analysis
analyze_time_of_day() {
    # IMPROVEMENT: Validate timestamps before proceeding
    if ! grep -q "^[0-9]" "$HISTORY_FILE"; then
        colorize "RED" "Error: Timestamps not found in history file! Enable timestamps with 'export HISTTIMEFORMAT=\"%F %T \"'."
        return
    fi
    awk '{if ($0 ~ /^[0-9]+/) {ts=$1; cmd=substr($0, index($0,$2))} else {cmd=$0} print ts, cmd}' "$HISTORY_FILE" |
    awk '{print strftime("%H:%M", $1), $2}' | sort | uniq -c > "$TIME_OF_DAY_FILE"
    if ! command -v gnuplot &> /dev/null; then
        colorize "RED" "Error: GNUplot is not installed! Install it using 'sudo apt install gnuplot'."
        return
    fi
    gnuplot -e "
        set terminal png size 800,600;
        set output '/tmp/time_of_day.png';
        set title 'Command Usage by Time';
        set xlabel 'Time of Day';
        set ylabel 'Frequency';
        plot '$TIME_OF_DAY_FILE' using 2:xtic(1) with lines;
    "
    colorize "CYAN" "Time-of-Day Analysis Chart saved to /tmp/time_of_day.png"
}

# Suggestions Based on History
give_suggestions() {
    colorize "CYAN" "Suggestions Based on Your History:"
    grep -q "rm -rf" "$HISTORY_FILE" && colorize "RED" "Warning: You frequently use 'rm -rf'. Consider safer alternatives."
    grep -q "docker ps" "$HISTORY_FILE" && colorize "GREEN" "Tip: Use 'docker logs <container>' for detailed logs."
    echo ""
}

# Export Results
export_results() {
    read -p "Export Format (csv/json): " format
    case "$format" in
        csv)
            analyze_frequency | awk '{print $2 "," $1}' > "$HOME/command_history.csv"
            colorize "GREEN" "Exported to $HOME/command_history.csv"
            ;;
        json)
            echo "[" > "$HOME/command_history.json"
            analyze_frequency | awk '{printf "{\"command\": \"%s\", \"count\": %d},\n", $2, $1}' >> "$HOME/command_history.json"
            sed -i '$ s/,$//' "$HOME/command_history.json"
            echo "]" >> "$HOME/command_history.json"
            colorize "GREEN" "Exported to $HOME/command_history.json"
            ;;
        *)
            colorize "RED" "Invalid format! Please choose 'csv' or 'json'."
            ;;
    esac
}

# Filter by Date
filter_by_date() {
    # IMPROVEMENT: Validate date format
    read -p "Enter start date (YYYY-MM-DD): " start_date
    read -p "Enter end date (YYYY-MM-DD): " end_date
    if ! grep -q "^[0-9]" "$HISTORY_FILE"; then
        colorize "RED" "Error: Timestamps not found in history file! Enable timestamps with 'export HISTTIMEFORMAT=\"%F %T \"'."
        return
    fi
    if ! [[ "$start_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || ! [[ "$end_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        colorize "RED" "Invalid date format! Please use YYYY-MM-DD."
        return
    fi
    awk -v start="$start_date" -v end="$end_date" '
        /^[0-9]+/ {
            ts=strftime("%Y-%m-%d", $1);
            if (ts >= start && ts <= end) {
                print $0
            }
        }' "$HISTORY_FILE"
}

# Group/Tag Commands
group_commands() {
    colorize "CYAN" "Grouping Commands by Patterns:"
    declare -A groups=( ["git"]="git" ["docker"]="docker" ["python"]="python" ["ssh"]="ssh" )
    for group in "${!groups[@]}"; do
        echo "$group commands:"
        grep -E "^${groups[$group]}" "$HISTORY_FILE" | sort | uniq
        echo ""
    done
}

# Clean History File
clean_history() {
    # IMPROVEMENT: Add confirmation prompt
    read -p "Are you sure you want to clean sensitive data from history? (y/n): " confirm
    if [[ "$confirm" == "y" ]]; then
        sed -i '/password/d; /token/d; /secret/d; /key=/d' "$HISTORY_FILE"
        colorize "GREEN" "Sensitive data cleaned from history."
    else
        colorize "YELLOW" "Operation canceled."
    fi
}

# Execution Statistics
execution_statistics() {
    colorize "CYAN" "Execution Statistics:"
    if ! grep -q "^[0-9]" "$HISTORY_FILE"; then
        colorize "RED" "Error: Timestamps not found in history file! Enable timestamps with 'export HISTTIMEFORMAT=\"%F %T \"'."
        return
    fi
    awk '{if ($0 ~ /^[0-9]+/) {ts=$1; cmd=substr($0, index($0,$2))} else {cmd=$0} print ts, cmd}' "$HISTORY_FILE" |
    awk 'BEGIN {prev=0; count=0} {
        if (NR > 1) {
            diff = $1 - prev;
            printf "[%d seconds] %s\n", diff, $2;
        }
        prev = $1;
    }'
}

# Detect Frequent Combinations
detect_combinations() {
    colorize "CYAN" "Frequent Command Combinations:"
    awk '{for (i=1; i<=NF; i++) {combo=combo $i " "} print combo; combo=""}' "$HISTORY_FILE" |
    sort | uniq -c | sort -nr | head -n 10 | awk '{printf "[%d] %s\n", $1, $2}'
}

# Send Alerts
send_alerts() {
    # IMPROVEMENT: Validate email address
    read -p "Enter email address for alerts: " email
    if ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        colorize "RED" "Invalid email address!"
        return
    fi
    colorize "CYAN" "Monitoring for dangerous commands... (Ctrl+C to stop)"
    while true; do
        sleep 10
        tail -n 1 "$HISTORY_FILE" | grep -E '\<(rm|sudo)\>' && echo "Dangerous command detected!" | mail -s "Alert: Dangerous Command" "$email"
    done
}

# Process in Parallel
process_parallel() {
    # IMPROVEMENT: Check for parallel and provide fallback
    if ! command -v parallel &> /dev/null; then
        colorize "RED" "Error: GNU Parallel is not installed! Install it using 'sudo apt install parallel'."
        return
    fi
    colorize "CYAN" "Processing History in Parallel:"
    cat "$HISTORY_FILE" | parallel --jobs 4 echo {}
}

# Track Real-time Commands
track_realtime() {
    colorize "CYAN" "Tracking Real-time Commands (Ctrl+C to stop):"
    tail -f "$HISTORY_FILE"
}

# User-Specific Analysis
user_specific_analysis() {
    colorize "CYAN" "Analyzing Commands for Current User:"
    whoami
    grep "$(whoami)" "$HISTORY_FILE" | sort | uniq -c | sort -nr
}

# Main Menu
menu() {
    PS3="Select an option: "
    select option in \
        "Most Frequent Commands" \
        "Commands with sudo" \
        "Unique Commands" \
        "Dangerous Commands" \
        "Total Commands" \
        "Generate Visualization" \
        "Filter by Date" \
        "Group/Tag Commands" \
        "Clean History File" \
        "Export Results" \
        "Execution Statistics" \
        "Detect Frequent Combinations" \
        "Send Alerts" \
        "Process in Parallel" \
        "Track Real-time Commands" \
        "User-Specific Analysis" \
        "Exit"; do
        case $option in
            "Most Frequent Commands") show_frequent ;;
            "Commands with sudo") show_sudo ;;
            "Unique Commands") show_unique ;;
            "Dangerous Commands") show_dangerous ;;
            "Total Commands") show_total ;;
            "Generate Visualization") generate_visualization ;;
            "Filter by Date") filter_by_date ;;
            "Group/Tag Commands") group_commands ;;
            "Clean History File") clean_history ;;
            "Export Results") export_results ;;
            "Execution Statistics") execution_statistics ;;
            "Detect Frequent Combinations") detect_combinations ;;
            "Send Alerts") send_alerts ;;
            "Process in Parallel") process_parallel ;;
            "Track Real-time Commands") track_realtime ;;
            "User-Specific Analysis") user_specific_analysis ;;
            "Exit") exit 0 ;;
            *) colorize "RED" "Invalid option!" ;;
        esac
    done
}

# Start menu
clear_terminal
display_ascii_art
menu