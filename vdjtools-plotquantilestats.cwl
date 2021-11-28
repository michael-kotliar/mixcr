class: CommandLineTool
cwlVersion: v1.1


requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: yyasumizu/vdjtools
  

inputs:

  top:
    type: int?
    inputBinding:
      prefix: "--top"
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

  qstat_file:
    type: File
    outputBinding:
      glob: "*.qstat.txt"

  qstat_pdf:
    type: File
    outputBinding:
      glob: "*.qstat.pdf"


baseCommand: ["vdjtools", "PlotQuantileStats"]