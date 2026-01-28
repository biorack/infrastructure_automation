#!/bin/bash

export PATH="/global/common/software/m2650/lftp/bin:$PATH"
export LD_LIBRARY_PATH="/global/common/software/m2650/lftp/lib:$LD_LIBRARY_PATH"

# Check if the password argument is provided
source /global/homes/m/msdata/gnps2/gnps2_bpbowen.txt
password=$MYVARIABLE

printf "INFO: Starting mirror of mzmine data\n"

# Define your local and remote directories
project_directory="$1"
local_directory="/global/cfs/cdirs/metatlas/projects/untargeted_tasks/$project_dir"
remote_directory="/untargeted_tasks/$project_dir"
remote_host="sftp.gnps2.org"
remote_port="443"
remote_user="bpbowen"

sftp -P "$remote_port" "$remote_user"@sftp.gnps2.org:"$remote_directory" <<< $"put -r $local_directory"

printf "INFO: Completed mirror of mzmine data\n"
