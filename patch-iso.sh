#!/usr/bin/env bash

set -e

GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo test)

ISO="${1}"
ISO_BASENAME=${ISO##*/}
CUSTOM_ISO=${ISO%/*}/${ISO_BASENAME%.iso}-patched_${GIT_COMMIT}.iso

OVERLAY_LOWER_DIR="original"
OVERLAY_UPPER_DIR="patches"
OVERLAY_WORK_DIR=".workdir"
OVERLAY_MERGE_DIR="result"

mount_base() {
  mkdir -pv ${OVERLAY_LOWER_DIR}
  mount -v ${ISO} ${OVERLAY_LOWER_DIR}

  mkdir -pv ${OVERLAY_MERGE_DIR}
  mkdir -pv ${OVERLAY_WORK_DIR}
  mount -t overlay overlay -o \
    lowerdir=${OVERLAY_LOWER_DIR},upperdir=${OVERLAY_UPPER_DIR},workdir=${OVERLAY_WORK_DIR} \
    ${OVERLAY_MERGE_DIR}
}

build_custom() {
  mkisofs -l -J -R \
    -o ${CUSTOM_ISO} \
    -b boot/syslinux/isolinux.bin -c boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot -eltorito-platform 0xEF \
    -eltorito-boot efi/boot/bootx64.efi -no-emul-boot \
    ${OVERLAY_MERGE_DIR}
  isohybrid --uefi ${CUSTOM_ISO}
}

umount_base() {
  umount -v ${OVERLAY_MERGE_DIR}
  rmdir -v ${OVERLAY_MERGE_DIR}
  umount -v ${OVERLAY_LOWER_DIR}
  rmdir -v ${OVERLAY_LOWER_DIR}
  rm -rf ${OVERLAY_WORK_DIR}
}

mount_base
build_custom
umount_base
