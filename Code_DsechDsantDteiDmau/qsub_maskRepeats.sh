
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
module load htslib bcftools bedtools


for species in mauritiana sechellia santomea teissieri; do
	echo ${species}
	
	bedtools subtract -a D.${species}.round2filter.PASS.biSNPs.Mappabilily.vcf.gz \
		 -b ../RepeatMask_bedFiles/D.${species}_rm.out.bed -header > D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf

	bgzip -c D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf > D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.gz
        rm D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf

done


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
