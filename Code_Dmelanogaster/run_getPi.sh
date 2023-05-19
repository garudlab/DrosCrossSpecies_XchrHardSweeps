#!/bin/bash
#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID
#$ -j y
## Edit the line below as needed:
#$ -l h_rt=100:00:00,h_data=5G,highp
## Modify the parallel environment
## and the number of cores as needed:
#$ -pe shared 1
# Notify when
#$ -m ea

echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "

# load the job environment:
. /u/local/Modules/default/init/modules.sh
module load anaconda3


#for popu in RA ZI; do
#for x in X 2R 2L 3R 3L; do
#  python popgen_stats_data.py 100 -i Variants_Chr${x}_${popu}_100.txt -o outPi/${popu}_Diversity_Chr${x}_100_50kb.txt -w 50
#done
#done

#low rec

for popu in ZI; do #RA ZI
for x in  3R 3L X; do #X 2R 2L 3R
  python popgen_stats_data.py 100 -i Variants_Chr${x}_${popu}_100.txt -o outPi/${popu}_Diversity_Chr${x}_100_20kb_Pi_TajD.txt -w 20
done
done


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
