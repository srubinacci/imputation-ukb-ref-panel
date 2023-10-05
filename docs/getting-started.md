---
description: >-
  A resource of more than 400,000 haplotypes from the UK Biobank for genotype
  imputation.
---

# Getting started

The primary objective of these tutorials is to demonstrate the process of genotype imputation using the phased UK Biobank resource as a reference panel, thereby enhancing both SNP array and low-coverage WGS data. We present two pipeline options that can be readily employed or adapted to meet individual user requirements. These pipelines are designed to function seamlessly within the [UK Biobank research analysis platform](https://ukbiobank.dnanexus.com/l) (RAP). Notably, all users share the same resources and tools within the RAP environment, though the data is de-identified and accompanied by pseudo-identifiers. This shared reference panel concept enables the utilization of genotype imputation akin to a "personal" imputation server, where the SNP array and low-coverage WGS data remain private on the RAP, while the reference panel is accessible to all approved projects on the platform.

The SHAPEIT5 data can be accessed through the [data field labeled 20279](https://biobank.ndph.ox.ac.uk/ukb/field.cgi?id=20279), accompanied by a detailed [report](https://biobank.ndph.ox.ac.uk/ukb/refer.cgi?id=1910) outlining data quality control (QC) procedures and quality metrics. We recommend ensuring that your project is updated to the latest version or consider doing so anytime after September 2023. The phased data can be located in the Bulk folder under the following path:

`/Bulk/Whole genome sequences/SHAPEIT Phased VCFs/`

Please note that the data is organized by chromosome, and for chromosome X, only the non-PAR (non-pseudoautosomal) region has been phased and made available.

The reference panel is only in the GRCh38 assembly. The GRCh37 version is not available.

***

### Overview of the pipelines

In brief, each pipeline comprises a few key steps:

1. **Creation of the Reference Panel File Format (one-time setup):** Given the inefficiency of processing large quantities of rare variants in VCF file format, the initial step involves converting VCF files into binary file formats. The choice of file format depends on the imputation tool in use. This step is typically fairly efficient. There's an ongoing effort to standardize file formats between the SHAPEIT5, GLIMPSE2, and IMPUTE5 software, please stay updated on these developments.
2. **Prephasing + ligation (for SNP array data only):** Prephasing of SNP array data is executed against the reference panel to facilitate efficient haploid imputation in the subsequent step. A ligation step is run on the phased SNP array data to ensure chromosome-wide phased files.
3. **Genotype Imputation:** This is the computationally intensive step of both pipelines, with samples typically imputed in batches of 100-10,000 (depending on the pipeline). Imputation is often performed in chunks to enhance efficiency and parallelization.
4. **Ligation (for low-coverage data) or Concatenation (for SNP array data):**&#x20;
   1. **Ligation**: _for low-coverage WGS data_, this step is necessary to assemble phased haplotypes from imputed data conducted in chunks. It involves matching the phasing in overlapping regions between chunks.&#x20;
   2. **Concatenation**: _for SNP array data_, pre-phasing can be directly performed at the chromosome level or in chunks (like in the SNP array pipeline). In the latter case, a ligation step can then be performed directly on the SNP array data (**step 2.**). As a result, the haplotypes are available at the chromosome level and the returned imputed haploid haplotypes can be simply concatenated, removing the need to perform ligation post-imputation. This strategy is more efficient than performing the ligation post-imputation, as it involves a fraction of the variants and much smaller files. Additionally, it does not require specific treatment for additional haplotype-level fields, such as haploid dosages.

After completing these steps, a single file per chromosome is obtained. If multiple batches of samples are employed, these can later be merged. By default, the imputed data outputs the GT (phased), DS, and GP fields. Additional fields can be requested according to the specific imputation tool, by providing tool-specific options.

In essence, these pipelines provide a cost-efficient approach to harness the power of phased UK Biobank data for genotype imputation, offering enhanced accuracy and insights for various applications in genetics and genomics.
