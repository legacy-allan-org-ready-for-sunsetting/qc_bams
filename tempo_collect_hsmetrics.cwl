class: Workflow
cwlVersion: v1.0
id: run_collect_hsmetrics
label: run_collect_hsmetrics

inputs:
  bam:
    type: File
    secondaryFiles:
      - ^.bai

  reference_sequence:
    type: File
    secondaryFiles:
      - .fai
      - ^.dict

  targets_list:
    type: File[]

  baits_list:
    type: File[]
   
outputs:
  hsmetrics:
    type: File[]?
    outputSource: collect_hsmetrics/out_file
 
steps:
  collect_hsmetrics:
    in:
      BI: baits_list
      TI: targets_list
      I: bam
      REFERENCE_SEQUENCE: reference_sequence
      O:
        valueFrom: ${ return inputs.I.basename.replace(".bam", ".hs_metrics.txt") }
    out: [ out_file ]
    scatter: [ BI, TI ]
    scatterMethod: dotproduct
    run: command_line_tools/gatk_4.1.0.0/gatk_collect_hs_metrics.cwl

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
