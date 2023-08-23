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

for species in teissieri mauritiana sechellia santomea; do #mauritiana sechellia santomea
echo $species
for x in X 2R 2L 3R 3L; do #X 2R 2L 3R 3L
  file_in=H12Files/D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf.toH12_wild_Chr${x}.txt
  file_out=outPi/D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.RemoveHighRepDens_0.2_20kb.vcf.toH12_wild_Chr${x}_PI_TajD.txt
  
  #sort -nk1 -t',' ${file_in} > ${file_in}_sorted
  
  sampleSize=$(cat ${file_in} | awk -F "," '{print NF-1}'  | head -1)
  echo $sampleSize

  python popgen_stats_data.py ${sampleSize} -i ${file_in} -o ${file_out} -w 20

done
done

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "

