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

#for species in sechellia mauritiana sechellia teissieri santomea; do
#echo ${species}
#for x in 2R 2L 3R 3L X; do #2R 2L 3R 3L X
#for w in 201; do
#	H12file=H12Files/D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toG12_Chr${x}.txt
#	outFile=outH12/G12_D.${species}_chr${x}_${w}_50.txt
#
#	sampleSize=$(cat ${H12file} | awk -F "," '{print NF-1}'  | head -1)
# 	echo ${sampleSize}
#       	python H12_H2H1_Py3_removeMDhaps.py ${H12file} ${sampleSize}  -o ${outFile} -w $w -j 50 -d 0
#done
#done
#done



#autosomes
#for x in 2R 2L 3R 3L; do #2R 2L 3R 3L X
    #sechellia
    #python H12_H2H1_Py3_removeMDhaps.py  H12Files/D.sechellia.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toG12_Chr${x}.txt 23  -o outH12/G12_D.sechellia_chr${x}_40_1.txt -w 41 -j 1 -d 0
 
    #teissieri
    #python H12_H2H1_Py3_removeMDhaps.py  H12Files/D.teissieri.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toG12_Chr${x}.txt 11  -o outH12/G12_D.teissieri_chr${x}_560_1.txt -w 561 -j 1 -d 0

    #santomea
 #   python H12_H2H1_Py3_removeMDhaps.py H12Files/D.santomea.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toG12_Chr${x}.txt 7  -o outH12/G12_D.santomea_chr${x}_20_1.txt -w 20 -j 1 -d 0

    #mauritiana
    #python H12_H2H1_Py3_removeMDhaps.py  H12Files/D.mauritiana.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toG12_Chr${x}.txt 15  -o outH12/G12_D.mauritiana_chr${x}_430_1.txt -w 431 -j 1 -d 0
#done

#Chrom X

#sechellia
#python H12_H2H1_Py3_removeMDhaps.py  H12Files/D.sechellia.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toG12_ChrX.txt 23  -o outH12/G12_D.sechellia_chrX_10_1.txt -w 10 -j 1 -d 0

#teissieri
python H12_H2H1_Py3_removeMDhaps.py  H12Files/D.teissieri.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toG12_ChrX.txt 11 -o outH12/G12_D.teissieri_chrX_467_1.txt -w 467  -j 1 -d 0

#santomea
python H12_H2H1_Py3_removeMDhaps.py H12Files/D.santomea.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toG12_ChrX.txt 7 -o outH12/G12_D.santomea_chrX_145_1.txt -w 145 -j 1 -d 0

#mauritiana
#python H12_H2H1_Py3_removeMDhaps.py  H12Files/D.mauritiana.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.vcf.toG12_ChrX.txt 15  -o outH12/G12_D.mauritiana_chrX_250_10.txt -w 250 -j 10 -d 0


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "

