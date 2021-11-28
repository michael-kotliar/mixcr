class: CommandLineTool
cwlVersion: v1.1


requirements:
- class: InlineJavascriptRequirement
- class: ResourceRequirement
  ramMin: 3814
  coresMin: 2
- class: DockerRequirement
  dockerPull: yyasumizu/vdjtools
  

inputs:

  intersect_type:
    type: string?
    inputBinding:
      prefix: "--intersect-type"
      position: 5

  downsample_to:
    type: int?
    inputBinding:
      prefix: "--downsample-to"
      position: 6

  extrapolate_to:
    type: int?
    inputBinding:
      prefix: "--extrapolate-to"
      position: 7

  resample_trials:
    type: int?
    inputBinding:
      prefix: "--resample-trials"
      position: 8

  vdj_file:
    type: File
    inputBinding:
      position: 7

  output_prefix:
    type: string?
    default: "results"
    inputBinding:
      position: 8


outputs:

  diversity_files:
    type: File[]
    outputBinding:
      glob: "*"


baseCommand: ["vdjtools", "CalcDiversityStats"]