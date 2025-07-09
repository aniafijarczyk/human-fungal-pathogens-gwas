#!/bin/bash


#mkdir -p 15_result
VCF_CORE=bcftools_FLT2_snpEff2_TRAIN_ID_4

### GETTING RELATEDNESS MATRIX
echo "GETTING RELATEDNESS MATRIX"
conda activate gemma
gemma -bfile ./22_gemma/${VCF_CORE} -gk 1 -o ${VCF_CORE}
conda deactivate

### LINEAR MIXED MODEL
echo "LINEAR MIXED MODEL"
conda activate gemma
# Binary phenotype (-n 1 - 1st column in fam file)
gemma -bfile ./22_gemma/${VCF_CORE} -n 1 -k ./output/${VCF_CORE}.cXX.txt -lmm 4 -o ${VCF_CORE}
conda deactivate
