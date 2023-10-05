---
description: Pipeline-specific data upload and applets compilation
---

# Setting up the SNP array pipeline

## 1. Upload project-specific data

### 1.1. Chunk files

Pre-computed chunks of \~40 cM length can be uploaded using:

<pre><code><strong>dx upload -r data/chunks/impute5/* --path ukb-imputation/impute5/chunks/
</strong></code></pre>

***

## 2. Compile the SNP array pipeline

There are three tools you need to download for the low-coverage pipeline:

* `XCFTOOLS` - for converting the reference panel
* `SHAPEIT5_phase_common` - for converting the reference panel
* `IMPUTE5` - for haploid SNP array imputation (>= v1.2)
* `GLIMPSE2_ligate` - for the ligation step

### **2.1. Download the tools and copy them inside the right folder**

Several tools are used in this pipeline. Please download each of the tools separately. Keep in mind that IMPUTE5 is free only for academic use, please read the license before using the software.

* A static version of IMPUTE5 can be downloaded from the [IMPUTE5 website](https://jmarchini.org/software/#impute-5).
* A static version of XCFTOOLS can be downloaded from the [release section on GitHub.](https://github.com/odelaneau/xcftools/releases) Please refer to the latest version on GitHub rather than the version included in the IMPUTE5 zip, as updates and bug fixes will be added on the GitHub release, but might not be promptly propagated on the IMPUTE5 release.
* SHAPEIT5\_phase\_common can be downloaded from the [release section on GitHub.](https://github.com/odelaneau/shapeit5/releases)
* GLIMPSE2\_ligate can be downloaded from the [release section on GitHub](https://github.com/odelaneau/GLIMPSE/releases).

Download the files, remove the `*_static` extension from the filename and copy each program in the `resources/usr/bin/` of the appropriate tool:

<pre class="language-bash" data-title="IMPUTE5 v1.2"><code class="lang-bash"><strong>#Download the latest version of the zip from https://jmarchini.org/software/#impute-5 
</strong>unzip impute5_v1.2.0.zip #change the version name accodingly
#change name removing the "_static" extension and versioning
mv impute5_v1.2.0/impute5_v1.2.0_static impute5_v1.2.0/impute5
#permissions
chmod 777 impute5_v1.2.0/impute5
#copy the tools in the right folder
mv impute5_v1.2.0/impute5 snp-array-pipeline/tools/impute5/resources/usr/bin/
#cleanup local folder from temporary files
rm -rf impute5_v1.2.0/ impute5_v1.2.0.zip __MACOSX/
</code></pre>

{% code title="XCFTOOLS" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/xcftools/releases/download/v0.1.0/xcftools_static
#change name removing the "_static" extension
mv xcftools_static xcftools
#permissions
chmod 777 xcftools
#copy the tools in the right folder
mv xcftools snp-array-pipeline/tools/xcftools/resources/usr/bin/
```
{% endcode %}

{% code title="SHAPEIT5_phase_common" %}
```bash
#please change the address to the latest release. This is just an example.
wget https://github.com/odelaneau/shapeit5/releases/download/v5.1.1/phase_common_static
#change name removing the "_static" extension
mv phase_common_static shapeit5_phase_common
#permissions
chmod 777 shapeit5_phase_common
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
#permissions
chmod 777 GLIMPSE2_ligate
#copy the tool in the right folder
mv GLIMPSE2_ligate snp-array-pipeline/tools/ligate/resources/usr/bin/
```
{% endcode %}

### **2.2. Create applets**

Compile the applets using the dx compile command:

```
dx build snp-array-pipeline/tools/impute5 -d ukb-imputation/apps/ -f 
dx build snp-array-pipeline/tools/shapeit5_ref -d ukb-imputation/apps/ -f 
dx build snp-array-pipeline/tools/xcftools -d ukb-imputation/apps/ -f 
dx build snp-array-pipeline/tools/ligate -d ukb-imputation/apps/ -f 
dx build snp-array-pipeline/snp-array-pipeline -d ukb-imputation/apps/ -f 
```

You should now see the applets appearing on the RAP in the apps folder.

