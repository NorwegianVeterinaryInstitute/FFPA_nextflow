# FFPA nextflow
This repository contains the nextflow implementation of the Full Force Plasmid Assembler Pipeline as found here: https://github.com/MBHallgren/FullForcePlasmidAssembler

The original FFPA pipeline was written in python and uses Docker containers. On stand alone machines with docker installed it can be used as it is. However, for High performance computing environments it is often not possible to use docker. There it is required to use singularity. Singularity is able to use docker images as they are. In combination with nextflow we implemented the FFPA pipeline as a nextflow pipeline (DSL2), that used when possible the original docker containers via singularity. Some docker containers did not work in our hands, and in those cases we create a new singularity container to use the tools.

### Containers used in this implementation

|Original container| Used container | Docker or Singularity | Tool version
----- |----- |----- |----- |
nanozoo/nanoplot |nanozoo/nanoplot |docker | 1.32.0
nanozoo/fastqc |nanozoo/fastqc | docker  | latest
mcfonsecalab/qcat |mcfonsecalab/qcat | docker | latest
mcfonsecalab/nanofilt |mcfonsecalab/nanofilt | docker |latest
nanozoo/unicycler | unicycler_NVI_0.4.8.sif | singularity | 0.4.8
replikation/abricate | replikation/abricate | docker | latest
flowcraft/kraken | kraken_NVI_1.1.1.sif | singularity | 1.1.1
fjukstad/trimmomatic | trimmomatic_NVI_0.38.sif | sigularity | 0.38

 __NOTE:__ The singularity containers were build starting with a docker container, and miniconda installed. Miniconda was used to install the tool on the docker container, using a dockerfile. The resulting docker archive was used to build a singularity container. The exact workflow and dockerfiles can be found here: https://github.com/NorwegianVeterinaryInstitute/nextflow_singularity/tree/main/container_images

 ### How to use this pipeline.

 The pipeline can be downloaded from the repository as it is. The docker containers will be installed using the first run of the workflow. The singularity containers should be created as described in the above link. And the paths to these images should be added to the module files. We are investigating if we can upload these images to a docker / sigularity hub, where we can then use them by specifying.

 The pipeline folder contains the following:
* `fullforce.sh`  - The script to run the pipeline
* `main.nf` - The nextflow file with the pipeline workflow
* `main.config` - The main configuration for the pipeline which needs to be edited for each new analysis
* `nextflow.config` - The nextflow configuration for the slurm execution to run the pipeline of a HPC cluster
* `modules` - This folder contains the module files for the different processes used in the pipeline.
* `README.md` - This document.

#### Setting up the pipeline.

 * Make sure Nextflow is installed and available in your `$PATH`
 * Copy the entire pipeline to a folder in your current analysis project.
 * Modify the `main.config` file and specifiy:

  - location of illumina reads:  `params.reads`
  - location of nanopore reads:  `params.longreads`
  - location of Kraken database: `params.kraken1.dir`
  - name of kraken version 1 database:     `params.kraken1.db`
  - Location of Trimmomatic adapters fasta files: `params.adapter_dir`
  - which adapters were used: `params.adapters`

* Then run the pipeline with the command:

  ```
  ./fullforce.sh main.config $YOUR_OUTPUT_DIRECTORY
  ```

#### When there is an error
If you are running this on a cluster where the parameter $USERWORK is available,
then you can find the process directories of the workflows in the folder:

  ```
  $USERWORK/fullforce/
  ```
  If this parameter is not available, than the workdirectory `fullforce` is present in the directory where you started the workflow. You can modify the location by modifying it in the script: `fullforce.sh`.
