
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
module load htslib bcftools

#mauritiana sechellia santomea teissieri yakuba

for species in sechellia santomea teissieri yakuba; do
	echo ${species}
	bcftools view -f PASS  -r 2L,2R,3L,3R,X -m2 -M2 -v snps D.${species}.round2filter.vcf.gz >D.${species}.round2filter.PASS.biSNPs.vcf

	bgzip -c D.${species}.round2filter.PASS.biSNPs.vcf > D.${species}.round2filter.PASS.biSNPs.vcf.gz

	#index
	bcftools index D.${species}.round2filter.PASS.biSNPs.vcf.gz

	# Delete uncompressed file
	rm D.${species}.round2filter.PASS.biSNPs.vcf 
done


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
