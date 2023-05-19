
#!/bin/bash                         #-- what is the language of this shell

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
module load htslib bedtools

#file=FILTERD_PASS_biSNPs_simulans_multisamp_170strains_subset_CHR.recode_ZIP.vcf.recode.vcf.gz
file=FILTERD_PASS_biSNPs_simulans_multisamp_all_chr_170strains.vcf.gz

cd VCFs/

bedtools subtract  -a ${file} -b ../Reference/RepeatMasker/D.simulans_rm.out.bed -header > FILTERED_simulans_multisamp_170strains.RepeatsMasked.vcf

bgzip FILTERED_simulans_multisamp_170strains.RepeatsMasked.vcf 
tabix  FILTERED_simulans_multisamp_170strains.RepeatsMasked.vcf.gz

cd ..

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
