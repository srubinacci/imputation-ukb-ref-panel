---
description: >-
  A resource of more than 400,000 haplotypes from the UK Biobank for genotype
  imputation.
---

# Getting started

The [UK Biobank](https://www.ukbiobank.ac.uk/) (UKB) stands as a substantial biomedical database and research repository, housing comprehensive genetic and health data gleaned from a vast cohort of 500,000 participants within the United Kingdom. Recently, the UKB has made a significant stride by granting access to over 200,000 whole genome sequences (WGS), marking one of the largest deeply sequenced resources available to date ([Halldorsson et al., 2022](https://doi.org/10.1038/s41586-022-04965-x)). In response to this, we have developed a novel method, known as [SHAPEIT5](https://doi.org/10.1038/s41588-023-01415-w), specifically tailored to phase the WGS data, ensuring the production of highly accurate haplotypes. This phased haplotype data is a potent asset for genetics and genomics research, providing valuable insights into population and disease genetics.

The primary objective of these tutorials is to demonstrate the process of genotype imputation using the phased UK Biobank resource as a reference panel, thereby enhancing SNP array and low-coverage WGS data. We present two pipeline options that can be readily employed as-is or adapted to meet individual user requirements. These pipelines are designed to function seamlessly within the [UK Biobank research analysis platform](https://ukbiobank.dnanexus.com/l) (RAP). Notably, within the RAP environment, all users share the same resources and tools, though the data is de-identified and accompanied by pseudo-identifiers. This shared reference panel concept enables the utilization of genotype imputation akin to a "personal" imputation server, where the SNP array and low-coverage WGS data remains private on the RAP, while the reference panel is accessible to all approved projects on the platform.

The SHAPEIT5 data can be accessed through the [data field labelled as 20279](https://biobank.ndph.ox.ac.uk/ukb/field.cgi?id=20279), accompanied by a detailed [report](https://biobank.ndph.ox.ac.uk/ukb/refer.cgi?id=1910) outlining data quality control (QC) procedures and quality metrics. We recommend ensuring that your project is updated to the latest version, or alternatively, consider doing so anytime after the September 2023. The phased data can be located in the Bulk folder under the following path:

`/Bulk/Whole genome sequences/SHAPEIT Phased VCFs/`

Please note that the data is organized by chromosome, and for chromosome X, only the non-PAR (non-pseudoautosomal) region has been phased and made available.

The reference panel is only in GRCh38 assembly. GRCh37 version is not available.

***

### Oveview of the pipelines

In brief, each pipeline comprises a few key steps:

1. **Creation of the Reference Panel File Format (one-time setup):** Given the inefficiency of processing large quantities of rare variants in VCF file format, the initial step involves converting VCF files into binary file formats. The choice of file format depends on the imputation tool in use. This step is typically fairly efficient. There's an ongoing effort to standardize file formats between the SHAPEIT5, GLIMPSE2, and IMPUTE5 software, please stay updated on these developments.
2. **Prephasing (for SNP array data only):** Prephasing of SNP array data is executed against the reference panel to facilitate efficient haploid imputation in the subsequent step.
3. **Genotype Imputation:** This is the computationally intensive step of both pipelines, with samples typically imputed in batches of 100-10,000 (depending on the pipeline). Imputation is often performed in chunks to enhance efficiency and parallelization.
4. **Ligation:** This step is necessary to assemble phased haplotypes from imputed data conducted in chunks. It involves matching the phasing in overlapping regions between chunks. While it's a mandatory step for low-coverage WGS data, for SNP array data, it may potentially be simplified as a straightforward concatenation of files, provided that prephasing was initially carried out on the entire chromosome or that pre-phased SNP array data was ligated on the whole chromosome after prephasing. Presently, each prephasing job runs independently, making it a prerequisite. However, ongoing efforts aim to eliminate the need for ligation on SNP array imputed data, allowing a more straightforward concatenation.

After completing these steps, a single file per chromosome is obtained. If multiple batches of samples are employed, these can later be merged together. By default, the imputed data outputs the GT (phased), DS, and GP fields. Additional fields can be requested according to the specific imputation tool, by providing tool-specific options.

In essence, these pipelines provide a cost-efficient approach to harness the power of phased UK Biobank data for genotype imputation, offering enhanced accuracy and insights for various applications in genetics and genomics.
