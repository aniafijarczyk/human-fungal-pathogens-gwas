rm(list=ls())
setwd("//wsl.localhost/Ubuntu/home/GAPP/01_genomic_pipeline/22_albicans_4sets/15b_gemma")


library(ggplot2)
library(dplyr)
library(tidyr)
library(cowplot)
library(ggtree)
library(ape)
library(phytools)
library(adephylo)
library(treeio)
library(readxl)
library(RColorBrewer)


### Reading ML tree 
tree <- read.tree("../09_iqtree/tree/bcftools_FLT2_snpEff.min4.phy.treefile")
tree


### Reroot
rooted_tree <- midpoint.root(tree)
rooted_tree

### Samples
ds <- read.csv("22_00_phenotypes.txt", sep="\t", header=F)
dsub <- ds %>% filter(V3 >-9)
dim(dsub)
dsub$V1
rooted_tree <- keep.tip(rooted_tree, dsub$V1)
rooted_tree






#################################### TREE
rownames(dsub) <- dsub$V1
head(dsub)


p01.tree <- ggtree(rooted_tree, layout="fan", open.angle=15)  %<+% dsub + 
  geom_tippoint(aes(fill=V3),size=2, pch=21, color='grey20') +
  geom_tiplab(align=TRUE, linesize=.5, aes(color=V3)) +
  theme(legend.position = "right") +
  scale_fill_distiller(palette = "Spectral", name="Log10 MIC\nFluconazole") +
  scale_color_distiller(palette = "Spectral", name="Log10 MIC\nFluconazole")
#scale_fill_manual(values=c('skyblue',"red","grey90"), name="Voriconazole") +
#scale_color_manual(values=c('skyblue',"red","grey90"), name="Voriconazole")
p01.tree





png("22_06_plotTree_gemma_fluconazole.png",w=5000,h=5000,res=300)
p01.tree
dev.off()





