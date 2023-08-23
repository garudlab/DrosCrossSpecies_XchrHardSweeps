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

outFile=outFiles/Stats_BGS_${Ne}_Nesd${Nesd}_80del_H$H_Q${Q}_A_${id}.txt

for i in `seq 1 100`; do #1100

	#runSlim
	slim -d "file_path='${file}'" -d R=${rho_in}  -d N=${Ne} -d id=${id} -d Mu=${Mu}\
    	-d Q=${Q}  -d "ChrType='${chr}'" -d burn_in=${burn_in} -d sexRatio=${sexRatio} \
	-d H=${H}  BackgroundSelection.slim

     python popgenStats_sims.py -i ${file}  -o ${outFile} -d $H -s 133

done

rm tmpFiles/*_${id}.txt
