# human-fungal-pathogens-gwas
Scripts for running gwas with gemma


### Preparing inputs

1. Preparing a file with phenotypes, either binary (1 [sensitive] / 2 [resistant]) or continuous (log2(MIC)). Missing data should be encoded as '-9'.

2. Converting vcf to plink. 
```
plink --vcf ${DIR}/${VCF} --double-id --keep-autoconv --allow-extra-chr --recode --pheno ${PHENO} --allow-no-sex --out 22_gemma/${VCF_CORE}
```

3. If conversion does not add phenotypes in the .fam file, change the .fam file manually. Substitute the sixth column in .fam file with phenotypes.

4. Data pruning with plink.

Removing samples with no phenotype information
```
plink --keep samples.txt --bfile ./22_gemma/${VCF_CORE} --make-bed --allow-extra-chr --out ./22_gemma/${VCF_CORE}_FLT
```
Removing variants with too much missing data. Here keeping only variants with no more than 2% missing genotypes.
```
plink --bfile ./22_gemma/${VCF_CORE}_FLT --geno 0.02 --make-bed --allow-extra-chr --out ./22_gemma/${VCF_CORE}_1
```
Pruning variants in linkage disequilibrium. Later, variants linked to outlier loci can be retrieved, but for the analysis, they need to go. 
```
plink --indep-pairwise 50 10 0.2 --bfile 22_gemma/${VCF_CORE}_1 --allow-extra-chr --out ./22_gemma/${VCF_CORE}_1
plink --extract ./22_gemma/${VCF_CORE}_1.prune.in --bfile 22_gemma/${VCF_CORE}_1 --make-bed --allow-extra-chr --out ./22_gemma/${VCF_CORE}_2
```
Filtering variants for minor allele frequency. Gemma will ignore too rare variants anyway. Usually, 0.05 works well.
```
plink --bfile ./22_gemma/${VCF_CORE}_2 --maf 0.01 --make-bed --allow-extra-chr --out ./22_gemma/${VCF_CORE}_3
plink --bfile ./22_gemma/${VCF_CORE}_2 --maf 0.05 --make-bed --allow-extra-chr --out ./22_gemma/${VCF_CORE}_4
```

### Running gemma

1. Getting the relatedness matrix
```
gemma -bfile ./22_gemma/${VCF_CORE} -gk 1 -o ${VCF_CORE}
```
2. Running the linear mixed model
```
gemma -bfile ./22_gemma/${VCF_CORE} -n 1 -k ./output/${VCF_CORE}.cXX.txt -lmm 4 -o ${VCF_CORE}
```
-n 1 - 1st column in fam file
