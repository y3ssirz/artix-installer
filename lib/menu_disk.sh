#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/tui.sh"
source "$SCRIPT_DIR/disk.sh"

menu_disk() {
    while true; do
        header
        echo "Discos disponíveis:"
        lsblk -dpno NAME,SIZE,MODEL | nl -w2 -s'. '
        echo
        echo "1) Selecionar disco manualmente"
        echo "0) Voltar"
        printf "> "
        read -r op
        case $op in
            1) select_disk; prompt_continue ;;
            0) return ;;
            *) echo "Inválido"; sleep 1 ;;
        esac
    done
}
