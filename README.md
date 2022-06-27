# simple-system-backup
simple-system-backup is an CLI application that provides functionality similar to the System Restore feature in Windows and the Time Machine tool in Mac OS.
It has minimum dependencies and includes only the necessary functionality.
Backups are taken using [rsync](http://rsync.samba.org/).

Backups are saved by default in the path /home/{user}/.backups. For best results the backups should be saved to an external (non-system) partition.

## Installation
```sh
wget https://github.com/vladkyiashko/simple-system-backup/blob/main/simple-system-backup.sh
```
or
```sh
curl https://github.com/vladkyiashko/simple-system-backup/blob/main/simple-system-backup.sh
```
Set executing permission
```sh
chmod +x simple-system-backup.sh
```

**Install "rsync" package using your package manager:**

Debian/Ubuntu
```sh
sudo apt install rsync
```
Arch Linux
```sh
sudo pacman -S rsync
```

## Usage
It is advised to use an external partion for backups. You can edit the path in the script
```sh
BACKUP_PATH=/home/$(logname)/.backups
```
to (using your correct path)
```sh
BACKUP_PATH=/mnt/630789e0-1fd4-4bf9-93c0-ee3dd0bf9a5a/backups
```

Feel free to add extra exclude directories in the script if needed
```sh
EXCLUDE_DIRS=("/dev/*" "/proc/*" "/sys/*" "/tmp/*" "/run/*" "/mnt/*" "/media/*" "/lost+found/*" "/home/*/.cache/*" "/var/lib/dhcpcd/*")
```

Create/update a system backup
```sh
sudo ./simple-system-backup.sh --create
```

Restore a system
```sh
sudo ./simple-system-backup.sh --restore
```

Create/update a system backup while keeping a previous version of backup
```sh
sudo ./simple-system-backup.sh --create-with-prev
```

Restore a system using a previous backup
```sh
sudo ./simple-system-backup.sh --restore-prev
```
