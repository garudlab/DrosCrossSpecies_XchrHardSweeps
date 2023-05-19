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


#for x in 2R 2L 3R 3L X; do #2R 2L 3R 3L X
#for w in 201; do
#	H12file=H12Files/FILTERED_simulans_170strains.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf.toH12_Chr${x}.txt
#	outFile=outH12/H12_D.simulans_chr${x}_${w}_50.txt
#       	python H12_H2H1_Py3_removeMDhaps.py ${H12file} 170  -o ${outFile} -w $w -j 50 -d 0
#done
#done

#autosomes
for x in X; do #2R 2L 3R 3L X
for w in 41; do
        H12file=H12Files/FILTERED_simulans_170strains.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf.toH12_Variants_Chr${x}.txt
        outFile=outH12/H12_D.simulans_chr${x}_${w}_1.txt
        python H12_H2H1_Py3_removeMDhaps.py ${H12file} 170 -o ${outFile} -w $w -j 1 -d 0 
	#H12_H2H1_Py3_removeMDhaps_downsample.py
done
done

#python H12_H2H1_Py3_removeMDhaps.py H12Files/FILTERED_simulans_170strains.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf.toH12_Variants_ChrX.txt 170  -o outH12/H12_D.simulans_chrX_371_50.txt -w 371 -j 50 -d 0

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "

