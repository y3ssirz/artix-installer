#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/tui.sh"

menu_fs() {
    while true; do
        header
        echo "Escolha o filesystem para a partição root:"
        echo "1) btrfs (recomendado para subvolumes)"
        echo "2) ext4"
        echo "3) xfs"
        echo "0) Voltar"
        printf "> "
        read -r op
        case $op in
            1) FS_TYPE="btrfs"; echo "btrfs selecionado"; prompt_continue; return ;;
            2) FS_TYPE="ext4"; echo "ext4 selecionado"; prompt_continue; return ;;
            3) FS_TYPE="xfs"; echo "xfs selecionado"; prompt_continue; return ;;
            0) return ;;
            *) echo "Inválido"; sleep 1 ;;
        esac
    done
}
