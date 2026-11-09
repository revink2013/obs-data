#!/bin/sh

#---- Directory management ----
# The directory for running the scripts
cdir="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

# The directory this script is called from
last_dir="$(pwd)"

# Go to the required cwd
cd "$cdir" || (echo 'failed to enter the directory'; exit 1)

# Overwriting the actual notes folder can cause mistakes, so we create another copy. The user must manually overwrite/delete previous entries.
mkdir decrypted-data && # This will fail if this directory already exists

# Merge all files into a single encrypted file
cat data-out/data-part-* > encrypted.data &&

# Decrypt the data into a tar.xf file
openssl enc -d -a -aes-256-cbc -pbkdf2 -in=encrypted.data -out=archive.tar.xf -kfile=pass.key &&

# Decompress the archive to the directory
tar -xf archive.tar.xf -C decrypted-data &&

# Cleanup
rm archive.tar.xf encrypted.data

# Return to previous cwd
cd "$last_dir" || (echo 'failed to return to resumed directory'; exit 2)
