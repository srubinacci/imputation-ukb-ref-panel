---
description: Genotype imputation pipelines for the UK Biobank Research Analysis Platform
layout:
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# UK Biobank personal imputation server

***

## Introduction

Genotype imputation is a computational technique for estimating missing genotypes in SNP array data, using a reference panel of haplotypes. This approach extends to low-coverage whole genome sequencing data, aiding in filling missing genotypes or enhancing uncertain genotype calls from sequencing reads.

For both SNP array and low-coverage whole genome sequencing data, we've created two distinct pipelines using the **UK Biobank reference panel (>200,000 samples; 700M variants)** for genotype imputation. To ensure cost-effective implementation, we leverage efficient state-of-the-art tools, including [IMPUTE5](https://doi.org/10.1371/journal.pgen.1009049) (Rubinacci et al., 2020) for SNP array imputation and [GLIMPSE2](https://doi.org/10.1038/s41588-023-01438-3) (Rubinacci et al., 2023) for low-coverage WGS imputation.

Our pipelines can take input from a multi-sample VCF/BCF file with SNP array genotypes or a set of low-coverage BAM/CRAM files. Using the UK Biobank reference panel, the pipeline executes imputation through applets and _dx_ command jobs, tailor-made for the UKB RAP. At the end of each imputation pipeline, a single multi-sample BCF file is generated per chromosome, encompassing genotype posteriors, dosages, and phased best-guess genotypes. Further outputs like haploid dosages can be acquired by specifying appropriate options in the imputation software.

## Citation

If you use the pipelines in your research work, please cite the following papers:

**Reference panel**&#x20;

[Hofmeister RJ, Ribeiro DM, Rubinacci S, Delaneau O. 2023. Accurate rare variant phasing of whole-genome and whole-exome sequencing data in the UK Biobank. Nat Genet 55, 1243–1249 (2023)](https://doi.org/10.1038/s41588-023-01415-w).

**Low-coverage WGS imputation**

[Rubinacci et al., Imputation of low-coverage sequencing data from 150,119 UK Biobank genomes. Nat Genet 55, 1088–1090 (2023).](https://doi.org/10.1038/s41588-023-01438-3)

**SNP array imputation**

[Rubinacci et al., Genotype imputation using the Positional Burrows Wheeler Transform. PLoS Genet. 16, e1009049 (2020).](https://doi.org/10.1371/journal.pgen.1009049)

## About the project <a href="#about-the-project" id="about-the-project"></a>

The UK Biobank personal imputation server pipelines are developed by [Simone Rubinacci](https://srubinacci.github.io/) & [Olivier Delaneau](https://odelaneau.github.io/lap-page/).

#### License <a href="#license" id="license"></a>

The UK Biobank personal imputation server pipelines are distributed with an MIT license.

***

## Quick links

<table data-view="cards"><thead><tr><th></th><th></th><th></th><th data-hidden data-card-cover data-type="files"></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Get started</strong></td><td>Prepare the phased data in  the right format/location.</td><td></td><td><a href=".gitbook/assets/rap_homepage.png">rap_homepage.png</a></td><td><a href="getting-started.md">getting-started.md</a></td></tr><tr><td><strong>Low coverage pipeline</strong></td><td>Instructions to run the low-coverage pipeline</td><td></td><td><a href=".gitbook/assets/g2 (1).png">g2 (1).png</a></td><td><a href="running-the-low-coverage-pipeline.md">running-the-low-coverage-pipeline.md</a></td></tr><tr><td><strong>SNP array pipeline</strong></td><td>Instructions to run the SNP array pipeline</td><td></td><td><a href=".gitbook/assets/i5.png">i5.png</a></td><td><a href="running-the-snp-array-pipeline.md">running-the-snp-array-pipeline.md</a></td></tr></tbody></table>

#### &#x20;<a href="#organisations" id="organisations"></a>

\


