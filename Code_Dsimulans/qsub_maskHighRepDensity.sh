#!/bin/bash                        

#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID.$TASK_ID
#$ -j y
## Edit the line below as needed:
#$ -l h_rt=24:00:00,h_data=3G
## Modify the parallel environment
## and the number of cores as needed:
#$ -pe shared 1
# Notify when
#$ -m bea
#  Job array indexes
#$ -t 1-1:1

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "

# load the job environment:
. /u/local/Modules/default/init/modules.sh
module load htslib bcftools bedtools

file=FILTERED_simulans_multisamp_170strains_subset_CHR.RepeatsMasked.vcf.gz
#file=FILTERED_simulans_multisamp_170strains.RepeatsMasked.vcf.gz

bedtools subtract -a ${file} -b  ../Reference/RepeatMasker/Dsim0.2_50000_highRepDensity.bed -header > FILTERED_simulans_170strains_subset_CHR.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf
	
bgzip FILTERED_simulans_170strains_subset_CHR.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf 

tabix FILTERED_simulans_170strains_subset_CHR.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf.gz




# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
