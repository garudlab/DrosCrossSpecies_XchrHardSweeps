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
sexRatio=$9

outFile=outFiles/Stats_NeutralMaleBias${sexRatio}_${Ne}_Q${Q}_$chr_${id}.txt

for i in `seq 1 100`; do #1100

	#runSlim
	slim -d "file_path='${file}'" -d R=${rho_in}  -d N=${Ne} -d id=${id} -d Mu=${Mu}\
    -d Q=${Q}  -d "ChrType='${chr}'" -d burn_in=${burn_in} -d sexRatio=${sexRatio} Neutral_MaleBias.slim

     python popgenStats_sims.py -i ${file}  -o ${outFile}

done
rm tmpFiles/*_${id}.txt
