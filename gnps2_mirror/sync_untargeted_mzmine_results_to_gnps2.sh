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

printf "INFO: Starting mirror of mzmine data\n"

# Define your local and remote directories
local_directory="/global/cfs/cdirs/metatlas/projects/untargeted_tasks"
remote_directory="/untargeted_tasks"
remote_host="sftp.gnps2.org"
remote_port="443"
remote_user="bpbowen"

for file_type in "csv" "tab" "mgf"; do
lftp -e "mirror --parallel=4 --include '/*.$file_type' -R $local_directory $remote_directory; quit" -u "$remote_user,$password" sftp://"$remote_host:$remote_port"
done

printf "INFO: Completed mirror of mzmine data\n"
