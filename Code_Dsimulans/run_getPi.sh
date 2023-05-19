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

for x in 3L 3R X; do #X 2R 2L 3R 3L; do
  echo $x
  file_in=H12Files/FILTERED_simulans_170strains.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf.toH12_Chr${x}.txt
  file_out=outPi/D.simulans.RepeatsMasked.RemoveHighRepDens_0.2_20kb.vcf.toH12_Chr${x}_PI_TajD.txt
  
  python popgen_stats_data.py 170 -i ${file_in} -o ${file_out} -w 20

done


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "

