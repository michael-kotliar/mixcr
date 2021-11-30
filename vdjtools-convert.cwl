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

  clonotypes_file:
    type: File
    inputBinding:
      position: 5

  output_prefix:
    type: string?
    default: "results"
    inputBinding:
      position: 6


outputs:

  vdj_file:
    type: File?
    outputBinding:
      glob: $(inputs.output_prefix + "." + inputs.clonotypes_file.basename + ".gz")


baseCommand: ["vdjtools", "Convert", "--compress", "--software", "MiXcr"]

successCodes: [1]