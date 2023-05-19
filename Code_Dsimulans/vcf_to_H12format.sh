
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
module load anaconda3 htslib


#file=FILTERED_simulans_170strains_subset_CHR.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf
file=FILTERED_simulans_170strains.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf

#zcat VCFs/${file}.gz > VCFs/${file}

echo $file

sed -ne '/#CHR/,$ p' VCFs/${file} > VCFs/${file}_noHeader

for x in X 2R 2L 3R 3L; do
	grep ${x} VCFs/${file}_noHeader > dataByChr/${file}_noHeader_Chr${x}
	python vcf_to_H12format.py dataByChr/${file}_noHeader_Chr${x} -o H12Files/${file}.toH12_Chr${x}.txt
        rm dataByChr/*tmp
done





# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
