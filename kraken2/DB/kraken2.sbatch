#!/bin/bash

################################ Slurm options #################################

### Job name
#SBATCH --job-name=kraken2db
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err

### Limit run time "hours:minutes:seconds" (default: 365 days)

### Specify requirements - Task (default: 1 node, 1 Core, 12.5G mem/cpu)
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=32000MB

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
singularity exec /mnt/cbib/inextvir/workspace/jrollin/doing_installation/kraken2_2020_10_29 /mnt/cbib/inextvir/workspace/jrollin/DB_script/kraken2_script

echo '########################################'
echo 'Job finished' $(date --iso-8601=seconds)
