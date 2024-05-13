#!/bin/bash

gpu_list="${CUDA_VISIBLE_DEVICES:-0}"
IFS=',' read -ra GPULIST <<< "$gpu_list"

CHUNKS=${#GPULIST[@]}


for IDX in $(seq 0 $((CHUNKS-1))); do
    CUDA_VISIBLE_DEVICES=${GPULIST[$IDX]} python -m chat \
        --json-path lvis/lvis_v1_val.json \
        --image-path coco/train2017 \
        --output-path lvis/lvis_v1_val_phrase.jsonl \
        --type lvis \
        --num-chunks $CHUNKS \
        --chunk-idx $IDX &
done

wait

output_file=./lvis/lvis_v1_val_phrase.jsonl

# Clear out the output file if it exists.
> "$output_file"

# Loop through the indices and concatenate each file.
for IDX in $(seq 0 $((CHUNKS-1))); do
    cat ./lvis/lvis_v1_val_phrase_${CHUNKS}_${IDX}.jsonl >> "$output_file"
done



# for IDX in $(seq 0 $((CHUNKS-1))); do
#     CUDA_VISIBLE_DEVICES=${GPULIST[$IDX]} python -m chat \
#         --split test \
#         --num-chunks $CHUNKS \
#         --chunk-idx $IDX &
# done

# wait

# output_file=./lvis/panoptic_phrase.jsonl

# # Clear out the output file if it exists.
# > "$output_file"

# # Loop through the indices and concatenate each file.
# for IDX in $(seq 0 $((CHUNKS-1))); do
#     cat ./coco_segm_text/test/panoptic_phrase_${CHUNKS}_${IDX}.jsonl >> "$output_file"
# done

# wait

# for IDX in $(seq 0 $((CHUNKS-1))); do
#     CUDA_VISIBLE_DEVICES=${GPULIST[$IDX]} python -m chat \
#         --split unlabeled \
#         --num-chunks $CHUNKS \
#         --chunk-idx $IDX &
# done

# wait

# output_file=./coco_segm_text/unlabeled/panoptic_phrase.jsonl

# # Clear out the output file if it exists.
# > "$output_file"

# # Loop through the indices and concatenate each file.
# for IDX in $(seq 0 $((CHUNKS-1))); do
#     cat ./coco_segm_text/unlabeled/panoptic_phrase_${CHUNKS}_${IDX}.jsonl >> "$output_file"
# done

# wait