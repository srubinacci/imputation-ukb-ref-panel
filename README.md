<p align="center">
  <a href="https://srubinacci.gitbook.io/uk-biobank-imputation-pipelines/">
    <img height="150" src="https://github.com/srubinacci/imputation-ukb-ref-panel/assets/17588501/902fcd67-3176-4152-bf24-579ad3127a43">
  </a>
  <h1 align="center">UK Biobank imputation pipelines</h1>
</p>

## About

Genotype imputation is a computational technique for estimating missing genotypes in SNP array data, using a reference panel of haplotypes. This approach extends to low-coverage whole genome sequencing data, aiding in filling missing genotypes or enhancing uncertain genotype calls from sequencing reads.

For both SNP array and low-coverage whole genome sequencing data, we've created two distinct pipelines using the **UK Biobank reference panel (>200,000 samples; 700M variants)** for genotype imputation. To ensure cost-effective implementation, we leverage efficient state-of-the-art tools, including [IMPUTE5](https://doi.org/10.1371/journal.pgen.1009049) (Rubinacci et al., 2020) for SNP array imputation and [GLIMPSE2](https://doi.org/10.1038/s41588-023-01438-3) (Rubinacci et al., 2023) for low-coverage WGS imputation.

Our pipelines can take input from a multi-sample VCF/BCF file with SNP array genotypes or a set of low-coverage BAM/CRAM files. Using the UK Biobank reference panel, the pipeline executes imputation through applets and _dx_ command jobs, tailor-made for the UKB RAP. At the end of each imputation pipeline, a single multi-sample BCF file is generated per chromosome, encompassing genotype posteriors, dosages, and phased best-guess genotypes. Further outputs like haploid dosages can be acquired by specifying appropriate options in the imputation software.


## Website and tutorials

Tutorials on how to use the pipelines can be found at:

https://srubinacci.gitbook.io/uk-biobank-imputation-pipelines/


## Citation

If you use the pipelines in your research work, please cite the following papers:

**Reference panel**&#x20;

[Hofmeister RJ, Ribeiro DM, Rubinacci S, Delaneau O. 2023. Accurate rare variant phasing of whole-genome and whole-exome sequencing data in the UK Biobank. Nat Genet 55, 1243–1249 (2023)](https://doi.org/10.1038/s41588-023-01415-w).

**Low-coverage WGS imputation**

[Rubinacci et al., Imputation of low-coverage sequencing data from 150,119 UK Biobank genomes. Nat Genet 55, 1088–1090 (2023).](https://doi.org/10.1038/s41588-023-01438-3)

**SNP array imputation**

[Rubinacci et al., Genotype imputation using the Positional Burrows Wheeler Transform. PLoS Genet. 16, e1009049 (2020).](https://doi.org/10.1371/journal.pgen.1009049)


## About the project
The UK Biobank imputation pipelines are developed by Simone Rubinacci & Olivier Delaneau.


## License
The UK Biobank imputation pipelines are distributed with an MIT license.
