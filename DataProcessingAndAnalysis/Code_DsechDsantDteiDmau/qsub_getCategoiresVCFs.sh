#!/bin/bash
#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID
#$ -j y
## Edit the line below as needed:
#$ -l h_rt=24:00:00,h_data=3G
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
module load bedtools

for species in mauritiana sechellia santomea teissieri; do
	echo ${species}
	#for class in putativelyNeutral; do
	for class in exons introns intergenic subintergenic; do
  		bedtools intersect -a VCFs/D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf \
		-b Anotation_files/D.${species}_${class}_50kbPlus_1kbFarFromGenes.bed -header > FunctionalCategoriesVCFs/D.${species}_UNIQUE_${class}_50kbPlus_1kbFarFromGenes.vcf
	done
done

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "

