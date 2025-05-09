#!/bin/bash

# IBM MQ Interactive Script
# This script connects to an IBM MQ server and allows for interactive command execution

# Color codes for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage information
display_usage() {
    echo -e "${BLUE}Usage:${NC} $0 [options]"
    echo
    echo "Options:"
    echo "  -h, --host HOSTNAME    MQ Server hostname (default: localhost)"
    echo "  -p, --port PORT        MQ Server port (default: 1414)"
    echo "  -q, --qmgr QMGR        Queue Manager name"
    echo "  -c, --channel CHANNEL  Server connection channel"
    echo "  -u, --user USERNAME    Username for authentication"
    echo "  -s, --secure           Use SSL/TLS connection"
    echo "  --help                 Display this help message"
    echo
}

# Default values
MQ_HOST="localhost"
MQ_PORT="1414"
MQ_QMGR=""
MQ_CHANNEL=""
MQ_USER=""
MQ_PASSWORD=""
USE_SSL=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--host)
            MQ_HOST="$2"
            shift 2
            ;;
        -p|--port)
            MQ_PORT="$2"
            shift 2
            ;;
        -q|--qmgr)
            MQ_QMGR="$2"
            shift 2
            ;;
        -c|--channel)
            MQ_CHANNEL="$2"
            shift 2
            ;;
        -u|--user)
            MQ_USER="$2"
            shift 2
            ;;
        -s|--secure)
            USE_SSL=true
            shift
            ;;
        --help)
            display_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Error:${NC} Unknown option: $1"
            display_usage
            exit 1
            ;;
    esac
done

# Check if required parameters are provided
if [[ -z "$MQ_QMGR" ]]; then
    echo -e "${RED}Error:${NC} Queue manager name is required."
    display_usage
    exit 1
fi

if [[ -z "$MQ_CHANNEL" ]]; then
    echo -e "${RED}Error:${NC} Server connection channel is required."
    display_usage
    exit 1
fi

# Prompt for password if username is provided but password isn't
if [[ -n "$MQ_USER" && -z "$MQ_PASSWORD" ]]; then
    read -s -p "Enter password for $MQ_USER: " MQ_PASSWORD
    echo
fi

# Function to check if required commands are available
check_requirements() {
    local missing_cmd=false
    
    # Check for runmqsc command
    if ! command -v runmqsc &> /dev/null; then
        echo -e "${RED}Error:${NC} 'runmqsc' command not found."
        echo "Please ensure IBM MQ client is installed and in your PATH."
        missing_cmd=true
    fi
    
    if [[ "$missing_cmd" = true ]]; then
        exit 1
    fi
}

# Function to test connection to the MQ server
test_connection() {
    echo -e "${YELLOW}Testing connection to MQ server...${NC}"
    
    local conn_string="DISPLAY QMGR" 
    local ssl_params=""
    
    if [[ "$USE_SSL" = true ]]; then
        ssl_params="-s"
    fi
    
    local auth_params=""
    if [[ -n "$MQ_USER" ]]; then
        auth_params="-u $MQ_USER"
        if [[ -n "$MQ_PASSWORD" ]]; then
            # In a production environment, consider using more secure methods
            # for password handling
            export MQPASSWORD="$MQ_PASSWORD"
            auth_params="$auth_params -p MQPASSWORD"
        fi
    fi

    # Attempt to connect and run a simple command
    echo "DISPLAY QMGR" | runmqsc -c $ssl_params $auth_params -h $MQ_HOST -p $MQ_PORT -m $MQ_QMGR -x $MQ_CHANNEL &> /tmp/mq_test_connection
    
    local result=$?
    if [[ $result -eq 0 ]]; then
        echo -e "${GREEN}Connection successful!${NC}"
        return 0
    else
        echo -e "${RED}Connection failed!${NC}"
        cat /tmp/mq_test_connection
        rm -f /tmp/mq_test_connection
        return 1
    fi
}

# Function to run interactive MQ commands
run_interactive_mode() {
    local ssl_params=""
    if [[ "$USE_SSL" = true ]]; then
        ssl_params="-s"
    fi
    
    local auth_params=""
    if [[ -n "$MQ_USER" ]]; then
        auth_params="-u $MQ_USER"
        if [[ -n "$MQ_PASSWORD" ]]; then
            export MQPASSWORD="$MQ_PASSWORD"
            auth_params="$auth_params -p MQPASSWORD"
        fi
    fi

    echo -e "${GREEN}Starting interactive MQ session...${NC}"
    echo -e "Type '${BLUE}EXIT${NC}' to quit the session."
    echo -e "Type '${BLUE}HELP${NC}' for available commands."
    echo

    while true; do
        echo -e "${BLUE}MQ> ${NC}\c"
        read -r command
        
        case "$command" in
            EXIT|exit)
                echo -e "${YELLOW}Exiting MQ session.${NC}"
                break
                ;;
            CLEAR|clear)
                clear
                ;;
            RECONNECT|reconnect)
                test_connection
                ;;
            *)
                echo "$command" | runmqsc -c $ssl_params $auth_params -h $MQ_HOST -p $MQ_PORT -m $MQ_QMGR -x $MQ_CHANNEL
                ;;
        esac
    done
}

# Function to display connection information
display_connection_info() {
    echo -e "${BLUE}==== MQ Connection Information ====${NC}"
    echo -e "Host:           ${YELLOW}$MQ_HOST${NC}"
    echo -e "Port:           ${YELLOW}$MQ_PORT${NC}"
    echo -e "Queue Manager:  ${YELLOW}$MQ_QMGR${NC}"
    echo -e "Channel:        ${YELLOW}$MQ_CHANNEL${NC}"
    
    if [[ -n "$MQ_USER" ]]; then
        echo -e "Username:       ${YELLOW}$MQ_USER${NC}"
    else
        echo -e "Authentication: ${YELLOW}None${NC}"
    fi
    
    if [[ "$USE_SSL" = true ]]; then
        echo -e "SSL/TLS:        ${YELLOW}Enabled${NC}"
    else
        echo -e "SSL/TLS:        ${YELLOW}Disabled${NC}"
    fi
    echo -e "${BLUE}=================================${NC}"
}

# Main execution
check_requirements

# Display connection information
display_connection_info

# Test connection
if test_connection; then
    # Start interactive mode
    run_interactive_mode
else
    echo -e "${RED}Unable to connect to the MQ server. Please check your connection parameters.${NC}"
    exit 1
fi

# Clean up any environment variables
unset MQPASSWORD

exit 0
