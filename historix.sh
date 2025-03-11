#!/bin/bash

# Source configuration and dependencies
source "$(dirname "$0")/config/config.sh"
source "$(dirname "$0")/config/dependencies.sh"

# Source core features
source "$(dirname "$0")/features/core_features.sh"

# Source advanced features
for feature in $(dirname "$0")/features/advanced/*.sh; do
    source "$feature"
done

# Main menu
display_ascii_art() {
    echo -e "\033[38;5;44m██╗  ██╗██╗███████╗████████╗ ██████╗ ██████╗ ██╗██╗  ██╗\033[0m"
    echo -e "\033[38;5;45m██║  ██║██║██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██║╚██╗██╔╝\033[0m"
    echo -e "\033[38;5;46m███████║██║███████╗   ██║   ██║   ██║██████╔╝██║ ╚███╔╝ \033[0m"
    echo -e "\033[38;5;47m██╔══██║██║╚════██║   ██║   ██║   ██║██╔══██╗██║ ██╔██╗ \033[0m"
    echo -e "\033[38;5;48m██║  ██║██║███████║   ██║   ╚██████╔╝██║  ██║██║██╔╝ ██╗\033[0m"
    echo -e "\033[38;5;49m╚═╝  ╚═╝╚═╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝\033[0m"
    echo ""
}

main_menu() {
    PS3="Select an option: "
    options=(
        "Most Frequent Commands"
        "Commands with sudo"
        "Unique Commands"
        "Dangerous Commands"
        "Total Commands"
        "Generate Visualization"
        "Filter by Date"
        "Group/Tag Commands"
        "Clean History File"
        "Export Results"
        "Execution Statistics"
        "Detect Combinations"
        "Send Alerts"
        "Process in Parallel"
        "Track Real-time Commands"
        "User-Specific Analysis"
        "Advanced: Machine Learning Trends"
        "Advanced: NLP Command Search"
        "Advanced: Anomaly Detection"
        "View Logs"
        "Clear Logs"
        "Exit"
    )
    select opt in "${options[@]}"; do
        case "$opt" in
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
            "Detect Combinations") detect_combinations ;;
            "Send Alerts") send_alerts ;;
            "Process in Parallel") process_parallel ;;
            "Track Real-time Commands") track_realtime ;;
            "User-Specific Analysis") user_specific_analysis ;;
            "Advanced: Machine Learning Trends") ml_trends ;;
            "Advanced: NLP Command Search") nlp_search ;;
            "Advanced: Anomaly Detection") detect_anomalies ;;
            "View Logs") view_logs ;;
            "Clear Logs") clear_logs ;;
            "Exit") exit 0 ;;
            *) log "WARNING" "Invalid menu selection" && colorize "RED" "Invalid option!" ;;
        esac
    done
}

# Error handling
trap 'log "ERROR" "Script exited with status $?"' ERR
trap 'log "INFO" "Script exited normally"' EXIT

# Startup
clear
display_ascii_art
check_dependencies
main_menu