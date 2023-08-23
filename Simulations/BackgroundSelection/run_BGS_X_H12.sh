#!/bin/bash
# This script takes in an MS file  with 1000 simulations, and outputs a concatenated processed file. 
file=$1
rho_in=$2
Ne=$3
Q=$4
chr=$5
burn_in=$6
id=$7
Mu=$8
H=$9
sexRatio=0.5

outFile=outFiles/H12_BGS_${Ne}_Nesd${Nesd}_50del_H$H_Q${Q}_X

for i in `seq 1 10`; do #100

	#runSlim
	slim -d "file_path='${file}'" -d R=${rho_in}  -d N=${Ne} -d id=${id} -d Mu=${Mu}\
    	-d Q=${Q}  -d "ChrType='${chr}'" -d burn_in=${burn_in} -d sexRatio=${sexRatio} \
	-d H=${H}  BackgroundSelection.slim

     
	#parse VCF
	for sample in 7 15 25 50 100;do
		python ParseMS.py  -i ${file}_n${sample} -o ${file}_n${sample}_MS -w 20000
		
		#run H12 for 10,20,50 100 SNP windows
		for w in 10 20 50 100;do
			python H12_H2H1_Py3_v2.py ${file}_n${sample}_MS ${sample} -o ${file}_n${sample}_H12 -w ${w} -j 1 -d 0 -m 0.9
			cat ${file}_n${sample}_H12 >> ${outFile}_n${sample}_w${w}_${id}.txt
		done
	done

done

rm tmpFiles/*_${id}.txt_*
