#!/bin/bash
# GLIMPSE2_phase 0.0.1
# Generated by dx-app-wizard.
#
# Basic execution pattern: Your app will run on a single machine from
# beginning to end.
#
# Your job's input variables (if any) will be loaded as environment
# variables before this script runs.  Any array inputs will be loaded
# as bash arrays.
#
# Any code outside of main() (or any entry point you may add) is
# ALWAYS executed, followed by running the entry point itself.
#
# See https://documentation.dnanexus.com/developer for tutorials on how
# to modify this file.

main() {
    echo "Value of ref_bin: '$ref_bin'"
    echo "Value of tar_bcf: '$tar_bams'"
    echo "Value of fasta_ref: '$fasta_ref'"
    echo "Value of fasta_idx: '$fasta_ref'"
    echo "Value of out_pfx: '$out_pfx'"
    echo "Value of num_thr: '$num_thr'"
    echo "Value of imp_arg: '$imp_arg'"
    echo "Value of mount_inputs: '$mount_inputs'"
    

    # The following line(s) use the dx command-line tool to download your file
    # inputs to the local file system using variable names for the filenames. To
    # recover the original filenames, you can use the output of "dx describe
    # "$variable" --name".
    
    # Create a manifest file for dxfuse
    echo "{
      \"files\" : [],
      \"directories\" : [
        {
          \"proj_id\" : \"$DX_PROJECT_CONTEXT_ID\",
          \"folder\" : \"/\",
          \"dirname\" : \"/project\"
        }
      ]
    }" > dxfuse_manifest.json

    # Create a mount point for the project
    MOUNTDIR=/mnt
    mkdir -p $MOUNTDIR

    # Mount the current project
    echo "Using dxfuse version $(dxfuse -version)"
    dxfuse $MOUNTDIR /home/dnanexus/dxfuse_manifest.json

    if [ "$mount_inputs" == "true" ]; then
	dx-mount-all-inputs
    else
	dx-download-all-inputs --parallel
    fi
	
    if [ -n "$ref_bin" ]; then
    	ln -s ${ref_bin_path} ${ref_bin_name}
    fi
    
    if [ -n "$tar_bams" ]; then
    	ln -s ${tar_bams_path} ${tar_bams_name}
    fi
    
    if [ -n "$fasta_ref" ]; then
    	ln -s ${fasta_ref_path} ${fasta_ref_name}
    fi
    if [ -n "$fasta_idx" ]; then
    	ln -s ${fasta_idx_path} ${fasta_idx_name}
    fi
       
    /usr/bin/time -p -o ${out_pfx}.time GLIMPSE2_phase --reference ${ref_bin_name} --bam-list ${tar_bams_name} --output ${out_pfx}.bcf --log ${out_pfx}.log --fasta ${fasta_ref_name} --contigs-fai ${fasta_idx_name} --threads ${num_thr} ${imp_args}

    out_bcf=$(dx upload ${out_pfx}.bcf --brief)
    out_idx=$(dx upload ${out_pfx}.bcf.csi --brief)
    out_log=$(dx upload ${out_pfx}.log --brief)
    out_tim=$(dx upload ${out_pfx}.time --brief)
    

    # The following line(s) use the utility dx-jobutil-add-output to format and
    # add output variables to your job's output as appropriate for the output
    # class.  Run "dx-jobutil-add-output -h" for more information on what it
    # does.

    dx-jobutil-add-output out_bcf "$out_bcf" --class=file
    dx-jobutil-add-output out_idx "$out_idx" --class=file
    dx-jobutil-add-output out_log "$out_log" --class=file
    dx-jobutil-add-output out_tim "$out_tim" --class=file
}
