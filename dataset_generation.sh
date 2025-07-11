#!/bin/bash

N_SAMPLE=5
OFFSET=0

# hang_picture_on_specific_nail
task_names=("select_drink_common_sense")  # add more task here "select_fruit"
save_dir="dataset/trajectory"

for task_name in "${task_names[@]}"; do # add more process here
    commands=(
        "python scripts/trajectory_generation.py --task-name $task_name --n-sample $N_SAMPLE --start-id $((0 * N_SAMPLE + OFFSET)) --save-dir $save_dir"
        # "python scripts/trajectory_generation.py --task-name $task_name --n-sample $N_SAMPLE --start-id $((1 * N_SAMPLE + OFFSET)) --save-dir $save_dir"
    )

    echo "Running tasks for: $task_name"

    for cmd in "${commands[@]}"; do
        echo "Starting: $cmd"
        $cmd &
    done

    wait  # 等待当前任务名称的所有命令执行完成
    echo "Completed tasks for: $task_name"
done

echo "All processes for all tasks have completed."

for task_name in "${task_names[@]}"; do
    vlc dataset/trajectory/${task_name}/demo_${OFFSET}_success_True.mp4 &
done
