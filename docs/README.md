---
description: Genotype mputation pipelines for the UK Biobank Research Analysis Platform
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

## About

***

## About

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

***

## Quick links

<table data-view="cards"><thead><tr><th></th><th></th><th></th><th data-hidden data-card-cover data-type="files"></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Get started</strong></td><td>Prepare the phased data in  the right format/location.</td><td></td><td><a href=".gitbook/assets/rap_homepage.png">rap_homepage.png</a></td><td><a href="getting-started.md">getting-started.md</a></td></tr><tr><td><strong>Low coverage pipeline</strong></td><td>Instructions to run the low-coverage pipeline</td><td></td><td><a href=".gitbook/assets/g2 (1).png">g2 (1).png</a></td><td><a href="running-the-low-coverage-pipeline.md">running-the-low-coverage-pipeline.md</a></td></tr><tr><td><strong>SNP array pipeline</strong></td><td>Instructions to run the SNP array pipeline</td><td></td><td><a href=".gitbook/assets/i5.png">i5.png</a></td><td><a href="running-the-snp-array-pipeline.md">running-the-snp-array-pipeline.md</a></td></tr></tbody></table>

***

## Low-coverage WGS pipeline

The workflow begins with a collection of BAM/CRAM files containing low-coverage WGS reads, which are uploaded onto the UKB RAP. It is crucial that the low-coverage samples have a broad European origin, aligning with the UK Biobank reference panel.

While the pipeline's default parameters are tailored for cost-efficiency, specifically for a few hundred samples, adaptations become necessary when dealing with larger sample sizes. This might involve the utilization of more substantial computing instances. It is advisable to execute the pipeline with approximately 100 samples per batch.

The low-coverage WGS imputation pipeline encompasses two distinct modules:

1.  **Convert Reference**: This initial module is set up only once during pipeline establishment. Its objective is to convert the phased pVCF files from the RAP into <mark style="color:orange;">GLIMPSE2</mark>'s binary representation, accomplished through <mark style="color:orange;">GLIMPSE\_split\_reference</mark>.


2. **Imputation**: The heart of the pipeline lies within this module, responsible for conducting genotype imputation via <mark style="color:orange;">GLIMPSE2</mark>. This particular task is the most computationally intensive one throughout the entire pipeline. It takes binary reference panel files and a set of BAM/CRAM files as inputs.

Upon completing the imputation phase, a single ligation step is carried out to furnish chromosome-level phased genotypes.

Further improvements will involve the use of previously computed genotype likelihoods.

## SNP array pipeline

The workflow is initiated with a multi-sample VCF/BCF file that contains chromosome-wide SNP array data, potentially phased or unphased. Please ensure that the samples within the file are genotyped using the same SNP array and have a broad European origin aligning with the UK Biobank reference panel.

While the pipeline's default parameters are streamlined for cost-efficiency, specifically targeting a few hundred samples, adjustments become imperative for handling larger sample sizes. This might entail employing more robust computing instances. The recommended range for executing samples within a single batch lies between 100s to 10,000. Running more samples on a single instance can mitigate computing expenses, but excessive samples might necessitate more substantial imputing instances.

The SNP array imputation pipeline is comprised of four sequential modules, each undertaking specific tasks. Here's a succinct overview of each module:

1. **Convert Reference**: This module, executed only once during pipeline setup, constitutes the initial step. Its purpose revolves around converting the phased pVCF files from the RAP into the XCF sparse format, which is employed by <mark style="color:orange;">SHAPEIT5</mark> and <mark style="color:orange;">IMPUTE5</mark>.
2. **Prephasing**: Employing the <mark style="color:orange;">SHAPEIT5</mark> <mark style="color:orange;">phase\_common</mark> tool, this module is pivotal for prephasing data, especially when working with unphased SNP array data. The outcome is a phased target file in the XCF binary format.
3. **Imputation**: The heart of computational intensity within the pipeline lies in this module. It shoulders the responsibility of genotype imputation through <mark style="color:orange;">IMPUTE5 v1.2</mark>. The task hinges on input XCF files from both the reference and target panels.

Upon concluding the imputation phase, a single ligation process is conducted to yield chromosome-level phased genotypes. This step becomes necessary due to the data's prephased nature in chunks. In cases where prephasing encompasses the entire chromosome, this ligation step becomes redundant as a single concatenation (e.g., employing bcftools concat) significantly expedites the process. Ongoing pipeline developments aim to eliminate the necessity for a final ligation step. This will involve the concatenation of SNP array prephased data within the xcf file format.

## Computational tools

### GLIMPSE2

[GLIMPSE2](https://doi.org/10.1038/s41588-023-01438-3) is a set of tools for low-coverage whole genome sequencing imputation. <mark style="color:orange;">GLIMPSE2</mark> is based on the [GLIMPSE model](https://www.nature.com/articles/s41588-020-00756-0) and designed for reference panels containing hundreads of thousands of reference samples, with a special focus on rare variants.

GLIMPSE2 is available [HERE](https://github.com/odelaneau/GLIMPSE).

### IMPUTE5

[IMPUTE5](https://doi.org/10.1371/journal.pgen.1009049) is a genotype imputation method that can scale to reference panels with millions of samples. It achieves fast, accurate, and memory-efficient imputation by selecting haplotypes using the Positional Burrows Wheeler Transform (PBWT). The method then uses the selected haplotypes as conditioning states within the <mark style="color:orange;">IMPUTE</mark> model.

IMPUTE5 is available [HERE](https://jmarchini.org/software/#impute-5).

