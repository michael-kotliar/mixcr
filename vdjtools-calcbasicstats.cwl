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

  vdj_file:
    type: File
    inputBinding:
      position: 6

  output_prefix:
    type: string?
    default: "results"
    inputBinding:
      position: 7


outputs:
  
  basicstats_file:
    type: File?
    outputBinding:
      glob: "*.basicstats.txt"


baseCommand: ["vdjtools", "CalcBasicStats"]

successCodes: [1]