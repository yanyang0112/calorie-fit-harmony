# Calorie Fit Harmony

Calorie Fit Harmony 是一个基于 HarmonyOS / ArkTS 的日常饮食热量记录 App 原型，主题聚焦减脂期间的饮食管理。

项目保持轻量：用户可以记录每天吃了什么、摄入多少热量，应用会计算当天总摄入，并和用户设置的每日目标热量进行对比。数据默认保存在本地设备。

## 功能

- 记录食物名称、热量、餐次类型和日期。
- 展示今日摄入热量、每日目标热量和剩余热量。
- 支持删除今日饮食记录。
- 支持配置每日减脂目标热量。
- 支持查看历史日期记录。
- 支持最近七日摄入统计。
- 支持常用食物模板，一键加入今日记录。
- 支持维护当前体重、目标体重等减脂档案。
- 使用 HarmonyOS Preferences 做本地持久化。

## 手动验证建议

1. 打开应用，确认首页展示今日热量概览。
2. 新增一条早餐记录，例如 `鸡蛋` / `80`。
3. 返回首页，检查今日总热量是否更新。
4. 删除该记录，关闭并重新打开应用，检查记录是否仍被删除。
5. 尝试空食物名、负数热量等非法输入。
6. 在设置页修改每日目标热量，然后返回首页查看展示是否正确。
7. 进入历史页切换日期，检查不同日期记录是否互不混淆。
8. 进入统计页，检查最近七日平均热量和达标天数。
9. 进入常用食物页，使用模板快速加入今日记录。

## 项目结构

- `entry/src/main/ets/pages/Index.ets` - 首页
- `entry/src/main/ets/pages/AddFood.ets` - 添加饮食记录页
- `entry/src/main/ets/pages/Settings.ets` - 每日目标设置页
- `entry/src/main/ets/pages/History.ets` - 历史记录页
- `entry/src/main/ets/pages/Stats.ets` - 七日统计页
- `entry/src/main/ets/pages/Templates.ets` - 常用食物模板页
- `entry/src/main/ets/pages/GoalProfile.ets` - 减脂目标档案页
- `entry/src/main/ets/model/FoodRecord.ets` - 饮食记录数据模型
- `entry/src/main/ets/model/FoodTemplate.ets` - 常用食物模板模型
- `entry/src/main/ets/model/UserGoal.ets` - 用户目标档案模型
- `entry/src/main/ets/store/FoodStore.ets` - 饮食记录本地数据读写
- `entry/src/main/ets/store/TemplateStore.ets` - 常用食物模板读写
- `entry/src/main/ets/store/GoalStore.ets` - 用户目标档案读写
- `entry/src/main/ets/store/SummaryStore.ets` - 统计汇总逻辑

## 开发

使用 DevEco Studio 打开本项目根目录，同步依赖后，在 HarmonyOS 模拟器或真机上运行 `entry` 模块。
