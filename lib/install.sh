#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/tui.sh"
source "$SCRIPT_DIR/disk.sh"

install_system() {
    header
    echo "Verificando configurações..."
    missing=0
    [[ -z "${DISK_SELECTED:-}" ]] && echo "[ERRO] Disco não selecionado" && missing=1
    [[ -z "${FS_TYPE:-}" ]] && echo "[ERRO] Filesystem não selecionado" && missing=1
    [[ -z "${INIT_SYSTEM:-}" ]] && echo "[ERRO] Init system não selecionado" && missing=1
    [[ -z "${HOSTNAME:-}" ]] && echo "[ERRO] Hostname ausente" && missing=1
    [[ -z "${USERNAME:-}" ]] && echo "[ERRO] Usuário ausente" && missing=1
    [[ -z "${PASSWORD:-}" ]] && echo "[ERRO] Senha ausente" && missing=1
    [[ -z "${TIMEZONE:-}" ]] && echo "[ERRO] Timezone ausente" && missing=1

    if [[ $missing -eq 1 ]]; then
        echo
        echo "1) Voltar ao menu principal"
        echo "0) Sair"
        read -rp "> " op
        [[ "$op" == "1" ]] && return
        exit 1
    fi

    # Particionamento e formatação
    auto_partition_gpt_efi_root

    echo "Formatando EFI ($EFI_PART) -> FAT32"
    mkfs.fat -F32 "$EFI_PART"

    echo "Formatando root ($ROOT_PART) -> $FS_TYPE"
    case "$FS_TYPE" in
        btrfs)
            mkfs.btrfs -f "$ROOT_PART"
            ;;
        ext4)
            mkfs.ext4 -F "$ROOT_PART"
            ;;
        xfs)
            mkfs.xfs -f "$ROOT_PART"
            ;;
    esac

    echo "Montando sistema em /mnt"
    mount "$ROOT_PART" /mnt
    mkdir -p /mnt/boot
    mount "$EFI_PART" /mnt/boot

    if [[ "$FS_TYPE" == "btrfs" ]]; then
        echo "Criando subvolumes btrfs (/@ /@home)"
        umount /mnt || true
        mount -o subvolid=5 "$ROOT_PART" /mnt
        btrfs subvolume create /mnt/@
        btrfs subvolume create /mnt/@home
        umount /mnt
        mount -o subvol=@ "$ROOT_PART" /mnt
        mkdir -p /mnt/home
        mount -o subvol=@home "$ROOT_PART" /mnt/home
        mkdir -p /mnt/boot
        mount "$EFI_PART" /mnt/boot
    fi

    echo "Instalando base com basestrap..."
    # basestrap is Artix tool
    basestrap /mnt base base-devel linux linux-headers

    echo "Gerando fstab..."
    fstabgen -U /mnt >> /mnt/etc/fstab

    echo "Configurando hostname, timezone e locale..."
    echo "$HOSTNAME" > /mnt/etc/hostname
    mkdir -p /mnt/etc
    echo "$TIMEZONE" > /mnt/etc/timezone

    echo "Criando usuário e senha no chroot..."
    artix-chroot /mnt /bin/bash -c "useradd -m -G wheel $USERNAME || true"
    echo "$USERNAME:$PASSWORD" | chpasswd --root /mnt
    echo "root:$PASSWORD" | chpasswd --root /mnt

    echo "Instalando init system packages..."
    case "$INIT_SYSTEM" in
        runit) basestrap /mnt runit-openrc || true ;;
        openrc) basestrap /mnt openrc || true ;;
        s6) basestrap /mnt s6 || true ;;
    esac

    echo "Instalação finalizada (placeholder). Veja /mnt para sistema instalado."
    prompt_continue
}
