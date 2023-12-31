#!/bin/bash
# GLIMPSE2_ligate 0.0.1
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

    echo "Value of inp_pfx: '$inp_pfx'"
    echo "Value of out_pfx: '$out_pfx'"
    echo "Value of num_thr: '$num_thr'"

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

    ls -1v /mnt/project/${inp_pfx}*.bcf > list.txt
    
    GLIMPSE2_ligate --input list.txt --output ${out_pfx}.bcf --threads ${num_thr}
    
    out_bcf=$(dx upload ${out_pfx}.bcf --brief)
    out_idx=$(dx upload ${out_pfx}.bcf.csi --brief)

    # The following line(s) use the utility dx-jobutil-add-output to format and
    # add output variables to your job's output as appropriate for the output
    # class.  Run "dx-jobutil-add-output -h" for more information on what it
    # does.

    dx-jobutil-add-output out_bcf "$out_bcf" --class=file
    dx-jobutil-add-output out_idx "$out_idx" --class=file
}
