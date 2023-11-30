#!/bin/bash
#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID
#$ -j y
## Edit the line below as needed:
#$ -l h_rt=40:00:00,h_data=5G,highp
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

for species in sechellia; do # sechellia santomea teissieri mauritiana
	echo ${species}
	file_in=H12Files/D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf.toH12_wild_ChrX.txt
	#file_in=H12Files_revisions/D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.bandedFiltered.RemoveHighRepDens_0.2_50kb.vcf.toH12_wild_ChrX.txt
	sampleSize=$(cat ${file_in} | awk -F "," '{print NF-1}'  | head -1)
  	echo $sampleSize
	
	for x in X 2R 2L 3R 3L; do
		 file_H12=H12Files/D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf.toH12_wild_Chr${x}.txt
		 #file_H12=H12Files_revisions/D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.bandedFiltered.RemoveHighRepDens_0.2_50kb.vcf.toH12_wild_Chr${x}.txt
		 
		 python Add_bandedNs_intervals.py -b bandedGVCF/masked_D.${species}.round2.${x}.merged.bed -o H12Files_revisions/Ns_D.${species}_Chr${x}.txt -n ${sampleSize}
		 cat ${file_H12} H12Files_revisions/Ns_D.${species}_Chr${x}.txt > H12Files_revisions/Ns_merge_D.${species}_Chr${x}.txt
	
		#sort
		sort -t',' -k1n H12Files_revisions/Ns_merge_D.${species}_Chr${x}.txt > H12Files_revisions/D.${species}.round2filter.PASS.biSNPs.Mappabilily.RepeatsMasked.RemoveHighRepDens_0.2_50kb.vcf.toH12_wild_Chr${x}_Ns.txt
	done
	rm H12Files_revisions/Ns_*
done

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "

