#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/tui.sh"

menu_init() {
    while true; do
        header
        echo "Escolha o init system:"
        echo "1) runit"
        echo "2) openrc"
        echo "3) s6"
        echo "0) Voltar"
        printf "> "
        read -r op
        case $op in
            1) INIT_SYSTEM="runit"; echo "runit selecionado"; prompt_continue; return ;;
            2) INIT_SYSTEM="openrc"; echo "openrc selecionado"; prompt_continue; return ;;
            3) INIT_SYSTEM="s6"; echo "s6 selecionado"; prompt_continue; return ;;
            0) return ;;
            *) echo "Inválido"; sleep 1 ;;
        esac
    done
}
