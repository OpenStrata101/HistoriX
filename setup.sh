#!/bin/bash

# Setup script for HistoriX
# chmod +x setup.sh && ./setup.sh

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Installation directory
INSTALL_DIR="/opt/historix"
BIN_PATH="/usr/local/bin/historix"

show_header() {
    cat << "EOF"
 _   _ _     _             ___   __  _____          _        _ _           
| | | (_)   | |           (_\ \ / / |_   _|        | |      | | |          
| |_| |_ ___| |_ ___  _ __ _ \ V /    | | _ __  ___| |_ __ _| | | ___ _ __ 
|  _  | / __| __/ _ \| '__| |/   \    | || '_ \/ __| __/ _` | | |/ _ \ '__|
| | | | \__ \ || (_) | |  | / /^\ \  _| || | | \__ \ || (_| | | |  __/ |   
\_| |_|_|___/\__\___/|_|  |_\/   \/  \___|_| |_|___/\__\__,_|_|_|\___|_|   
                                                                            
                                                                            
EOF
    echo -e "${YELLOW}HistoriX Setup Utility${NC}\n"
}

install() {
    echo -e "${GREEN}Starting installation...${NC}"
    
    # Check for sudo access
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${RED}Please run with sudo:${NC} sudo ./setup.sh"
        exit 1
    fi

    # Create installation directory
    echo -e "${YELLOW}Creating installation directory...${NC}"
    mkdir -p "$INSTALL_DIR" || {
        echo -e "${RED}Failed to create installation directory${NC}"
        exit 1
    }

    # Copy files and set permissions
    echo -e "${YELLOW}Copying files...${NC}"
    cp -r ./* "$INSTALL_DIR" || {
        echo -e "${RED}Copy failed${NC}"
        exit 1
    }
    
    find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod 755 {} \; || {
        echo -e "${RED}Permission setup failed${NC}"
        exit 1
    }

    # Create symlink
    echo -e "${YELLOW}Creating global command symlink...${NC}"
    ln -sf "$INSTALL_DIR/historix.sh" "$BIN_PATH" || {
        echo -e "${RED}Failed to create symlink${NC}"
        exit 1
    }

    echo -e "${GREEN}Installation complete!${NC}"
    echo -e "To use: ${YELLOW}historix${NC}"
    echo -e "Uninstall with: ${YELLOW}sudo ./setup.sh uninstall${NC}"
}

uninstall() {
    echo -e "${RED}Uninstalling HistoriX...${NC}"
    
    # Check for sudo access
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${RED}Please run with sudo:${NC} sudo ./setup.sh uninstall"
        exit 1
    fi

    # Remove symlink
    echo -e "${YELLOW}Removing global command symlink...${NC}"
    rm -f "$BIN_PATH" || {
        echo -e "${RED}Failed to remove symlink${NC}"
    }

    # Remove installation directory
    echo -e "${YELLOW}Removing installation directory...${NC}"
    rm -rf "$INSTALL_DIR" || {
        echo -e "${RED}Failed to remove installation directory${NC}"
    }

    echo -e "${GREEN}Uninstallation complete${NC}"
}

# Main execution
show_header

PS3="Select an option: "
options=("Install" "Uninstall" "Exit")
select opt in "${options[@]}"; do
    case $opt in
        "Install")
            install
            break
            ;;
        "Uninstall")
            uninstall
            break
            ;;
        "Exit")
            echo -e "${YELLOW}Exiting setup utility.${NC}"
            break
            ;;
        *) 
            echo -e "${RED}Invalid option${NC}"
            ;;
    esac
done