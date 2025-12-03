#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/tui.sh"
source "$SCRIPT_DIR/menu_disk.sh"
source "$SCRIPT_DIR/menu_fs.sh"
source "$SCRIPT_DIR/menu_init.sh"
source "$SCRIPT_DIR/menu_config.sh"
source "$SCRIPT_DIR/install.sh"

menu_main() {
    while true; do
        header
        echo "1) Selecionar disco"
        echo "2) Selecionar filesystem"
        echo "3) Selecionar init system"
        echo "4) Configurações (hostname, user, timezone)"
        echo "5) Formatar & Instalar (automático)"
        echo "0) Sair"
        echo
        printf "> "
        read -r op
        case $op in
            1) menu_disk ;;
            2) menu_fs ;;
            3) menu_init ;;
            4) menu_config ;;
            5) install_system ;;
            0) clear; exit 0 ;;
            *) echo "Opção inválida"; sleep 1 ;;
        esac
    done
}
