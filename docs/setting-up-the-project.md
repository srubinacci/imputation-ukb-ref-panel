---
description: Upload files and compile the applets on the RAP
---

# Setting up the project

### UK Biobank RAP

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

### Download the repository

To get started, we first clone the Github repository containing the pipelines. To do this run:

```bash
git clone https://github.com/srubinacci/imputation-ukb-ref-panel.git
```

We then move to the folder that we just created:

```bash
cd imputation-ukb-ref-panel
```

You have two folders here, one for the low-coverage pipeline and one for the SNP array pipeline. The tutorial always assumes that the current working directory is imputation-ukb-ref-panel (please do not cd to another directory).

### Upload the resource data

Imputation pipelines use the same genetic map files. These files are in the GitHub project of the pipeline under the data folder. You will need to upload these files to your project.

```bash
dx upload -r data/maps --path ukb-imputation/
```

This will upload the genetic map files to the expected location.

Additional mandatory data can be uploaded using the procedure illustrated in the following boxes.

<details>

<summary>Low-coverage chunks</summary>

Pre-computed chunks of \~4 cM length can be uploaded using:

<pre><code><strong>dx upload -r data/chunks/glimpse2/* --path ukb-imputation/glimpse2/chunks/
</strong></code></pre>

</details>

<details>

<summary>GRCh38 reference genome</summary>

The reference genome in b38 is necessary to process CRAM files. We download it from 1000 Genomes EBI ftp server and upload it on the RAP in the expected folder:

```bash
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa.fai

dx upload GRCh38_full_analysis_set_plus_decoy_hla.fa --path ukb-imputation/glimpse2/ref_genome/
dx upload GRCh38_full_analysis_set_plus_decoy_hla.fa.fai --path ukb-imputation/glimpse2/ref_genome/
```

**Faster (but manual) alternative**

Downloading data from the EBI ftp server might be slow outside the UK. However, as the UK Biobank RAP is located in London, we can download the file directly on the RAP. To do that you can use the ttyd app for an interactive session, or alternatively use the url\_fetcher app. Here we quickly describe how to use this second option.

To use the url\_fetcher app, just browse in Tool library -> URL Fetcher -> Run. The output destination needs to be the expected path: `ukb-imputation/glimpse2/ref_genome/`.&#x20;

Put the URL (indicated above) in the right textbox. No need to fill in the optional file name. When you are ready, press "Start Analysis" on the top right. When the job ends, the file will be found in the right location. Finally, repeat this step for the .fai index.

</details>

<details>

<summary>SNP array chunks</summary>

Pre-computed chunks of \~40 cM length can be uploaded using:

<pre><code><strong>dx upload -r data/chunks/impute5/* --path ukb-imputation/impute5/chunks/
</strong></code></pre>

</details>

### Compile the low-coverage pipeline

There are three tools you need to download for the low-coverage pipeline:

* `GLIMPSE2_split_reference` - for converting the reference panel&#x20;
* `GLIMPSE2_phase` - for imputation and phasing
* `GLIMPSE2_ligate` - for the ligation step

#### Download the tools and copy them inside the right folder

You can download static binaries of the tools in the [release section on Github](https://github.com/odelaneau/GLIMPSE/releases) or compile your own static binaries. Download the files, remove the `*_static` extension from the filename, and copy each program into the folder `resources/usr/bin/` of the appropriate tool:

<pre class="language-bash" data-title="GLIMPSE2_split_reference"><code class="lang-bash"><strong>#please change the address to the latest release. This is just an example.
</strong><strong>wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/GLIMPSE2_split_reference_static
</strong>#change name removing the "_static" extension
mv GLIMPSE2_split_reference_static GLIMPSE2_split_reference
#copy the tool to the right folder
mv GLIMPSE2_split_reference low-coverage-pipeline/tools/split_reference/resources/usr/bin/
</code></pre>

{% code title="GLIMPSE2_phase" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/GLIMPSE2_phase_static
#change name removing the "_static" extension
mv GLIMPSE2_phase_static GLIMPSE2_phase
#copy the tool to the right folder
mv GLIMPSE2_phase low-coverage-pipeline/tools/glimpse2_phase/resources/usr/bin/
```
{% endcode %}

{% code title="GLIMPSE2_ligate" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/GLIMPSE2_ligate_static
#change name removing the "_static" extension
mv GLIMPSE2_ligate_static GLIMPSE2_ligate
#copy the tool to the right folder
mv GLIMPSE2_ligate low-coverage-pipeline/tools/ligate/resources/usr/bin/
```
{% endcode %}

#### Create applets

Compile the applets using the dx compile command:

```bash
dx build low-coverage-pipeline/tools/split_reference -d ukb-imputation/apps/ -f 
dx build low-coverage-pipeline/tools/glimpse2_phase -d ukb-imputation/apps/ -f 
dx build low-coverage-pipeline/tools/ligate -d ukb-imputation/apps/ -f 
dx build low-coverage-pipeline/low-coverage-pipeline -d ukb-imputation/apps/ -f 
```

You should now see the applets appearing on the RAP in the apps folder.

### Compile the SNP array pipeline

There are three tools you need to download for the low-coverage pipeline:

* `XCFTOOLS` - for converting the reference panel&#x20;
* `SHAPEIT5_phase_common` - for converting the reference panel&#x20;
* `IMPUTE5` - for haploid SNP array imputation (>= v1.2)
* `GLIMPSE2_ligate` - for the ligation step

#### Download the tools and copy them inside the right folder

Several tools are used in this pipeline. Please download each of the tools separately. Keep in mind that IMPUTE5 is free only for academic use, please read the license before using the software.&#x20;

* Static versions of XCFTOOLS and IMPUTE5 can be downloaded from the [IMPUTE5 website](https://jmarchini.org/software/#impute-5).
* SHAPEIT5\_phase\_common can be downloaded from the [release section on GitHub.](https://github.com/odelaneau/shapeit5/releases)
* GLIMPSE2\_ligate can be downloaded from the [release section on GitHub](https://github.com/odelaneau/GLIMPSE/releases).

Download the files, remove the `*_static` extension from the filename and copy each program in the `resources/usr/bin/` of the appropriate tool:

<pre class="language-bash" data-title="XCFTOOLS &#x26; IMPUTE5"><code class="lang-bash"><strong>#Download the latest version of the zip from https://jmarchini.org/software/#impute-5 
</strong>unzip impute5_v1.2.0.zip #change the version name accordingly
#change name removing the "_static" extension and versioning
mv impute5_v1.2.0/impute5_v1.2.0_static impute5_v1.2.0/impute5
mv impute5_v1.2.0/xcftools_static impute5_v1.2.0/xcftools
#copy the tools to the right folder
mv impute5_v1.2.0/impute5 snp-array-pipeline/tools/impute5/resources/usr/bin/
mv impute5_v1.2.0/xcftools snp-array-pipeline/tools/xcftools/resources/usr/bin/

#clean the local folder from temporary files
rm -rf impute5_v1.2.0/ impute5_v1.2.0.zip __MACOSX/
</code></pre>

{% code title="SHAPEIT5_phase_common" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/shapeit5/releases/download/v5.1.1/phase_common_static
#change name removing the "_static" extension
mv phase_common_static shapeit5_phase_common
#copy the tool to the right folder
mv shapeit5_phase_common snp-array-pipeline/tools/shapeit5_ref/resources/usr/bin/
```
{% endcode %}

{% code title="GLIMPSE2_ligate" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/GLIMPSE2_ligate_static
#change name removing the "_static" extension
mv GLIMPSE2_ligate_static GLIMPSE2_ligate
#copy the tool to the right folder
mv GLIMPSE2_ligate snp-array-pipeline/tools/ligate/resources/usr/bin/
```
{% endcode %}

#### Create applets

Compile the applets using the dx compile command:

```bash
dx build snp-array-pipeline/tools/impute5 -d ukb-imputation/apps/ -f 
dx build snp-array-pipeline/tools/shapeit5_ref -d ukb-imputation/apps/ -f 
dx build snp-array-pipeline/tools/xcftools -d ukb-imputation/apps/ -f 
dx build snp-array-pipeline/tools/ligate -d ukb-imputation/apps/ -f 
dx build snp-array-pipeline/snp-array-pipeline -d ukb-imputation/apps/ -f 
```

You should now see the applets appearing on the RAP in the apps folder.
