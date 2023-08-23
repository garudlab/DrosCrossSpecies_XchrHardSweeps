
#!/bin/bash                         #-- what is the language of this shell

#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID.$TASK_ID
#$ -j y
## Edit the line below as needed:
#$ -l h_rt=48:00:00,h_data=10G,highp
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
module load gcc samtools gatk

#file=simulans_multisamp_170strains_subset_CHR.recode_ZIP.vcf.recode.vcf.gz
file=simulans_multisamp_all_chr_170strains.vcf.gz

gatk --java-options "-Xmx7g" VariantFiltration \
    -V VCFs/${file} \
    -R Reference/DsimGenomeShare/dsimV2-Mar2013-Genbank.fa.gz \
    --filter-expression "QD < 2.0"  --filter-name "GATK_filter1" \
    --filter-expression "FS > 60.0" --filter-name "GATK_filter2" \
    --filter-expression  "SOR > 3.0" --filter-name "GATK_filter3" \
    --filter-expression  "MQ < 40.0" --filter-name "GATK_filter4" \
    --filter-expression "MQRankSum < -12.5" --filter-name "GATK_filter5" \
    --filter-expression  "ReadPosRankSum < -8.0" --filter-name "GATK_filter6" \
    -O VCFs/FILTERD_${file}


gatk --java-options "-Xmx7g" SelectVariants \
    -V VCFs/FILTERD_${file} \
    -O VCFs/FILTERD_SNPs_${file} \
    -select 'vc.isNotFiltered()' -select-type SNP


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
