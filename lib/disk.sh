#!/bin/bash
# disk utility functions

select_disk() {
    echo -n "Digite o caminho do disco (ex: /dev/sda): "
    read -r d
    if [[ ! -b "$d" ]]; then
        echo "Dispositivo inválido: $d"
        return 1
    fi
    DISK_SELECTED="$d"
    echo "Disco selecionado: $DISK_SELECTED"
}

auto_partition_gpt_efi_root() {
    # Creates GPT, EFI partition (300M) and root partition for the rest
    echo "Limpeza do disco: $DISK_SELECTED"
    read -rp "Isto irá apagar TODO o disco $DISK_SELECTED. Continuar? (y/N): " yn
    [[ "$yn" != "y" ]] && { echo "Abortando"; return 1; }

    wipefs -a "$DISK_SELECTED" || true
    sgdisk --zap-all "$DISK_SELECTED" || true
    parted -s "$DISK_SELECTED" mklabel gpt
    parted -s "$DISK_SELECTED" mkpart primary 1MiB 301MiB
    parted -s "$DISK_SELECTED" set 1 esp on
    parted -s "$DISK_SELECTED" mkpart primary 301MiB 100%
    # Partition names
    if [[ "$DISK_SELECTED" =~ [0-9]$ ]]; then
        EFI_PART="${DISK_SELECTED}1"
        ROOT_PART="${DISK_SELECTED}2"
    else
        EFI_PART="${DISK_SELECTED}p1"
        ROOT_PART="${DISK_SELECTED}p2"
    fi
    echo "EFI: $EFI_PART"
    echo "ROOT: $ROOT_PART"
}
