class: Workflow
cwlVersion: v1.0
id: run_alfred
label: run_alfred

inputs:
  bam:
    type: File
    secondaryFiles:
      - ^.bai
      - .bai

  reference_sequence:
    type: File

  bed:
    type: File?
    secondaryFiles:
      - .tbi
 
outputs:
  bam_qc_alfred_rg:
    type: File?
    outputSource: run_alfred_rg/output

  bam_qc_alfred_ignore_rg:
    type: File?
    outputSource: run_alfred_ignore_rg/output

  bam_qc_alfred_rg_pdf:
    type: File?
    outputSource: run_alfred_rg/output_pdf

  bam_qc_alfred_ignore_rg_pdf:
    type: File?
    outputSource: run_alfred_ignore_rg/output_pdf
  
steps:
  run_alfred_rg:
    in:
      bam: bam
      reference: reference_sequence
      bed: bed
    out: [ output, output_pdf ]
    run: command_line_tools/alfred_0.1.17/alfred_0.1.17.cwl

  run_alfred_ignore_rg:
    in:
      bam: bam
      reference: reference_sequence
      bed: bed
      ignore_rg:
        valueFrom: ${ return true; }
    out: [ output, output_pdf ]
    run: command_line_tools/alfred_0.1.17/alfred_0.1.17.cwl

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
