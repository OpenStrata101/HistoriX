# **HistoriX v3.0 (Alpha)** - Advanced Command History Analyzer

![Version](https://img.shields.io/badge/version-3.0--alpha-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Dependencies](https://img.shields.io/badge/dependencies-up%20to%20date-yellowgreen)
![Contributors](https://img.shields.io/badge/contributors-welcome-orange)

**HistoriX v3.0 (Alpha)** is a next-generation command-line tool designed to analyze, visualize, and optimize your shell command history. Whether you're a casual user or a power user, HistoriX provides deep insights into your command usage patterns, detects anomalies, and helps you streamline your workflow with advanced features like machine learning and natural language processing.

---

## **Table of Contents**
1. [Overview](#overview)
2. [Features](#features)
   - [Core Features](#core-features)
   - [Advanced Features](#advanced-features)
3. [Installation](#installation)
   - [Prerequisites](#prerequisites)
   - [Setup Script](#setup-script)
   - [Global Command](#global-command)
4. [Usage](#usage)
   - [Launching the Program](#launching-the-program)
   - [Interactive Menu](#interactive-menu)
   - [Example Commands](#example-commands)
5. [Configuration](#configuration)
   - [Configuration File](#configuration-file)
   - [Customizing Colors](#customizing-colors)
6. [Advanced Features](#advanced-features)
   - [Machine Learning Trends](#machine-learning-trends)
   - [Natural Language Queries](#natural-language-queries)
   - [Anomaly Detection](#anomaly-detection)
7. [Logging and Monitoring](#logging-and-monitoring)
   - [Log Files](#log-files)
   - [View Logs](#view-logs)
   - [Clear Logs](#clear-logs)
8. [Troubleshooting](#troubleshooting)
   - [Common Issues](#common-issues)
   - [Debugging](#debugging)
9. [Contributing](#contributing)
   - [How to Contribute](#how-to-contribute)
   - [Code Style Guidelines](#code-style-guidelines)
10. [License](#license)
11. [Acknowledgments](#acknowledgments)

---

## **Overview**

**HistoriX v3.0 (Alpha)** is a CLI-based tool that transforms your shell command history into actionable insights. It supports multiple shells (Bash, Zsh, Fish), integrates with advanced technologies like machine learning and natural language processing, and provides real-time monitoring capabilities. The program is modular, extensible, and designed for both casual users and system administrators.

---

## **Features**

### **Core Features**

#### **Most Frequent Commands**
- Analyze and display the most frequently used commands.
- Example: Identify which commands you use daily to optimize your workflow.

#### **Commands with `sudo`**
- List all commands executed with elevated privileges.
- Example: Detect unauthorized or unnecessary use of `sudo`.

#### **Unique Commands**
- Identify unique commands in your history.
- Example: Discover new tools or commands you’ve started using.

#### **Dangerous Commands**
- Detect potentially harmful commands (e.g., `rm`, `shutdown`, `dd`).
- Example: Prevent accidental data loss by identifying risky commands.

#### **Total Commands**
- Count the total number of commands executed.
- Example: Track your productivity over time.

#### **Generate Visualization**
- Create bar charts and visualizations using GNUplot.
- Example: Visualize your top 10 commands in a bar chart.

#### **Filter by Date**
- Filter commands by a specific date range.
- Example: Analyze commands executed during a project timeline.

#### **Group/Tag Commands**
- Group commands by patterns (e.g., `git`, `docker`, `python`).
- Example: Organize your history into categories for better analysis.

#### **Clean History File**
- Remove sensitive data (e.g., passwords, tokens) from your history.
- Example: Ensure compliance with security policies.

#### **Export Results**
- Export analysis results to CSV or JSON format.
- Example: Share your findings with teammates or import them into other tools.

#### **Execution Statistics**
- Analyze time intervals between consecutive commands.
- Example: Identify inefficiencies in your workflow.

#### **Detect Combinations**
- Identify frequently used command combinations.
- Example: Discover patterns like `git add` followed by `git commit`.

#### **Send Alerts**
- Monitor for dangerous commands and send alerts via email.
- Example: Receive notifications when someone runs `rm -rf`.

#### **Process in Parallel**
- Process commands in parallel for faster analysis.
- Example: Speed up large-scale history analysis.

#### **Track Real-Time Commands**
- Monitor commands in real-time as they are executed.
- Example: Debug issues by observing live command activity.

#### **User-Specific Analysis**
- Analyze commands specific to the current user.
- Example: Compare usage patterns across multiple users on shared systems.

---

### **Advanced Features**

#### **Machine Learning Trends**
- Use machine learning to identify trends in command usage.
- Example: Predict future commands based on historical patterns.

#### **Natural Language Queries**
- Search your history using natural language queries.
- Example: "Show me commands I ran last week."

#### **Anomaly Detection**
- Detect unusual command patterns, such as spikes in activity or rare commands.
- Example: Flag potential security breaches or misconfigurations.

---

## **Installation**

### **Prerequisites**
- **Bash**: Version 4.0 or higher.
- **GNU Coreutils**: Tools like `awk`, `grep`, `sed`, etc.
- **Python**: Version 3.8 or higher (for ML/NLP features).
- **GNUplot**: For generating visualizations.
- **GNU Parallel**: For parallel processing.
- **Mailutils**: For sending email alerts.

Install dependencies using your package manager:
```bash
sudo apt install gnuplot parallel mailutils python3 python3-pip
pip3 install pandas scikit-learn nltk
```

## **Setup Script**
**1.Clone the repository:**
```bash
git clone https://github.com/your-repo/historix.git
cd historix
```
**2.Make the setup script executable:**
```bash
chmod +x setup.sh
```
**3.Run the setup script:**
```bash
sudo ./setup.sh
```
**4.Follow the prompts to install or uninstall the program globally.**

## **Global Command**
After installation, you can run HistoriX globally using:
```bash
historix
```

## **Usage**
**Launching the Program**

**Run the program using:**

```bash
historix
```

You will be presented with an interactive menu where you can select various options.

## **Interactive Menu**
The menu includes all core and advanced features. Use arrow keys or numbers to navigate.

Example Commands
- View the most frequent commands:
```bash
historix --> Select "Most Frequent Commands"
```
- Generate a visualization:
```bash
historix --> Select "Generate Visualization"
```
- Clean sensitive data from history:
```bash
historix --> Select "Clean History File"
```

## **Configuration**
**Configuration File**


**The main configuration file is located at `config/config.sh`. You can customize the following settings:**

- **History File** : Set the path to your shell history file (default: `~/.bash_history`).
- **Log Directory** : Specify the directory for logs (default: `~/.historix/logs`).
- **Log Level** : Choose the verbosity of logs (`DEBUG`, `INFO`, `WARNING`, `ERROR`).
- **Log Retention** : Define how long logs are retained (default: 30 days).

## **Customizing Colors**
Colors for output messages are defined in `config/config.sh`. Modify the `COLORS` associative array to change the color scheme:

```bash
declare -A COLORS=(
    ["RED"]="\033[0;31m"
    ["GREEN"]="\033[0;32m"
    ["YELLOW"]="\033[1;33m"
    ["CYAN"]="\033[0;36m"
    ["MAGENTA"]="\033[0;35m"
    ["RESET"]="\033[0m"
)
```

## **Advanced Features**
**Machine Learning Trends**

This feature analyzes your command history to identify usage patterns and trends. It requires Python 3.8+ and libraries like `pandas` and `scikit-learn`.

To use:

```bash
historix --> Select "Advanced: Machine Learning Trends"
```

**Natural Language Queries**

Search your history using natural language queries. For example:

- "Show me commands I ran last week."
- "Find docker commands used today."

To use:

```bash
historix --> Select "Advanced: NLP Command Search"
```

**Anomaly Detection**

Detect unusual command patterns, such as spikes in activity or rare commands. This feature uses statistical analysis to flag anomalies.

To use:

```bash
historix --> Select "Advanced: Anomaly Detection"
```

## **Logging and Monitoring**
**Log Files**

All logs are stored in `~/.historix/logs/historix.log`. Logs are rotated automatically when they exceed 10MB, and old logs are archived for 30 days.

**View Logs**

You can view logs directly from the menu:

```bash
historix --> Select "View Logs"
```

**Clear Logs**

To clear logs:

```bash
historix --> Select "Clear Logs"
```

## **Troubleshooting**
**Common Issues**

**1.Error**: `log: command not found`

- Ensure that `config/config.sh` is sourced in all scripts.
- Verify that the `log` function is defined in `config/config.sh`.

**2.Missing Dependencies**

- Install missing dependencies using your package manager:
```bash
sudo apt install gnuplot parallel mailutils python3
```

**3.Permission Denied**

- Run the script with `sudo` if required:
```bash
sudo ./setup.sh
```

## **Debugging**

Enable debug logging by setting `LOG_LEVEL="DEBUG"` in `config/config.sh`. This will provide detailed information about each operation.

## **Contributing**

We welcome contributions to improve HistoriX! To contribute:

**1.Fork the repository.**

**2.Create a new branch:**
```bash
git checkout -b feature/new-feature
```

**3.Commit your changes:**
```bash
git commit -m "Add new feature"
```

**4.Push to your fork:**
```bash
git push origin feature/new-feature
```

**5.Submit a pull request.**

## **Code Style Guidelines**
- Use consistent indentation (4 spaces).
- Write descriptive comments for functions and complex logic.
- Follow Bash best practices (e.g., quote variables, avoid global variables).

## **License**
This project is licensed under the MIT License . See the [LICENSE](LICENSE) file for details.


## **Acknowledgments**
Inspired by tools like `history` and `htop`.
Built with ❤️ by Openstrata101 .
