# 数据契约（Data Contracts）

## 1. Orchestrator 输出契约（推荐 JSON）

```json
{
  "stage": "early|clarify|converge",
  "intent": {
    "category": null,
    "scene": [],
    "effect": [],
    "style": [],
    "audience": null,
    "budget": null,
    "size": null,
    "season": null,
    "region": null,
    "hard_constraints": []
  },
  "gap_assessment": {
    "missing_slots": [],
    "why_important": {}
  },
  "tool_plan": [
    {
      "tool": "product_dist_lookup",
      "priority": 1,
      "must": true,
      "reason": "...",
      "args": {}
    }
  ],
  "candidate_queries": {
    "fuzzy_slots": {
      "category": "",
      "scene": "",
      "effect": "",
      "style": ""
    },
    "search_queries": []
  },
  "questions_to_ask": [
    {"q": "", "options": []}
  ],
  "response_strategy": {
    "recommend_first_then_ask": true,
    "recommendation_count": 2,
    "info_density": "mid"
  },
  "confidence": 0.0
}
```

## 2. 商品分布查询 I/O

### Input
```json
{"dimension": "category|tag|scene|audience|effect", "key": "女装"}
```

### Output
```json
{
  "dimension": "category",
  "key": "女装",
  "product_count": 120,
  "top_subtags": ["通勤", "法式"],
  "sample_products": [{"id": "123", "title": "..."}],
  "summary_md": "..."
}
```

## 3. 用户画像输出契约（markdown + metadata）

```json
{
  "updated_at": "2026-01-01T12:00:00+08:00",
  "trigger": "manual|dialog|enter|event",
  "profile_md": "# 稳定偏好...",
  "evidence": [
    {"claim": "偏好通勤风", "source": "search: 通勤西装", "confidence": 0.82}
  ]
}
```

