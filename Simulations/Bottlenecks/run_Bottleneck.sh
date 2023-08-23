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
qb=$9
qd=${10} 
Tb=${11} 
Td=${12}
sexRatio=0.5

outFile=outFiles/Stats_Bottleneck_${Ne}_Q${Q}_qb${qb}_Tb${Tb}_$chr_${id}.txt

for i in `seq 1 15`; do #1100

	#runSlim
	slim -d "file_path='${file}'" -d R=${rho_in}  -d N=${Ne} -d id=${id} -d Mu=${Mu}\
    	-d Q=${Q}  -d "ChrType='${chr}'" -d burn_in=${burn_in} -d sexRatio=${sexRatio} \
    	-d qd=${qd} -d qb=${qb} -d tb=${Tb} -d td=${Td} Bottleneck.slim

     python popgenStats_sims.py -i ${file}  -o ${outFile}

done
rm tmpFiles/*_${id}.txt
