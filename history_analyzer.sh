#!/bin/bash

# HistoriX - Command History Analyzer
# Author: intrepidDev101
# Description: A powerful tool to analyze, categorize, and visualize your Bash command history.
# Features: Command categorization, time-of-day analysis, frequent commands, suggestions, and more.
# Version: 1.0

# Path to Bash history file
HISTORY_FILE="$HOME/.bash_history"
TEMP_FILE="/tmp/frequency_data.txt"
LOG_FILE="/tmp/command_analyzer.log"
TIME_OF_DAY_FILE="/tmp/time_of_day.txt"
# Color definitions
declare -A COLORS=( ["RED"]="\033[0;31m" ["GREEN"]="\033[0;32m" ["YELLOW"]="\033[0;33m" ["CYAN"]="\033[0;36m" ["MAGENTA"]="\033[0;35m" ["RESET"]="\033[0m" )

# Color definitions
declare -A COLORS=( ["RED"]="\033[0;31m" ["GREEN"]="\033[0;32m" ["YELLOW"]="\033[0;33m" ["CYAN"]="\033[0;36m" ["MAGENTA"]="\033[0;35m" ["RESET"]="\033[0m" )

# Function to colorize output
colorize() { echo -e "${COLORS[$1]}$2${COLORS[RESET]}"; }

# Function to display most frequent commands
show_frequent() {
    colorize "CYAN" "Most Frequent Commands:"
    awk '{print $1}' "$HISTORY_FILE" | sort | uniq -c | sort -nr | head -n 10 | while read -r count cmd; do
        colorize "GREEN" "[$count] $cmd"
    done
    echo ""
}

# Function to display sudo commands
show_sudo() {
    colorize "CYAN" "Commands Run with sudo:"
    grep -i 'sudo' "$HISTORY_FILE" | while read -r cmd; do
        colorize "YELLOW" "$cmd"
    done
    echo ""
}

# Function to display unique commands
show_unique() {
    colorize "CYAN" "Unique Commands:"
    awk '{print $1}' "$HISTORY_FILE" | sort | uniq | while read -r cmd; do
        colorize "MAGENTA" "$cmd"
    done
    echo ""
}

# Function to display dangerous commands
show_dangerous() {
    colorize "CYAN" "Potentially Dangerous Commands:"
    grep -E 'rm|mv|dd|shutdown|reboot|mkfs' "$HISTORY_FILE" | while read -r cmd; do
        colorize "RED" "$cmd"
    done
    echo ""
}

# Function to show total number of commands
show_total() {
    local total=$(wc -l < "$HISTORY_FILE")
    colorize "CYAN" "Total Commands Executed: $total"
    echo ""
}

# Function to perform date/time filtering
filter_by_date() {
    colorize "CYAN" "Enter a date range for filtering (e.g., 'last 24 hours', 'last week'):"
    read -p "Date Range: " range
    local start_date end_date
    case "$range" in
        "last 24 hours")
            start_date=$(date -d "24 hours ago" +%s)
            ;;
        "last week")
            start_date=$(date -d "7 days ago" +%s)
            ;;
        *)
            echo "Invalid date range."
            return
            ;;
    esac
    awk -v start_date="$start_date" '{ if ($1 >= start_date) print $0 }' "$HISTORY_FILE"
}

# Function to group and tag commands
group_and_tag_commands() {
    colorize "CYAN" "Enter a command to group or tag (e.g., 'git', 'docker', 'rm'):"
    read -p "Command to Group/Tag: " cmd
    if [[ "$cmd" =~ ^git ]]; then
        group="Git Commands"
    elif [[ "$cmd" =~ ^docker ]]; then
        group="Docker Commands"
    elif [[ "$cmd" =~ ^rm ]]; then
        group="File Operations"
    else
        group="General Commands"
    fi
    colorize "YELLOW" "Grouped '$cmd' under '$group'"
}

# Function to show execution statistics
show_execution_stats() {
    colorize "CYAN" "Showing Execution Time for Commands:"
    # Measure execution time for commands (you can customize this part to track real-time execution)
    while read -r cmd; do
        echo -e "Running: $cmd"
        { time $cmd; } 2>&1 | grep real
    done < "$HISTORY_FILE"
    echo ""
}

