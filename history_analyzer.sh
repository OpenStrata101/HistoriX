#!/bin/bash

# HistoriX - Optimized Command History Analyzer
# Author: intrepidDev101
# Version: 1.1

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

# Helper: Analyze Command Frequency
analyze_frequency() {
    awk '{print $1}' "$HISTORY_FILE" | sort | uniq -c | sort -nr
}

# Helper: Display Top N Results
display_top_n() {
    local title="$1"
    local color="$2"
    local count="$3"
    colorize "$color" "$title"
    analyze_frequency | head -n "$count" | awk -v color="${COLORS[GREEN]}" '{printf "%s[%d] %s%s\n", color, $1, $2, "\033[0m"}'
    echo ""
}

# Most Frequent Commands
show_frequent() { display_top_n "Most Frequent Commands:" "CYAN" 10; }

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

# Dangerous Commands
show_dangerous() {
    colorize "CYAN" "Potentially Dangerous Commands:"
    grep -E 'rm|mv|dd|shutdown|reboot|mkfs' "$HISTORY_FILE" | sort | uniq | awk '{printf "%s%s%s\n", "\033[0;31m", $0, "\033[0m"}'
    echo ""
}

# Total Commands
show_total() {
    local total=$(wc -l < "$HISTORY_FILE")
    colorize "CYAN" "Total Commands Executed: $total"
    echo ""
}

# Generate Command Usage Visualization
generate_visualization() {
    analyze_frequency | head -n 10 | awk '{print $2, $1}' > "$TEMP_FILE"
    gnuplot -e "
        set terminal png size 800,600;
        set output '/tmp/command_usage.png';
        set title 'Top 10 Most Frequent Commands';
        set xlabel 'Command';
        set ylabel 'Frequency';
        set xtics rotate by -45;
        plot '/tmp/frequency_data.txt' using 2:xtic(1) with boxes notitle;
    "
    colorize "CYAN" "Visualization saved to /tmp/command_usage.png"
}

# Analyze Time-of-Day Usage
analyze_time_of_day() {
    awk '{print $1}' "$HISTORY_FILE" | sort | uniq -c > "$TIME_OF_DAY_FILE"
    gnuplot -e "
        set terminal png size 800,600;
        set output '/tmp/time_of_day.png';
        set title 'Command Usage by Time';
        set xlabel 'Time of Day';
        set ylabel 'Frequency';
        plot '/tmp/time_of_day.txt' using 1:2 with lines;
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
            colorize "RED" "Invalid format!"
            ;;
    esac
}

# Main Menu
menu() {
    PS3="Select an option: "
    select option in "Most Frequent Commands" "Commands with sudo" "Unique Commands" "Dangerous Commands" "Total Commands" "Generate Visualization" "Suggestions" "Export Results" "Time-of-Day Analysis" "Exit"; do
        case $option in
            "Most Frequent Commands") show_frequent ;;
            "Commands with sudo") show_sudo ;;
            "Unique Commands") show_unique ;;
            "Dangerous Commands") show_dangerous ;;
            "Total Commands") show_total ;;
            "Generate Visualization") generate_visualization ;;
            "Suggestions") give_suggestions ;;
            "Export Results") export_results ;;
            "Time-of-Day Analysis") analyze_time_of_day ;;
            "Exit") exit 0 ;;
            *) colorize "RED" "Invalid option!" ;;
        esac
    done
}

# Start menu
clear_terminal
display_ascii_art
menu
