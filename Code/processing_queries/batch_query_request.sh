#!/bin/bash
#SBATCH --time=0:20:00
#SBATCH -p llab
#SBATCH -n 1
#SBATCH --mem=5000
#SBATCH --exclude=p1cmp[031]
#SBATCH --out=outfiles/%A.%a.out
#SBATCH --error=errfiles/%A.%a.err

module load use.own
module load R/4.0.0
module load java/1.8.0_60
module load gcc/7.3.0

#echo $SLURM_ARRAY_TASK_ID

Rscript batch_query.R $SLURM_ARRAY_TASK_ID $name
