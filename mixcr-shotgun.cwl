class: CommandLineTool
cwlVersion: v1.1


requirements:
- class: DockerRequirement
  dockerPull: milaboratory/mixcr:3.0.13
- class: ResourceRequirement
  ramMin: 15258
  coresMin: 12
- class: InlineJavascriptRequirement
  expressionLib:
  - var default_output_prefix = function() {
          if (inputs.output_prefix == ""){
            var root = inputs.fastq_file.basename.split('.').slice(0,-1).join('.');
            return (root == "")?inputs.fastq_file.basename:root;
          } else {
            return inputs.output_prefix;
          }
        };


inputs:

  species:
    type:
    - type: enum
      symbols:
      - "hsa"
      - "mmu"
      - "rat"
    inputBinding:
      prefix: "--species"
      position: 5

  starting_material:
    type:
    - type: enum
      symbols:
      - "rna"
      - "dna"
    inputBinding:
      prefix: "--starting-material"
      position: 6

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
    inputBinding:
      prefix: "--receptor-type"
      position: 7
    doc: "xcr by default - all T-cell and B-cell receptor chains are analyzed"

  contig_assembly:
    type: boolean?
    inputBinding:
      prefix: "--contig-assembly"
      position: 8

  impute_germline_on_export:
    type: boolean?
    inputBinding:
      prefix: "--impute-germline-on-export"
      position: 9

  only_productive:
    type: boolean?
    inputBinding:
      prefix: "--only-productive"
      position: 10

  assemble_partial_rounds:
    type: int?
    inputBinding:
      prefix: "--assemble-partial-rounds"
      position: 11
    doc: "2 by default"

  do_not_extend_alignments:
    type: boolean?
    inputBinding:
      prefix: "--do-not-extend-alignments"
      position: 12

  threads:
    type: int?
    inputBinding:
      prefix: "--threads"
      position: 13

  fastq_file:
    type:
    - File
    - type: array
      items: File
    inputBinding:
      position: 14

  output_prefix:
    type: string?
    default: ""
    inputBinding:
      valueFrom: $(default_output_prefix())
      position: 15


outputs:

  all_clonotypes_file:
    type: File
    outputBinding:
      glob: $(default_output_prefix() + ".clonotypes.ALL.txt")

  report_file:
    type: File
    outputBinding:
      glob: $(default_output_prefix() + ".report")


baseCommand: ["mixcr", "analyze", "shotgun"]