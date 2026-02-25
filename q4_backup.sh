#!/bin/bash

# q4 backup script - amaan

echo " BACKUP SCRIPT "

# ask what to backup
read -p "folder to backup: " src

# check folder exists
if [ ! -d "$src" ]; then
echo "folder not found"
exit 1
fi

# ask where to save it
read -p "save backup to: " dest

# create dest folder if not there
if [ ! -d "$dest" ]; then
mkdir -p "$dest"
fi

# ask backup type
echo ""
echo "1. Simple copy"
echo "2. Compressed (tar.gz)"
read -p "choice: " btype

# make timestamp so each backup has unique name
ts=$(date +%Y%m%d_%H%M%S)

# start counting time
start=$(date +%s)

echo "starting backup..."

if [ "$btype" == "1" ]; then
# just copy the folder
cp -r "$src" "$dest/backup_$ts"
bpath="$dest/backup_$ts"
else
# compress it
tar -czf "$dest/backup_$ts.tar.gz" "$src"
bpath="$dest/backup_$ts.tar.gz"
fi

# stop timer
end=$(date +%s)
dur=$((end - start))

# check if backup file was created
if [ -e "$bpath" ]; then
echo "backup done!"
echo "file: $(basename $bpath)"
echo "location: $dest"
echo "size: $(du -sh $bpath | cut -f1)"
echo "time: $dur seconds"
else
echo "backup failed"
fi
