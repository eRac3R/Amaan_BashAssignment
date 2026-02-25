#!/bin/bash

# keep showing menu until user types 8
while true; do
echo ""
echo "FILE & DIRECTORY MANAGER"
echo "1. List files"
echo "2. Create directory"
echo "3. Create file"
echo "4. Delete file"
echo "5. Rename file"
echo "6. Search file"
echo "7. Count files and dirs"
echo "8. Exit"
echo ""
read -p "choice: " ch

# check what the user picked
case $ch in
1)

# show all files with their sizes
ls -lh
;;
2)
read -p "dir name: " d

# dont create if it already exists
if [ -d "$d" ]; then
echo "already exists"
else
mkdir "$d"
echo "done"
fi
;;

3)
read -p "file name: " f

# dont create if file already exists
if [ -f "$f" ]; then
echo "already exists"
else
touch "$f"
echo "file created"
fi
;;

4)
read -p "file to delete: " f
# check if file is there first
if [ ! -f "$f" ]; then
echo "not found"
else

# ask before deleting just to be safe
read -p "you sure? y/n: " yn
if [ "$yn" == "y" ]; then
rm "$f"
echo "deleted"
else
echo "ok cancelled"
fi
fi
;;

5)
read -p "old name: " o
read -p "new name: " n

# cant rename something that doesnt exist
if [ ! -f "$o" ]; then
echo "file not found"
else
mv "$o" "$n"
echo "renamed"
fi
;;

6)
read -p "search for: " s

# search from current directory
find . -name "$s"
;;

7)
# count files and folders separately
f=$(find . -maxdepth 1 -type f | wc -l)
d=$(find . -maxdepth 1 -type d | wc -l)

# minus 1 because find includes the current dir itself
d=$((d-1))
echo "files: $f"
echo "dirs: $d"
;;

8)
echo "bye"
break
;;
*)
echo "wrong choice"
;;
esac
done
