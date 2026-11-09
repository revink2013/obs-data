#!/bin/sh

#---- Directory management ----
# The directory for running the scripts
cdir="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

# The parent directory containing the notes
pdir="$(dirname $cdir)"

# The directory this script is called from
last_dir="$(pwd)"

# Go to the required cwd
cd "$cdir" || (echo 'failed to enter the directory'; exit 1)

#---- Convertion ----
# Compress all notes into a single archive, in a specific order
tar -cf archive.tar.xf $(find $pdir/notes -type f | sort) || echo "failed to compress the files"

# Encrypt the archive
openssl enc -e -a -aes-256-cbc -pbkdf2 -in=archive.tar.xf -out=encrypted.data -kfile=pass.key &&

# Split this large archive into file
mkdir -p data-out && rm -f data-out/* &&
split -b 256K encrypted.data data-out/data-part- &&

#---- Cleanup ----
rm archive.tar.xf encrypted.data

# Return to previous cwd
cd "$last_dir" || (echo 'failed to return to resumed directory'; exit 2)