# Function to give suggestions based on command history
give_suggestions() {
    colorize "CYAN" "Suggestions Based on Your History:"
    # Example suggestions (you can add more patterns)
    if grep -q "rm -rf" "$HISTORY_FILE"; then
        colorize "RED" "Warning: You executed potentially dangerous command 'rm -rf'. Consider alternatives like using 'rm -i' for safer deletion."
    fi
    if grep -q "docker ps" "$HISTORY_FILE"; then
        colorize "GREEN" "Suggestion: Use 'docker logs <container>' for viewing logs of your containers."
    fi
    echo ""
}

# Function to generate advanced visualizations
generate_visualization() {
    colorize "CYAN" "Generating Advanced Command Usage Visualization..."
    # Frequency chart generation using gnuplot
    awk '{print $1}' "$HISTORY_FILE" | sort | uniq -c | sort -nr | head -n 10 | awk '{print $2, $1}' > "$TEMP_FILE"
    gnuplot -e "
        set terminal png size 800,600;
        set output '/tmp/command_usage.png';
        set title 'Top 10 Most Frequent Commands';
        set xlabel 'Command';
        set ylabel 'Frequency';
        set xtics rotate by -45;
        plot '/tmp/frequency_data.txt' using 2:xtic(1) with boxes notitle;
    "
    colorize "CYAN" "Frequency Chart saved to /tmp/command_usage.png"
}

# Function to send customizable alerts
send_alerts() {
    colorize "CYAN" "Enter command pattern for alerts (e.g., 'sudo', 'rm', 'docker'):"
    read -p "Command Pattern: " pattern
    grep -i "$pattern" "$HISTORY_FILE" | while read -r cmd; do
        colorize "RED" "Alert: Found command '$cmd' matching pattern '$pattern'"
    done
}

# Function to detect frequent command combinations
detect_frequent_combinations() {
    colorize "CYAN" "Detecting Frequent Command Combinations..."
    # Simple combination logic (commands run in sequence, e.g., 'git pull && git merge')
    awk '{print $1}' "$HISTORY_FILE" | uniq -c | sort -nr | head -n 10
}

# Function to clean up the history file (remove sensitive data)
clean_history_file() {
    colorize "CYAN" "Do you want to clean up history file? (y/n)"
    read -p "Confirm Cleanup: " confirm
    if [[ "$confirm" == "y" ]]; then
        # Mask sensitive data (passwords, tokens)
        sed -i 's/\bpassword\b/*****REMOVED*****/g' "$HISTORY_FILE"
        sed -i 's/\btoken\b/*****REMOVED*****/g' "$HISTORY_FILE"
        colorize "GREEN" "History file cleaned up!"
    else
        colorize "YELLOW" "Cleanup canceled."
    fi
}

# Function to export results to CSV or JSON
export_results() {
    colorize "CYAN" "Exporting results to CSV or JSON?"
    read -p "Export Format (csv/json): " format
    if [[ "$format" == "csv" ]]; then
        awk '{print $1}' "$HISTORY_FILE" | sort | uniq -c | sort -nr > "$HOME/command_history.csv"
        colorize "GREEN" "Exported to command_history.csv"
    elif [[ "$format" == "json" ]]; then
        echo "[" > "$HOME/command_history.json"
        awk '{print "{\"command\": \"" $1 "\", \"count\": " $2 "}"}' "$HISTORY_FILE" >> "$HOME/command_history.json"
        echo "]" >> "$HOME/command_history.json"
        colorize "GREEN" "Exported to command_history.json"
    else
        colorize "RED" "Invalid format!"
    fi
}

# Function to log analysis actions
log_action() {
    local action="$1"
    echo "$(date) - $action" >> "$LOG_FILE"
}

# Multithreading/Parallel Processing for large histories
process_in_parallel() {
    colorize "CYAN" "Processing history in parallel..."
    # Use GNU parallel to process history file more efficiently
    cat "$HISTORY_FILE" | parallel -j 4 'echo {} | awk "{print $1}"' | sort | uniq -c | sort -nr > "$TEMP_FILE"
    colorize "GREEN" "Processed history in parallel!"
}

