#!/bin/bash

################################ Slurm options #################################

### Job name
#SBATCH --job-name=k-slam
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err

### Limit run time "hours:minutes:seconds" (default: 365 days)

### Specify requirements - Task (default: 1 node, 1 Core, 12.5G mem/cpu)
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --mem-per-cpu=12000MB

################################################################################

# Useful information to print
echo '########################################'
echo 'Date:' $(date --iso-8601=seconds)
echo 'User:' $USER
echo 'Host:' $HOSTNAME
echo 'Job Name:' $SLURM_JOB_NAME
echo 'Job Id:' $SLURM_JOB_ID
echo 'Directory:' $(pwd)
# Detail Information:
scontrol show job $SLURM_JOB_ID
echo '########################################'

# modules loading
#module add python


# What you actually want to launch
singularity exec --bind /mnt/cbib/inextvir /mnt/cbib/inextvir/workspace/gregoruar/k-SLAM_2020-10-28/k-slam.sif    /mnt/cbib/inextvir/workspace/gregoruar/DB_script/k-slam_script

echo '########################################'
echo 'Job finished' $(date --iso-8601=seconds)
