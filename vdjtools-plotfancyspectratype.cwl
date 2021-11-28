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
  
  fancyspectra_file:
    type: File
    outputBinding:
      glob: "*.fancyspectra.txt"

  fancyspectra_pdf:
    type: File
    outputBinding:
      glob: "*.fancyspectra.pdf"


baseCommand: ["vdjtools", "PlotFancySpectratype"]