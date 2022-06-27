#!/bin/bash

BACKUP_PATH=/home/$(logname)/.backups
EXCLUDE_DIRS=("/dev/*" "/proc/*" "/sys/*" "/tmp/*" "/run/*" "/mnt/*" "/media/*" "/lost+found/*" "/home/*/.cache/*" "/var/lib/dhcpcd/*")
CURRENT_DIR=backup
PREV_DIR=prev_backup

check_create_backup_dirs() {
	dirs=($BACKUP_PATH/$CURRENT_DIR $BACKUP_PATH/$PREV_DIR)
	for dir in ${dirs[@]}; do
		if [ ! -d $dir ]; then
			echo "mkdir $dir"
			if ! mkdir -p $dir; then
				echo "can't create folder at path $dir; exit"
				exit 0
			fi
		fi
	done
}

confirm() {
	while true; do
		read -p "$1" yn
		case $yn in
			[yY]) break;;
			[nN]) exit 1;;
		esac
	done
}

do_rsync() {
	dirs=($1 $2)
	for dir in ${dirs[@]}; do
		if [ ! -d $dir ]; then
			echo "No folder at path $dir; exit"
			exit 0
		fi
	done

	EXCLUDE_ARG=(--exclude="$BACKUP_PATH/*")
	for path in "${EXCLUDE_DIRS[@]}"; do
		EXCLUDE_ARG+=(--exclude="$path")
	done
	#EXCLUDE_ARG+=(--exclude="$BACKUP_PATH/*")
	
	rsync -aAXH --info=progress2 --delete "${EXCLUDE_ARG[@]}" $1/* $2
}

case "$1" in
	"--create")
		check_create_backup_dirs
		confirm "Create backup? (y/n) " 
		do_rsync / $BACKUP_PATH/$CURRENT_DIR
		exit 1;;
	"--create-with-prev")
		check_create_backup_dirs
		confirm "Create backup? (y/n) " 
		if [ "$(ls -A $BACKUP_PATH/$CURRENT_DIR)" ]; then
			do_rsync $BACKUP_PATH/$CURRENT_DIR $BACKUP_PATH/$PREV_DIR
		fi
		do_rsync / $BACKUP_PATH/$CURRENT_DIR
		exit 1;;
	"--restore")
		confirm "Restore backup? (y/n) " 
		do_rsync $BACKUP_PATH/$CURRENT_DIR /
		exit 1;;
	"--restore-prev")
		confirm "Restore previous backup? (y/n) " 
		do_rsync $BACKUP_PATH/$PREV_DIR /
		exit 1;;
	*)
		echo "Invalid argument; try '--create' or '--create-with-prev' or '--restore' or '--restore-prev'"
		exit 0;;
esac
