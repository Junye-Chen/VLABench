# VLABench项目解释
VLABench 是一个大规模的语言条件机器人操作基准测试平台，专门用于长时程推理任务。这个项目的主要目标是：
## 项目核心特点：
多维度评估框架：提供了6个不同的评估轨道（tracks），从分布内泛化到跨任务泛化 

丰富的任务类型：包含基础操作任务（如选择水果、玩具）和复合任务（如烹饪、打牌）

语言条件控制：支持自然语言指令来控制机器人行为

模块化设计：采用灵活的模块化框架，便于扩展新任务
## 主要任务类型：
### 基础任务（Primitive Tasks）：
select_fruit：选择水果
select_toy：选择玩具
select_book：选择书籍
select_chemistry_tube：选择化学试管
add_condiment：添加调味料
### 复合任务（Composite Tasks）：
cook_dishes：烹饪菜肴
play_poker：打扑克
play_mahjong：打麻将
cluster_book：书籍分类

## 训练集数据来源
### 数据生成流程：
自动化轨迹生成：
使用 scripts/trajectory_generation.py 脚本
通过 dataset_generation.sh 批量生成
支持多进程并行生成以提高效率

专家技能序列：
每个任务都有预定义的专家技能序列
使用 SkillLib 类提供标准化的机器人操作技能
包括：pick（抓取）、place（放置）、lift（抬起）、pour（倾倒）等

数据收集过程：
```   # 核心数据生成逻辑
skill_seq = env.get_expert_skill_sequence()  # 获取专家技能序列
for skill in skill_seq:
    obs, waypoint, stage_success, task_success = skill(env)  # 执行技能
    observations.extend(obs)  # 收集观察数据
    waypoints.extend(waypoint)  # 收集轨迹点
```
### 数据格式和内容：
HDF5格式存储：
    观察数据：RGB图像、点云、深度图等
    轨迹数据：机器人末端执行器的位置和姿态
    元信息：目标实体、指令文本、场景配置
    视频记录：任务执行过程的视频文件
    
数据结构：
```
data_to_save = {
    "trajectory": robot_frame_waypoints,  # 机器人坐标系下的轨迹
    "entities": meta_info["entities"],    # 场景中的实体
    "target_entity": meta_info["target_entity"],  # 目标实体
    "episode_config": json.dumps(episode_config),  # 场景配置
    "instruction": meta_info["instruction"]  # 自然语言指令
}
```
### 数据多样性来源：
1. 物体多样性：
每个任务都有"seen_object"（训练时见过的物体）和"unseen_object"（未见过的物体）
支持跨类别和跨实例的泛化测试

2. 场景随机化：
- 物体位置随机化
- 纹理和背景变化
- 光照条件变化

3. 指令多样性：
空间关系指令（"选择左边的苹果"）
常识推理指令（"选择最甜的水果"）
语义复杂指令（"选择适合做沙拉的水果"）

### 数据转换和评估：
项目支持将HDF5格式转换为其他框架使用的格式：
RLDS格式：用于Octo、OpenVLA等框架
Lerobot格式：用于OpenPI等框架

### 评估数据集：
项目提供了标准化的评估数据集：
原始任务微调数据集：包含10个基础任务，每个任务500个样本
VLM评估数据集：用于评估视觉语言模型的理解能力
这个项目通过自动化的数据生成流程，创建了大规模、多样化的机器人操作数据集，为训练和评估语言条件机器人系统提供了重要的基准测试平台。