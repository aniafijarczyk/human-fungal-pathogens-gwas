#!/bin/bash

VCF_CORE=bcftools_FLT2_snpEff2_TRAIN_ID

conda activate plink

# Keep only samples with phenotype information
cat 22_00_phenotypes.txt | awk '{if ($3 != -9) print $0}' > 22_00_samples.txt
plink --keep 22_00_samples.txt --bfile ./22_gemma/${VCF_CORE} --make-bed --allow-extra-chr --out ./22_gemma/${VCF_CORE}_FLT

# Prune SNPs by missing data - min 20% samples
plink --bfile ./22_gemma/${VCF_CORE}_FLT --geno 0.02 --make-bed --allow-extra-chr --out ./22_gemma/${VCF_CORE}_1

# Prune by LD
plink --indep-pairwise 50 10 0.2 --bfile 22_gemma/${VCF_CORE}_1 --allow-extra-chr --out ./22_gemma/${VCF_CORE}_1
plink --extract ./22_gemma/${VCF_CORE}_1.prune.in --bfile 22_gemma/${VCF_CORE}_1 --make-bed --allow-extra-chr --out ./22_gemma/${VCF_CORE}_2

# Filter by MAF
plink --bfile ./22_gemma/${VCF_CORE}_2 --maf 0.01 --make-bed --allow-extra-chr --out ./22_gemma/${VCF_CORE}_3
plink --bfile ./22_gemma/${VCF_CORE}_2 --maf 0.05 --make-bed --allow-extra-chr --out ./22_gemma/${VCF_CORE}_4

conda deactivate
