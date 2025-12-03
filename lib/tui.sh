#!/bin/bash
RESET='\033[0m'
BOLD='\033[1m'
BLACK='\033[30m'
MAGENTA_BG='\033[45m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'

highlight() { echo -e "${MAGENTA_BG}${BLACK} $1 ${RESET}"; }
header() {
    clear
    echo -e "${BOLD}========================================${RESET}"
    echo -e "${BOLD}        Artix Bash Installer            ${RESET}"
    echo -e "${BOLD}========================================${RESET}"
    echo
}
prompt_continue() {
    echo
    read -rp "Pressione ENTER para continuar..." _
}
error() {
    echo -e "${GREEN}[ERRO]${RESET} $1"
}
