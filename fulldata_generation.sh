#!/bin/bash

N_SAMPLE=10
OFFSET=0
save_dir="dataset/trajectory"

while IFS= read -r task_name || [[ -n "$task_name" ]]; do
    if [[ -z "$task_name" ]]; then
        continue
    fi
    echo "Running tasks for: $task_name"
    cmd="python scripts/trajectory_generation.py --task-name $task_name --n-sample $N_SAMPLE --start-id $OFFSET --save-dir $save_dir"
    echo "Starting: $cmd"
    $cmd
    echo "Completed tasks for: $task_name"
done < processed_note.txt

echo "All processes for all tasks have completed."



