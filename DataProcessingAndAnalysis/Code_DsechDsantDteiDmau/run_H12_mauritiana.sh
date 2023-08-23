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

for species in mauritiana; do
for x in X; do # 2R 2L 3R 3L; do
for w in 251; do
	H12file=H12Files/D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toH12_phased_Chr${x}.txt
	outFile=outH12/H12_D.${species}_phased_chr${x}_${w}_1.txt

	sampleSize=$(cat ${H12file} | awk -F "," '{print NF-1}'  | head -1)
 
       	python H12_H2H1_Py3_removeMDhaps.py ${H12file} ${sampleSize}  -o ${outFile} -w $w -j 1 -d 0
done
done
done



#autosomes
#for x in 2R 2L 3R 3L; do #2R 2L 3R 3L X
    #mauritiana
 #   python H12_H2H1_Py3_removeMDhaps.py  H12Files/D.mauritiana.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toH12_phased_Chr${x}.txt 15  -o outH12/H12_D.mauritiana_phased_chr${x}_430_50.txt -w 431 -j 50 -d 0
#done

#Chrom X

#mauritiana
python H12_H2H1_Py3_removeMDhaps.py  H12Files/D.mauritiana.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toH12_phased_ChrX.txt 15  -o outH12/H12_D.mauritiana_phased_chrX_10_1.txt -w 20 -j 1 -d 0


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "

