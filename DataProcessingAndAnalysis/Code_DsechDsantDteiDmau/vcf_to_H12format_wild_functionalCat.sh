
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


for species in sechellia mauritiana teissieri santomea; do
for class in exons introns intergenic subintergenic; do

file=D.${species}_UNIQUE_${class}_50bpPlus.vcf
echo $file

sed -ne '/#CHR/,$ p' FunctionalCategoriesVCFs/${file} > FunctionalCategoriesVCFs/${file}_noHeader

for x in X 2R 2L 3R 3L; do
	grep ${x} FunctionalCategoriesVCFs/${file}_noHeader > dataByChr/${file}_noHeader_Chr${x}_tmp
        grep -v ${x}_ dataByChr/${file}_noHeader_Chr${x}_tmp > dataByChr/${file}_noHeader_Chr${x}
	python vcf_to_H12format_wild.py dataByChr/${file}_noHeader_Chr${x} -o H12Files/${file}.toH12_wild_Chr${x}.txt
        rm dataByChr/*tmp
done
done
done

rm FunctionalCategories/*_noHeader

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
