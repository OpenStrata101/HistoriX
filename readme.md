# HistoriX - Command History Analyzer


**HistoriX** is a powerful tool designed to analyze and visualize Bash command history. It helps users gain insights into their shell usage patterns, detect frequent commands, and spot potential security risks, all while offering beautiful visualizations and detailed statistics.

---

# Table of Contents
1.[Introduction](#HistoriX-CommandHistoryAnalyzer)

2.[Features](#Features)

3.[Installation](#Installation)
- 3.1 [Prerequisites](#Prerequisites)
- 3.2 [Installing Dependencies](#InstallingDependencies)
- 3.3 [Download and Setup](#DownloadandSetup)

4.[Usage](#Usage)
- 4.1 [Main Menu Options](#MainMenuOptions)

5.[Example Output](#ExampleOutput)

6.[Customizable Alerts](#CustomizableAlerts)

7.[Visualizations](#Visualizations)

8.[Command History Cleanup](#CommandHistoryCleanup)

9.[Exporting Results](#ExportingResults)

10.[Contributing](#Contributing)
- 10.1 [How to Contribute](#HowtoContribute)

11.[License](#License)

12.[Acknowledgments](#Acknowledgements)

13.[Contact](#Contact)


# Features
- **Command Categorization**: Classify commands based on usage (e.g., Git commands, file operations, Docker commands).
- **Most Frequent Commands**: Display the most commonly used commands with usage statistics.
- **Dangerous Commands Detection**: Highlight potentially dangerous commands (e.g., `rm -rf`, `shutdown`).
- **Date/Time Filtering**: Analyze command history based on specific date and time ranges (e.g., last 24 hours, last week).
- **Command Grouping and Tagging**: Organize commands into meaningful groups like Git, Docker, etc.
- **Execution Statistics**: Display execution time for commands.
- **Suggestions and Recommendations**: Get recommendations based on your command history.
- **Visualization**: Generate graphs of command usage over time and command frequency using **GNUplot**.
- **Customizable Alerts**: Set up alerts for commands that match specific patterns.
- **Frequent Command Combinations**: Detect frequently executed command combinations.
- **History File Cleanup**: Option to clean up sensitive data in your history file.
- **Exporting and Logging**: Export command analysis results to CSV/JSON files and log all actions.
- **Multithreading Support**: Use parallel processing for handling large history files.
- **Real-Time Command Tracking**: Track and log commands as they are executed in real-time.

# Installation
## Prerequisites
- **Bash**: This program is designed to work with the Bash shell.
- **GNUplot****: Required for generating command frequency and time-of-day visualizations.
- **GNU Parallel**: For parallel processing of command history (optional for multithreading).
## Installing Dependencies
To install the required dependencies, use the following commands:

**On Ubuntu/Debian-based systems:**
```bash
sudo apt update
sudo apt install gnuplot parallel
```

**On Fedora/RHEL-based systems:**
```bash
sudo dnf install gnuplot parallel
```

**On Archlinux-based systems:**
```bash
sudo pacman -S gnuplot parallel
```

# Download and Setup
1.**Clone the repository or download the script manually**.

```bash
git clone https://github.com/intrepidDev101/HistoriX.git
cd HistoriX
```

2.**Make the script executable**:

```bash
chmod +x history_analyzer.sh
```

3.**Run the script**:

```bash
./history_analyzer.sh
```