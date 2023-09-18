---
description: Pipeline-specific data upload and app compilation
---

# Setting up the SNP array pipeline

## 1. Upload project-specific data

### 1.1. Chunk files

Pre-computed chunks of \~40 cM length can be uploaded using:

<pre><code><strong>dx upload -r data/chunks/impute5/* --path ukb-imputation/impute5/chunks/
</strong></code></pre>

***

## 2. Compile the low-coverage pipeline

There are three tools you need to download for the low-coverage pipeline:

* `GLIMPSE2_split_reference` - for converting the reference panel&#x20;
* `GLIMPSE2_phase` - for imputation and phasing
* `GLIMPSE2_ligate` - for the ligation step

### 2.1. Download the tools and copy them inside the right folder

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

### 2.2. Create applets

Compile the applets using the dx compile command:

```bash
dx build low-coverage-pipeline/tools/split_reference -d ukb-imputation/apps/ -f 
dx build low-coverage-pipeline/tools/glimpse2_phase -d ukb-imputation/apps/ -f 
dx build low-coverage-pipeline/tools/ligate -d ukb-imputation/apps/ -f 
dx build low-coverage-pipeline/low-coverage-pipeline -d ukb-imputation/apps/ -f 
```

You should now see the applets appearing on the RAP in the apps folder. You are all set and can run the pipeline!

