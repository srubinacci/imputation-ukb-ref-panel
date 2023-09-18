---
description: Upload files and compile the applets on the RAP
---

# Setting up the project

### 1. UK Biobank RAP

In order to run the tutorials, you need to be a registered UK Biobank researcher and have access to a research project and the research analysis platform. We also require you to set up the [billing](https://documentation.dnanexus.com/admin/billing-and-account-management) for your project/account.&#x20;

The [DNAnexus SDK (`dx-toolkit`)](broken-reference) is required. Please download, install, and set up the dx-toolkit as instructed by DNAnexus. A quick introduction to the dx toolkit can be found [here](https://documentation.dnanexus.com/getting-started/cli-quickstart).

We first create a folder called <mark style="color:orange;">`apps`</mark> where all the applets will go. We created this folder in the home directory. We also created some other helpful directories for the two projects:

<pre class="language-bash"><code class="lang-bash">dx cd

dx mkdir -p ukb-imputation #home directory for both pipelines
dx mkdir -p ukb-imputation/apps #location of the applets
dx mkdir -p ukb-imputation/maps #location of the genetics maps (same for both pipelines)

dx mkdir -p ukb-imputation/glimpse2 #home directory for the low-coverage pipeline
dx mkdir -p ukb-imputation/glimpse2/chunks #location of the chunks for low-coverage pipeline
dx mkdir -p ukb-imputation/glimpse2/ref_genome #location of reference genome (fasta + fai)
dx mkdir -p ukb-imputation/glimpse2/ref_bin_phased #location of the reference panel in binary format
<strong>dx mkdir -p ukb-imputation/glimpse2/tar_bam_list #location of list of BAM/CRAMs
</strong>dx mkdir -p ukb-imputation/glimpse2/tar_bam_files #location of the uploaded BAM/CRAMs
dx mkdir -p ukb-imputation/glimpse2/out #location of the output imputed data

dx mkdir -p ukb-imputation/impute5 #home directory for the snp-array pipeline
dx mkdir -p ukb-imputation/impute5/chunks #location of the chunks for snp-array pipeline
dx mkdir -p ukb-imputation/impute5/ref_xcf_phased #location of the reference panel in binary format
dx mkdir -p ukb-imputation/impute5/tar_xcf_phased #location of the target panel in binary format
dx mkdir -p ukb-imputation/impute5/tar_bcf_files #location of the target panel in VCF/BCF format
dx mkdir -p ukb-imputation/impute5/out #location of the output imputed data
</code></pre>

### 2. Download the repository

To get started, we first clone the Github repository containing the pipelines. To do this run:

```bash
git clone https://github.com/srubinacci/imputation-ukb-ref-panel.git
```

We then move to the folder that we just created:

```bash
cd imputation-ukb-ref-panel
```

You have two folders here, one for the low-coverage pipeline and one for the SNP array pipeline. The tutorial always assumes that the current working directory is imputation-ukb-ref-panel (please do not cd to another directory).

### 3. Upload the resource data

Imputation pipelines use the same genetic map files. These files are in the GitHub project of the pipeline under the data folder. You will need to upload these files to your project.

```bash
dx upload -r data/maps --path ukb-imputation/
```

This will upload the genetic map files to the expected location.&#x20;

Additional data to be uploaded are described in the setup page of the respective pipeline.
