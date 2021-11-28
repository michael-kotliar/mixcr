class: Workflow
cwlVersion: v1.1


requirements:
  - class: SubworkflowFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement


inputs:

  fastq_file_r1:
    type: File

  fastq_file_r2:
    type: File

  species:
    type:
    - type: enum
      symbols:
      - "hsa"
      - "mmu"
      - "rat"

  starting_material:
    type:
    - type: enum
      symbols:
      - "rna"
      - "dna"

  receptor_type:
    type:
    - "null"
    - type: enum
      symbols:
      - "xcr"
      - "tcr"
      - "bcr"
      - "tra"
      - "trb"
      - "trg"
      - "trd"
      - "igh"
      - "igk"
      - "igl"

  contig_assembly:
    type: boolean?

  impute_germline_on_export:
    type: boolean?

  only_productive:
    type: boolean?

  assemble_partial_rounds:
    type: int?

  do_not_extend_alignments:
    type: boolean?

  unweighted:
    type: boolean?

  amino_acid:
    type: boolean?

  top:
    type: int?

  intersect_type:
    type: string?

  downsample_to:
    type: int?

  extrapolate_to:
    type: int?

  resample_trials:
    type: int?

  threads:
    type: int?


outputs:

  all_clonotypes_file:
    type: File
    outputSource: mixcr_shotgun/all_clonotypes_file

  report_file:
    type: File
    outputSource: mixcr_shotgun/report_file

  vdj_file:
    type: File
    outputSource: vdjtools_convert/vdj_file

  basicstats_file:
    type: File
    outputSource: vdjtools_calcbasicstats/basicstats_file

  spectratype_files:
    type: File[]
    outputSource: vdjtools_calcspectratype/spectratype_files

  fancyspectra_file:
    type: File
    outputSource: vdjtools_plotfancyspectratype/fancyspectra_file

  fancyspectra_pdf:
    type: File
    outputSource: vdjtools_plotfancyspectratype/fancyspectra_pdf
  
  diversity_files:
    type: File[]
    outputSource: vdjtools_calcdiversitystats/diversity_files

  qstat_file:
    type: File
    outputSource: vdjtools_plotquantilestats/qstat_file

  qstat_pdf:
    type: File
    outputSource: vdjtools_plotquantilestats/qstat_pdf


steps:

  extract_fastq_file_r1:
    run: ./extract-fastq.cwl
    in:
      compressed_file: fastq_file_r1
    out:
    - fastq_file

  extract_fastq_file_r2:
    run: ./extract-fastq.cwl
    in:
      compressed_file: fastq_file_r2
    out:
    - fastq_file

  trim_adapters:
    run: ./trimgalore.cwl
    in:
      input_file: extract_fastq_file_r1/fastq_file
      input_file_pair: extract_fastq_file_r2/fastq_file
      dont_gzip:
        default: true
      length:
        default: 20
      paired:
        default: true
    out:
      - trimmed_file
      - trimmed_file_pair
      - report_file
      - report_file_pair
    
  mixcr_shotgun:
    in:
      species: species
      fastq_file:
        source: [trim_adapters/trimmed_file, trim_adapters/trimmed_file_pair]
      starting_material: starting_material
      receptor_type: receptor_type
      contig_assembly: contig_assembly
      impute_germline_on_export: impute_germline_on_export
      only_productive: only_productive
      assemble_partial_rounds: assemble_partial_rounds
      do_not_extend_alignments: do_not_extend_alignments
      threads: threads
    out:
    - all_clonotypes_file
    - report_file
    run: ./mixcr-shotgun.cwl

  vdjtools_convert:
    in:
      clonotypes_file: mixcr_shotgun/all_clonotypes_file
    out:
    - vdj_file
    run: ./vdjtools-convert.cwl

  vdjtools_calcbasicstats:
    in:
      vdj_file: vdjtools_convert/vdj_file
      unweighted: unweighted
    out:
    - basicstats_file
    run: ./vdjtools-calcbasicstats.cwl

  vdjtools_calcspectratype:
    in:
      vdj_file: vdjtools_convert/vdj_file
      unweighted: unweighted
      amino_acid: amino_acid
    out:
    - spectratype_files
    run: ./vdjtools-calcspectratype.cwl

  vdjtools_plotfancyspectratype:
    in:
      vdj_file: vdjtools_convert/vdj_file
      top: top
    out:
    - fancyspectra_file
    - fancyspectra_pdf
    run: ./vdjtools-plotfancyspectratype.cwl

  vdjtools_calcdiversitystats:
    in:
      vdj_file: vdjtools_convert/vdj_file
      intersect_type: intersect_type
      downsample_to: downsample_to
      extrapolate_to: extrapolate_to
      resample_trials: resample_trials
    out:
    - diversity_files
    run: ./vdjtools-calcdiversitystats.cwl

  vdjtools_plotquantilestats:
    in:
      vdj_file: vdjtools_convert/vdj_file
      top: top
    out:
    - qstat_file
    - qstat_pdf
    run: ./vdjtools-plotquantilestats.cwl