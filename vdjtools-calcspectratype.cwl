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

  unweighted:
    type: boolean?
    inputBinding:
      prefix: "--unweighted"
      position: 5

  amino_acid:
    type: boolean?
    inputBinding:
      prefix: "--amino-acid"
      position: 6

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
  
  spectratype_files:
    type: File[]
    outputBinding:
      glob: "*"


baseCommand: ["vdjtools", "CalcSpectratype"]