# FFPA_nextflow
This repository contains the nextflow implementation of the Full Force Plasmid Assembler Pipeline

The original Full Force Plasmid Assembler Pipeline can be found here: https://github.com/MBHallgren/FullForcePlasmidAssembler

The original pipeline was written in Python and used docker for the software that was need to run this pipeline.

This rewrite uses the same docker images as the original pipeline but it is implement the usage through singularity and the workflow is controlled using Nextflow. The reason for doing that is that we want to be able to use it on a HPC cluster (Saga)

