---
description: Pipeline-specific data upload and applets compilation
---

# Setting up the low-coverage pipeline

## 1. Upload project-specific data

### 1.1. Chunk files

Pre-computed chunks of \~4 cM length can be uploaded using:

<pre><code><strong>dx upload -r data/chunks/glimpse2/* --path ukb-imputation/glimpse2/chunks/
</strong></code></pre>

### 1.2. GRCh38 reference genome

The reference genome in b38 is necessary to process CRAM files. We download it from 1000 Genomes EBI ftp server and upload it on the RAP in the expected folder:

```bash
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa &&
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa.fai &&
dx upload GRCh38_full_analysis_set_plus_decoy_hla.fa --path ukb-imputation/glimpse2/ref_genome/ &&
dx upload GRCh38_full_analysis_set_plus_decoy_hla.fa.fai --path ukb-imputation/glimpse2/ref_genome/
echo "Reference genome successfully uploaded"
```

#### **1.2.1 Faster (but manual) alternative to wget / dx upload**

Downloading data from the EBI ftp server might be slow outside the UK. However, as the UK Biobank RAP is located in London, we can download the file directly on the RAP. To do that you can use the ttyd app for an interactive session, or alternatively use the url\_fetcher app. Here we quickly describe how to use this second option.

To use the url\_fetcher app, just browse in Tool library -> URL Fetcher -> Run. The output destination needs to be the expected path: `ukb-imputation/glimpse2/ref_genome/`.&#x20;

Put the URL (indicated above) in the right textbox. No need to fill in the optional file name. When you are ready, press "Start Analysis" on the top right. When the job ends, the file will be found in the right location. Finally, repeat this step for the .fai index.

***

## 2. Compile the low-coverage pipeline

There are three tools you need to download for the low-coverage pipeline:

* `GLIMPSE2_split_reference` - for converting the reference panel&#x20;
* `GLIMPSE2_phase` - for imputation and phasing
* `GLIMPSE2_ligate` - for the ligation step

### 2.1. Download the tools and copy them inside the right folder

You can download static binaries of the tools in the [release section on Github](https://github.com/odelaneau/GLIMPSE/releases) or compile your own static binaries. Download the files, remove the `*_static` extension from the filename, and copy each program into the folder `resources/usr/bin/` of the appropriate tool:

<pre class="language-bash" data-title="GLIMPSE2_split_reference"><code class="lang-bash"><strong>#please change the address to the latest release. This is just an example.
</strong><strong>wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/GLIMPSE2_split_reference_static &#x26;&#x26;
</strong>#change name removing the "_static" extension
mv GLIMPSE2_split_reference_static GLIMPSE2_split_reference &#x26;&#x26;
#permissions
chmod 777 GLIMPSE2_split_reference &#x26;&#x26;
#copy the tool to the right folder
mv GLIMPSE2_split_reference low-coverage-pipeline/tools/glimpse2_split_reference/resources/usr/bin/ &#x26;&#x26;
echo "Files successfully copied"
</code></pre>

{% code title="GLIMPSE2_phase" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/GLIMPSE2_phase_static &&
#change name removing the "_static" extension
mv GLIMPSE2_phase_static GLIMPSE2_phase &&
#permissions
chmod 777 GLIMPSE2_phase &&
#copy the tool to the right folder
mv GLIMPSE2_phase low-coverage-pipeline/tools/glimpse2_phase/resources/usr/bin/ &&
echo "Files successfully copied"
```
{% endcode %}

{% code title="GLIMPSE2_ligate" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/GLIMPSE2_ligate_static &&
#change name removing the "_static" extension
mv GLIMPSE2_ligate_static GLIMPSE2_ligate &&
#permissions
chmod 777 GLIMPSE2_ligate &&
#copy the tool to the right folder
mv GLIMPSE2_ligate low-coverage-pipeline/tools/glimpse2_ligate/resources/usr/bin/ &&
echo "Files successfully copied"
```
{% endcode %}

### 2.2. Create applets

Compile the applets using the dx compile command:

{% code title="Build applets on the RAP" %}
```bash
dx build low-coverage-pipeline/tools/glimpse2_split_reference -d ukb-imputation/apps/ -f  &&
dx build low-coverage-pipeline/tools/glimpse2_phase -d ukb-imputation/apps/ -f &&
dx build low-coverage-pipeline/tools/glimpse2_ligate -d ukb-imputation/apps/ -f &&
dx build low-coverage-pipeline/low-coverage-pipeline -d ukb-imputation/apps/ -f &&
echo "Applets successfully uploaded"
```
{% endcode %}

You should now see the applets appearing on the RAP in the apps folder. Dx build will inform you if you are overwriting previously compiled applets with the same name. The -f option above will overwrite any existing applet file.

