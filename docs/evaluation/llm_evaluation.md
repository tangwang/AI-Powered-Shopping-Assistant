# LLM 评估方案（测试驱动）

## 1. 为什么要先评估

本项目大量依赖 LLM，结果具备随机性，必须通过“评估脚本 + 评估集”保证可回归。

## 2. 评估对象

1. **Orchestrator 输出质量**
   - 是否正确提取槽位
   - 是否合理判断缺口
   - 工具计划是否必要且克制

2. **Assistant 回复质量**
   - 是否“有价值 + 不机械”
   - 是否包含合适追问（最多2问）
   - 是否做到推荐与引导平衡

3. **搜索结果整理质量**
   - 满足度判断是否准确
   - query 改写是否提升召回
   - 精选商品是否匹配意图

## 3. 指标建议

- Intent Slot F1
- Gap Precision/Recall
- Tool Plan Accuracy
- Response Helpfulness（LLM-as-judge）
- Response Naturalness（LLM-as-judge）
- Search Satisfaction Rate

## 4. 评估数据集建议

- `evaluation/datasets/orchestrator_cases.jsonl`
- `evaluation/datasets/response_cases.jsonl`
- `evaluation/datasets/search_cases.jsonl`

每条样本包含：
- 输入上下文
- 参考期望（可多参考答案）
- 打分 rubric

## 5. 执行建议

- 每次 prompt/tool 策略变更后跑离线评估。
- PR 阶段至少执行：smoke + 关键场景集。
- 保留每次评估 report，记录模型版本与 prompt 版本。

## 6. 与 LangSmith 对齐

- 将每次会话的计划对象、工具调用、最终回复记录为 trace。
- 使用 LangSmith 数据集管理失败样本并回灌评估集。

