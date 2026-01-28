import os
import sys
import paramiko
import logging

def mirror_mzmine_results_to_gnps2(project: str, polarity: str, username="bpbowen"):

    # Load password from file
    with open('/global/homes/m/msdata/gnps2/gnps2_bpbowen.txt', 'r') as f:
        for line in f:
            if line.startswith('MYVARIABLE='):
                password = line.strip().split('=')[1].replace('"', '')
                break

    if not password:
        logging.error(print("Password is required to mirror data to GNPS2. Exiting", 3))
        sys.exit(1)
    
    logging.info(print("Mirroring MZmine results for %s to GNPS2...", 3))

    project_directory = f"{project}_{polarity}"
    local_directory = f"/global/cfs/cdirs/metatlas/projects/untargeted_tasks/{project_directory}"
    remote_directory = f"/untargeted_tasks/{project_directory}"
    remote_host = "sftp.gnps2.org"
    remote_port = 443
    remote_user = username

    transport = paramiko.Transport((remote_host, remote_port))
    transport.connect(username=remote_user, password=password)
    sftp = paramiko.SFTPClient.from_transport(transport)
    try:
        sftp.mkdir(remote_directory)
    except IOError:
        logging.info(print(f"Directory {remote_directory} already exists on GNPS2", 4))
        pass
    try:
        for root, dirs, files in os.walk(local_directory):
            for file in files:
                if file.endswith(('.mgf', '.csv', '.tab')):
                    local_path = os.path.join(root, file)
                    remote_path = os.path.join(remote_directory, file)
                    sftp.put(local_path, remote_path)
                    logging.info(print(f"Uploaded {file} to GNPS2...", 4))
        sftp.close()
        transport.close()
        logging.info(print(f"Completed mirror to GNPS2 for {project}...", 3))
    except:
        logging.error(print(f"Failed to mirror MZmine results for {project} to GNPS2", 3))
        sys.exit(1)

mirror_mzmine_results_to_gnps2("20240911_EB_YZ_107432-001_CRISPR4and6_20240715_EXP120A_C18-EP_USDAY91016", "positive")
