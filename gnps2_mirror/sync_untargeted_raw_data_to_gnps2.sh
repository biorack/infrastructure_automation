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

printf "INFO: Starting mirror of raw data\n"

# Define your local and remote directories
for department in "jgi" "egsb"; do
local_directory="/global/cfs/cdirs/metatlas/raw_data/$department"
remote_directory="/raw_data/$department"
remote_host="sftp.gnps2.org"
remote_port="443"
remote_user="bpbowen"
lftp -e "mirror --parallel=4 --include '/*.mzML' -R $local_directory $remote_directory; quit" -u "$remote_user,$password" sftp://"$remote_host:$remote_port"
done

printf "INFO: Completed mirror of raw data\n"
