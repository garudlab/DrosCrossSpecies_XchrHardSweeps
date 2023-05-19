
#!/bin/bash 

#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID
#$ -j y
## Edit the line below as needed:
#$ -l h_rt=24:00:00,h_data=12G,h_vmem=2g
## Modify the parallel environment
## and the number of cores as needed:
#$ -pe shared 1
# Notify when
#$ -m bea


. /u/local/Modules/default/init/modules.sh
module load picard_tools
module load samtools


java -Xmx8G -jar $PICARD CreateSequenceDictionary R=dsimV2-Mar2012_named.fa.gz O=dsimV2-Mar2012_named.dict
samtools faidx dsimV2-Mar2012_named.fa.gz

#dsimV2-Mar2013-Genbank.fa.gz


