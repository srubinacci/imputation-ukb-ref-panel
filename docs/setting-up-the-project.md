---
description: Upload files and compile the applets on the RAP
---

# Setting up the project

### UK Biobank RAP

In order to run the tutorials, you need to be a registered UK Biobank researcher, have access to a reserach project and the research analysis platform. We also require you to have setup the [billing](https://documentation.dnanexus.com/admin/billing-and-account-management) for your project/account.&#x20;

The [DNAnexus SDK (`dx-toolkit`)](broken-reference) is required. Please download, install and setup the dx-toolkit as instructred by DNAnexus. A quick introduction on the dx-toolkit can be found [here](https://documentation.dnanexus.com/getting-started/cli-quickstart).

We first create a folder called <mark style="color:orange;">`apps`</mark> where all the applets will go. We create this folder on the home directiory:

```bash
dx cd
dx mkdir -p apps
```

### Download the repository

To get started, we first clone Github repository containing the pipelines. To do this run:

```bash
git clone https://github.com/srubinacci/imputation-ukb-ref-panel.git
```

We then move to the folder that we just created:

```bash
cd imputation-ukb-ref-panel
```

You have two folders here, one for the the low-coverage pipeline and one for the SNP array pipeline.

### Upload the resource data

Imputation pipelines are run in chunks and use the same map files.&#x20;



### Compile the low-coverage pipeline

There are three tools you need to download for the low-coverage pipeline:

* `GLIMPSE2_split_reference` - for converting the reference panel&#x20;
* `GLIMPSE2_phase` - for imputation and phasing
* `GLIMPSE2_ligate` - for the ligation step

#### Download the tools and copy them inside the right folder

You can download static binaries of the tools in the [release section on Github](https://github.com/odelaneau/GLIMPSE/releases) or copile your own static binaries. Download the files, remove the `*_static` extension from the filename and copy each program in the `resources/usr/bin/` of the appropriate tool:

<pre class="language-bash" data-title="GLIMPSE2_split_reference"><code class="lang-bash"><strong>#please change the address to the latest release. This is just an example.
</strong><strong>wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/GLIMPSE2_split_reference_static
</strong>#change name removing the "_static" extension
mv GLIMPSE2_split_reference_static GLIMPSE2_split_reference
#copy the tool in the right folder
mv GLIMPSE2_split_reference low-coverage-pipeline/tools/split_reference/resources/usr/bin/
</code></pre>

{% code title="GLIMPSE2_phase" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/GLIMPSE2_phase_static
#change name removing the "_static" extension
mv GLIMPSE2_phase_static GLIMPSE2_phase
#copy the tool in the right folder
mv GLIMPSE2_phase low-coverage-pipeline/tools/glimpse2_phase/resources/usr/bin/
```
{% endcode %}

{% code title="GLIMPSE2_ligate" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/GLIMPSE2_ligate_static
#change name removing the "_static" extension
mv GLIMPSE2_ligate_static GLIMPSE2_ligate
#copy the tool in the right folder
mv GLIMPSE2_ligate low-coverage-pipeline/tools/ligate/resources/usr/bin/
```
{% endcode %}

#### Create applets

Compile the applets using the dx compile command:

```bash
dx build low-coverage-pipeline/tools/split_reference -d apps/ -f 
dx build low-coverage-pipeline/tools/glimpse2_phase -d apps/ -f 
dx build low-coverage-pipeline/tools/ligate -d apps/ -f 
dx build low-coverage-pipeline/low-coverage-pipeline -d apps/ -f 
```

You should now see the applets appearing on the RAP in the apps folder.

### Compile the SNP array pipeline

There are three tools you need to download for the low-coverage pipeline:

* `XCFTOOLS` - for converting the reference panel&#x20;
* `SHAPEIT5_phase_common` - for converting the reference panel&#x20;
* `IMPUTE5` - for haploid SNP array imputation (>= v1.2)
* `GLIMPSE2_ligate` - for the ligation step

#### Download the tools and copy them inside the right folder

Several tools are used in this pipeline. Please download each of the tools separately. Keep in mind that IMPUTE5 is free only for academic use, please read the licence before using the software.&#x20;

* Static versions of XCFTOOLS and IMPUTE5 can be downloaded from the [IMPUTE5 website](https://jmarchini.org/software/#impute-5).
* SHAPEIT5\_phase\_common can be downloaded from the in the [release section on Github.](https://github.com/odelaneau/shapeit5/releases)
* GLIMPSE2\_ligate can be downloaded from the in the [release section on Github](https://github.com/odelaneau/GLIMPSE/releases).

Download the files, remove the `*_static` extension from the filename and copy each program in the `resources/usr/bin/` of the appropriate tool:

<pre class="language-bash" data-title="XCFTOOLS &#x26; IMPUTE5"><code class="lang-bash"><strong>#Download the latest version of the zip from https://jmarchini.org/software/#impute-5 
</strong>unzip impute5_v1.2.0.zip #change the version name accodingly
#change name removing the "_static" extension and versioning
mv impute5_v1.2.0/impute5_v1.2.0_static impute5_v1.2.0/impute5
mv impute5_v1.2.0/xcftools_static impute5_v1.2.0/xcftools
#copy the tools in the right folder
mv impute5_v1.2.0/impute5 snp-array-pipeline/tools/impute5/resources/usr/bin/
mv impute5_v1.2.0/xcftools snp-array-pipeline/tools/xcftools/resources/usr/bin/
</code></pre>

{% code title="SHAPEIT5_phase_common" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/shapeit5/releases/download/v5.1.1/phase_common_static
#change name removing the "_static" extension
mv phase_common_static shapeit5_phase_common
#copy the tool in the right folder
mv shapeit5_phase_common snp-array-pipeline/tools/shapeit5_ref/resources/usr/bin/
```
{% endcode %}

{% code title="GLIMPSE2_ligate" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/GLIMPSE2_ligate_static
#change name removing the "_static" extension
mv GLIMPSE2_ligate_static GLIMPSE2_ligate
#copy the tool in the right folder
mv GLIMPSE2_ligate snp-array-pipeline/tools/ligate/resources/usr/bin/
```
{% endcode %}

#### Create applets

Compile the applets using the dx compile command:

```bash
dx build snp-array-pipeline/tools/impute5 -d apps/ -f 
dx build snp-array-pipeline/tools/shapeit5_ref -d apps/ -f 
dx build snp-array-pipeline/tools/xcftools -d apps/ -f 
dx build snp-array-pipeline/tools/ligate -d apps/ -f 
dx build snp-array-pipeline/snp-array-pipeline -d apps/ -f 
```

You should now see the applets appearing on the RAP in the apps folder.
