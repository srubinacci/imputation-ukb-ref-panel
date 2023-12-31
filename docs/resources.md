---
description: Description of the resources used by the pipelines
---

# Resources

## Datasets

### UK Biobank 200k interim phased data release

The [UK Biobank](https://www.ukbiobank.ac.uk/) (UKB) stands as a substantial biomedical database and research repository, housing comprehensive genetic and health data gleaned from a vast cohort of 500,000 participants within the United Kingdom. Recently, the UKB has made a significant stride by granting access to over 200,000 whole genome sequences (WGS), marking one of the largest deeply sequenced resources available to date ([Halldorsson et al., 2022](https://doi.org/10.1038/s41586-022-04965-x)). In response to this, we have developed a novel method, called [SHAPEIT5](https://doi.org/10.1038/s41588-023-01415-w), specifically tailored to phase the WGS data, ensuring the production of highly accurate haplotypes. This phased haplotype data is a potent asset for genetics and genomics research, providing valuable insights into population and disease genetics.

The SHAPEIT5 phased data can be accessed through the [data field labeled 20279](https://biobank.ndph.ox.ac.uk/ukb/field.cgi?id=20279), accompanied by a detailed [report](https://biobank.ndph.ox.ac.uk/ukb/refer.cgi?id=1910) outlining data quality control (QC) procedures and quality metrics. We recommend ensuring that your project is updated to the latest version or consider doing so anytime after September 2023.

***

## Computational tools

### SHAPEIT5

[SHAPEIT5](https://doi.org/10.1038/s41588-023-01415-w) is a phasing software designed to perform haplotype phasing from large sequencing datasets (whole genome sequencing and whole exome sequencing data). SHAPEIT5 can accurately phase rare variants, even those found in just 1 in 100,000 samples, with switch error rates below 5%. It also enhances genotype imputation accuracy, as shown with the UK Biobank reference panel.

SHAPEIT5 is distributed with an **MIT license** and is available [HERE](https://github.com/odelaneau/shapeit5).

### GLIMPSE2

[GLIMPSE2](https://doi.org/10.1038/s41588-023-01438-3) is a set of tools for low-coverage whole genome sequencing imputation. GLIMPSE2 is based on the [GLIMPSE model](https://www.nature.com/articles/s41588-020-00756-0) and designed for reference panels containing hundreds of thousands of reference samples, with a special focus on rare variants.

GLIMPSE2 is distributed with an **MIT license** and is available [HERE](https://github.com/odelaneau/GLIMPSE).

### IMPUTE5

[IMPUTE5](https://doi.org/10.1371/journal.pgen.1009049) is a genotype imputation method that can scale to reference panels with millions of samples. It achieves fast, accurate, and memory-efficient imputation by selecting haplotypes using the Positional Burrows-Wheeler Transform (PBWT). The method then uses the selected haplotypes as conditioning states within the IMPUTE model.

IMPUTE5 is free only for academic use. Please read the **commercial license** before downloading the software. IMPUTE5 can be downloaded [HERE](https://jmarchini.org/software/#impute-5).

***

## Pipelines overview

### Low-coverage pipeline

The workflow begins with a collection of BAM/CRAM files containing low-coverage WGS reads, which are uploaded onto the UKB RAP. The low-coverage samples must have a broad European origin, aligning with the UK Biobank reference panel.

While the pipeline's default parameters are tailored for cost-efficiency, specifically for a few hundred samples, adaptations become necessary when dealing with larger sample sizes. This might involve the utilization of more substantial computing instances. It is advisable to execute the pipeline with approximately 100 samples per batch.

The low-coverage WGS imputation pipeline encompasses two distinct modules:

1. **Convert Reference**: This initial module is set up only once during pipeline establishment. Its objective is to convert the phased pVCF files from the RAP into GLIMPSE2's binary representation, accomplished through GLIMPSE\_split\_reference.
2. **Imputation**: The heart of the pipeline lies within this module, responsible for conducting genotype imputation via GLIMPSE2. This particular task is the most computationally intensive one throughout the entire pipeline. It takes binary reference panel files and a set of BAM/CRAM files as inputs.

Upon completing the imputation phase, a single ligation step is carried out to furnish chromosome-level phased genotypes.

Further improvements will involve the use of previously computed genotype likelihoods.

### SNP array pipeline

The workflow is initiated with a multi-sample VCF/BCF file that contains chromosome-wide SNP array data, potentially phased or unphased. This file needs to be uploaded by the user. Please ensure that the samples within the file are genotyped using the same SNP array and have a broad European origin aligning with the UK Biobank reference panel.

While the pipeline's default parameters are streamlined for cost efficiency, specifically targeting a few hundred samples, adjustments become imperative for handling larger sample sizes. This might entail employing more robust computing instances. The recommended range for executing samples within a single batch lies between 100 to 10,000. Running more samples on a single instance can mitigate computing expenses, but excessive samples might necessitate more substantial imputing instances.

The SNP array imputation pipeline is comprised of four sequential modules, each undertaking specific tasks. Here's a brief overview of each module:

1. **Convert Reference**: This module is executed only once during the pipeline setup and serves as the initial step. Its purpose is to convert the phased pVCF files from the RAP into the XCF sparse format, which is used by SHAPEIT5 and IMPUTE5.
2. **Pre-phasing**: This module performs pre-phasing of unphased SNP array data. It is _optional_ if your data is already phased and you supply chromosome-level phased files. However, keep in mind that the UK Biobank reference panel might significantly improve your phased SNP array data, therefore **we recommend this step also for data that is already phased**. Pre-phasing employs the SHAPEIT5\_phase\_common tool and produces a phased target file in the XCF binary format. The prephasing step is performed in chunks with an overlapping buffer to ensure maximum efficiency and parallelization. After prephasing, a fast ligation of the phased SNP array data is performed, resulting in a single file per chromosome. This ensures uniform haplotypes across the chromosome, enabling chunk-based imputation and straightforward file concatenation after imputation.
3. **Imputation**: This module is the most computationally intensive task in the pipeline. It utilizes IMPUTE5 v1.2 to perform genotype imputation and requires XCF files from both the reference and target panels as input.
4. **Post-Imputation Concatenation**: After imputation, a quick concatenation step is carried out to obtain chromosome-level phased and imputed genotypes. The final file is also indexed to allow random access across the chromosome.
