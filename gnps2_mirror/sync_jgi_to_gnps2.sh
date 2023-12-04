#!/bin/bash

export PATH="/global/common/software/m2650/lftp/bin:$PATH"
export LD_LIBRARY_PATH="/global/common/software/m2650/lftp/lib:$LD_LIBRARY_PATH"

# Check if the password argument is provided
if [ "$#" -ne 1 ]; then
  source /global/homes/m/msdata/gnps2/gnps2_bpbowen.txt
  password=$MYVARIABLE
else
  password="$1"
fi

# Define your local and remote directories
local_directory="/global/cfs/cdirs/metatlas/raw_data/jgi"
remote_directory="/raw_data/jgi"
remote_host="sftp.gnps2.org"
remote_port="6542"
remote_user="bpbowen"

# Use lftp to synchronize the local and remote directories with the specified port
# Use find to locate only files with a ".raw" extension in the local directory
# Use find to locate only files with a ".raw" extension in the local directory
lftp -e "mirror --parallel=4 --include '/*.mzML' -R $local_directory $remote_directory; quit" -u "$remote_user,$password" sftp://$remote_host:$remote_port

# Explanation:
# -e: Execute the specified command(s) in lftp
# mirror -R: Mirror the local directory to the remote directory (recursively)
# -u: Provide the remote user and password
# :$remote_port: Specify the custom SFTP port
# quit: Quit lftp after the mirror operation is complete

# Now, you can provide the SFTP password as a command-line argument when running the script.

