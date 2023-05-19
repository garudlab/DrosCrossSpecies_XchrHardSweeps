
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


for species in mauritiana sechellia santomea teissieri yakuba; do
	echo ${species}
	
	cat MappabilityFiles/D.${species}.GenMap.bedgraph | awk '$'4' == 1 ' > MappabilityFiles/D.${species}.GenMap.uniqueMap.bed
	bedtools intersect -a D.${species}.round2filter.PASS.biSNPs.vcf.gz \
		 -b MappabilityFiles/D.${species}.GenMap.uniqueMap.bed -header > D.${species}.round2filter.PASS.biSNPs.Mappabilily.vcf
	bgzip -c D.${species}.round2filter.PASS.biSNPs.Mappabilily.vcf > D.${species}.round2filter.PASS.biSNPs.Mappabilily.vcf.gz
	rm D.${species}.round2filter.PASS.biSNPs.Mappabilily.vcf
done


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
