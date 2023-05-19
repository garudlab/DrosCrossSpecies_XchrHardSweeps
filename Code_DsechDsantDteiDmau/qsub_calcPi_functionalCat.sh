
#!/bin/bash                         #-- what is the language of this shell

#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID.$TASK_ID
#$ -j y
## Edit the line below as needed:
#$ -l h_rt=5:00:00,h_data=10G
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
module load anaconda3


for species in sechellia mauritiana sechellia teissieri santomea; do
echo ${species}
for class in exons introns intergenic subintergenic; do
for x in X 2R 2L 3R 3L; do
	file=D.${species}_UNIQUE_${class}_50bpPlus.vcf.toH12_wild_Chr${x}.txt
	sampleSize=$(cat H12Files/${file} | awk -F "," '{print NF-1}'  | head -1)
	python calcPi_FunctionalCat.py ${sampleSize} -i H12Files/${file} -b Anotation_files/D.${species}_UNIQUE_${class}_50bpPlus.bed -o outPi/D.${species}_myPI_chr${x}_${class}_50bpPlus.txt -c ${x} 
done
done
done


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
