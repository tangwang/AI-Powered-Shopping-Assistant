# 评估设计（LLM-as-Judge）

## 1. 目标

由于导购输出具有非确定性，采用“规则评估 + LLM 评估”混合方案，保障质量可回归。

## 2. 评测样本格式（建议 jsonl）

```json
{
  "case_id": "c001",
  "user_input": "我想买条裙子，夏天穿",
  "profile": "...",
  "expected": {
    "must_have": ["场景", "风格询问"],
    "max_questions": 2,
    "forbidden": ["过度参数盘问"]
  }
}
```

## 3. 自动化评分维度

1. 意图识别完整度
2. 提问质量与数量
3. 推荐相关性
4. 对话推进能力（是否促进下一轮）
5. 可信性（无编造）

## 4. LLM Judge 输出

```json
{
  "score": 0.82,
  "dimension_scores": {
    "intent": 0.9,
    "question_quality": 0.8,
    "recommendation_relevance": 0.75
  },
  "errors": ["问题略偏参数化"],
  "advice": ["改成用户立场提问"]
}
```

## 5. 门禁建议

- PR 合并门禁：
  - 平均分 >= 0.75
  - 严重错误率 < 3%
- 回归维度：
  - 新增样本不能降低历史关键场景表现

