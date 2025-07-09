#!/bin/bash

DIR=/mnt/c/Users/aniaf/Projects/GAPP/DATA/AFR_prediction_albicans/10_variants/
VCF=bcftools_FLT2_snpEff2_TRAIN_ID.vcf.gz
VCF_CORE=$(basename $VCF | sed 's/.vcf.gz//g')
PHENO=22_00_phenotypes.txt

conda activate plink
mkdir -p 22_gemma
plink --vcf ${DIR}/${VCF} --double-id --keep-autoconv --allow-extra-chr --recode --pheno ${PHENO} --allow-no-sex --out 22_gemma/${VCF_CORE}
mv 22_gemma/${VCF_CORE}.fam 22_gemma/${VCF_CORE}_nopheno.fam
conda deactivate


