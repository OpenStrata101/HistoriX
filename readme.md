# HistoriX - Command History Analyzer


**HistoriX** is a powerful tool designed to analyze and visualize Bash command history. It helps users gain insights into their shell usage patterns, detect frequent commands, and spot potential security risks, all while offering beautiful visualizations and detailed statistics.


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
- **GNUplot**: Required for generating command frequency and time-of-day visualizations.
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

# Usage
When you run **HistoriX**, you'll be presented with an interactive menu where you can choose from various options to analyze your command history. Below is an overview of the options:

#### Main Menu Options:

1.**Analyze History**: Analyze and display various statistics and command breakdowns.

- **Most Frequent Commands**: Shows the top 10 most frequently used commands.
- **Commands Run with sudo**: Displays all commands that were executed with `sudo`.
- **Unique Commands**: Lists unique commands executed in your shell.
- **Potentially Dangerous Commands**: Highlights risky commands (e.g., `rm -rf`).
- **Total Commands**: Displays the total number of commands in your history.

2.**Generate Visualization**: Creates graphical visualizations using GNUplot. Options include:

- **Frequency Chart**: Visualizes the most frequent commands.
- **Time-of-Day Usage**: Visualizes command usage patterns over time.

3.**Suggestions**: Provides recommendations based on your history (e.g., safer alternatives to risky commands).

4.**Filter by Date**: Filter command history based on a date range (e.g., last 24 hours, last week).

5.**Group/Tag Commands**: Categorize commands into groups for better analysis (e.g., `git`, `docker`).

6.**Execution Statistics**: View the execution time of commands.

7.**Clean History File**: Optionally clean up sensitive data (passwords, tokens) from your history file.

8.**Export Results**: Export your analysis results to CSV or JSON files.

9.**Detect Frequent Combinations**: Detect frequently run command combinations (e.g., git pull && git merge).

10.Send Alerts: Set up alerts based on command patterns (e.g., commands involving rm or sudo).

11.**Process in Parallel**: Use GNU Parallel to process your history file faster.

12.**Track Real-time Commands**: Enable real-time tracking of commands executed in the shell.

13.**User-Specific Analysis**: Analyze the command history for the current user.

14.**Categorize Commands**: Categorize commands based on simple patterns like Git, Docker, etc.

15.**Time-of-Day Analysis**: Analyze the frequency of commands executed at different times of the day.

16.**Exit**: Exit the program.

# Example Output
Here’s an example of what the output might look like when running **HistoriX**:

```bash
$ ./history_analyzer.sh

Select an option:
1) Analyze History
2) Generate Visualization
3) Suggestions
4) Filter by Date
5) Group/Tag Commands
6) Execution Statistics
7) Clean History File
8) Export Results
9) Detect Frequent Combinations
10) Send Alerts
11) Process in Parallel
12) Track Real-time Commands
13) User-specific Analysis
14) Categorize Commands
15) Time-of-Day Analysis
16) Exit
> 1

Select an analysis option:
1) Most Frequent Commands
2) Commands Run with sudo
3) Unique Commands
4) Potentially Dangerous Commands
5) Total Commands
> 1

Most Frequent Commands:
[35] git
[20] ls
[12] rm
[8] docker
[5] sudo
[3] cat
```

# Customizable Alerts

HistoriX allows you to set up alerts based on command patterns. For example, you can create an alert for any command that involves `sudo` or `rm -rf` by selecting the **Send Alerts** option.

**Example alert**:

```bash
Alert: Found command 'sudo rm -rf /'
```

# Visualizations
HistoriX can generate GNUplot visualizations for command usage. The following visualizations are available:

1.**Command Frequency Chart**: Displays the most used commands in a bar chart.

2.**Time-of-Day Usage**: Shows command execution patterns based on the time of day.
Visualizations are saved as PNG files in `/tmp` (or any other directory you specify).

# Command History Cleanup
The **Clean History File** option allows you to remove sensitive data (e.g., `passwords`, `tokens`) from your history file. This is useful if you want to maintain privacy or prevent sensitive information from appearing in your history.

# Exporting Results
You can export your analysis to CSV or JSON files. This is useful for long-term analysis or sharing with others.

**Example command**:

```bash
Exported to command_history.csv
```

# Contributing
We welcome contributions to **HistoriX**! If you have any ideas for new features or improvements, feel free to open an issue or create a pull request.

### How to Contribute:
1.**Fork the repository**.

2.**Clone your fork**:
```bash
git clone https://github.com/intrepidDev101/HistoriX.git
```

3.**Create a new branch for your feature**:
```bash
git checkout -b new-feature
```

4.**Make your changes and commit**:
```bash
git commit -m "Add feature X"
```

5.**Push to your fork**:
```bash
git push origin new-feature
```

6.**Open a pull request from your fork to the original repository**.

# License
**HistoriX** is licensed under the [MIT License](#LICENSE). Feel free to use, modify, and distribute it!

# Acknowledgments
- **GNUplot**: For generating beautiful visualizations.

- **GNU Parallel**: For multithreading and faster processing of large history files.

- **Bash**: For being the backbone of the terminal environment.

# Contact
For any questions or suggestions, feel free to reach out to the author at:
[fluxNest@protonmail.com](#ProtonMail)