# Real-time Command Tracking (Tracks commands as they are executed)
track_real_time_commands() {
    colorize "CYAN" "Tracking commands in real-time..."
    trap 'echo "$(date): $(history 1)" >> /tmp/realtime_log.txt' DEBUG
}

# User-specific Analysis
user_specific_analysis() {
    colorize "CYAN" "Analyzing commands for user $(whoami)..."
    history_file="/home/$(whoami)/.bash_history"
    awk '{print $1}' "$history_file" | sort | uniq -c | sort -nr | head -n 10
}

# Command Categorization (Simple heuristic-based categorization)
categorize_command() {
    colorize "CYAN" "Categorizing commands..."
    while read -r cmd; do
        # Categorize commands based on simple patterns (you can improve this with more sophisticated rules)
        if [[ "$cmd" =~ git ]]; then
            echo "Git command: $cmd"
        elif [[ "$cmd" =~ docker ]]; then
            echo "Docker command: $cmd"
        elif [[ "$cmd" =~ rm ]]; then
            echo "File Operation command: $cmd"
        elif [[ "$cmd" =~ "sudo" ]]; then
            echo "Admin command: $cmd"
        elif [[ "$cmd" =~ curl ]]; then
            echo "Network command: $cmd"
        elif [[ "$cmd" =~ "docker" ]]; then
            echo "Docker command: $cmd"
        else
            echo "General command: $cmd"
        fi
    done < "$HISTORY_FILE"
}

# Time-of-Day Analysis (to show command usage patterns over time)
analyze_time_of_day() {
    colorize "CYAN" "Analyzing time-of-day usage..."
    # Extract timestamps from history and create a file with the time of day
    awk '{print substr($0, 1, 10)}' "$HISTORY_FILE" | sort | uniq -c | sort -nr > "$TIME_OF_DAY_FILE"
    # Create the graph using gnuplot
    gnuplot -e "
        set title 'Command Frequency Over Time';
        set xlabel 'Time of Day';
        set ylabel 'Frequency';
        set output '/tmp/command_time_of_day.png';
        plot '$TIME_OF_DAY_FILE' using 1:2 with lines
    "
    colorize "CYAN" "Time-of-day analysis chart saved to /tmp/command_time_of_day.png"
}

# Main menu
menu() {
    PS3="Select an option: "
    select option in "Analyze History" "Generate Visualization" "Suggestions" "Filter by Date" "Group/Tag Commands" "Execution Statistics" "Clean History File" "Export Results" "Detect Frequent Combinations" "Send Alerts" "Process in Parallel" "Track Real-time Commands" "User-specific Analysis" "Categorize Commands" "Time-of-Day Analysis" "Exit"; do
        case $option in
            "Analyze History")
                PS3="Select an analysis option: "
                select sub_option in "Most Frequent Commands" "Commands Run with sudo" "Unique Commands" "Potentially Dangerous Commands" "Total Commands" "Back"; do
                    case $sub_option in
                        "Most Frequent Commands") show_frequent ;;
                        "Commands Run with sudo") show_sudo ;;
                        "Unique Commands") show_unique ;;
                        "Potentially Dangerous Commands") show_dangerous ;;
                        "Total Commands") show_total ;;
                        "Back") break ;;
                        *) echo "Invalid option!" ;;
                    esac
                done
                ;;
            "Generate Visualization") generate_visualization ;;
            "Suggestions") give_suggestions ;;
            "Filter by Date") filter_by_date ;;
            "Group/Tag Commands") group_and_tag_commands ;;
            "Execution Statistics") show_execution_stats ;;
            "Clean History File") clean_history_file ;;
            "Export Results") export_results ;;
            "Detect Frequent Combinations") detect_frequent_combinations ;;
            "Send Alerts") send_alerts ;;
            "Process in Parallel") process_in_parallel ;;
            "Track Real-time Commands") track_real_time_commands ;;
            "User-specific Analysis") user_specific_analysis ;;
            "Categorize Commands") categorize_command ;;
            "Time-of-Day Analysis") analyze_time_of_day ;;
            "Exit") exit 0 ;;
            *) echo "Invalid option!" ;;
        esac
    done
}

# Start menu
menu
