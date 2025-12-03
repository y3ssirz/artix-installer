#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/tui.sh"

menu_config() {
    while true; do
        header
        echo "Configurações do sistema:"
        echo "1) Definir hostname (atualmente: ${HOSTNAME:-<não definido>})"
        echo "2) Criar usuário (atualmente: ${USERNAME:-<não definido>})"
        echo "3) Definir senha do usuário/root"
        echo "4) Definir timezone (atualmente: ${TIMEZONE:-<não definido>})"
        echo "0) Voltar"
        printf "> "
        read -r op
        case $op in
            1) read -rp "Hostname: " HOSTNAME ;;
            2) read -rp "Nome do usuário: " USERNAME ;;
            3) read -rsp "Senha: " PASSWORD; echo ;; 
            4) read -rp "Timezone (ex: America/Sao_Paulo): " TIMEZONE ;;
            0) return ;;
            *) echo "Inválido"; sleep 1 ;;
        esac
    done
}
