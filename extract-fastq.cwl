cwlVersion: v1.1
class: CommandLineTool


requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  ramMin: 3814
  coresMin: 2

hints:
- class: DockerRequirement
  dockerPull: biowardrobe2/scidap:v0.0.3


inputs:

  script:
    type: string?
    default: |
      #!/bin/bash
      shopt -s nocaseglob
      set -- "$0" "$@"

      function extract {
        FILE=$1
        COMBINED=$2
        T=`file -b "${FILE}" | awk '{print $1}'`
        case "${T}" in
          "bzip2"|"gzip"|"Zip")
            7z e -so "${FILE}" >> "${COMBINED}"
            ;;
          "ASCII")
            cat "${FILE}" >> "${COMBINED}" || true
            ;;
          *)
            echo "Error: file type unknown"
            rm -f "${COMBINED}"
            exit 1
        esac
      } 
      
      COMBINED=""
      for FILE in "$@"; do
          BASENAME=$(basename "$FILE")
          ROOTNAME="${BASENAME%.*}"
          EXT_LIST=( ".fastq" ".fq" )
          for ITEM in $EXT_LIST; do
            if [[ $ROOTNAME == *$ITEM ]]; then
              ROOTNAME="${ROOTNAME%.*}"
            fi
          done
          if [[ $COMBINED == "" ]]; then
            COMBINED="${ROOTNAME}"
          else
            COMBINED="${COMBINED}"_"${ROOTNAME}"
          fi
      done
      COMBINED="${COMBINED}".fastq

      for FILE in "$@"; do
          echo "Extracting:" $FILE;
          extract "${FILE}" "${COMBINED}"
      done;

    inputBinding:
      position: 5
    doc: |
      Bash script to extract compressed FASTQ file

  compressed_file:
    type:
    - File
    - type: array
      items: File
    inputBinding:
      position: 6
    doc: |
      Compressed or uncompressed FASTQ file(s)


outputs:

  fastq_file:
    type: File
    outputBinding:
      glob: "*"

baseCommand: [bash, '-c']