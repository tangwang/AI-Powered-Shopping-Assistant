# product_understanding 模块设计文档

## 1. 模块职责

基于离线已完成标注结果 `product_understanding/output_logs/products_analyzed.csv`，提供：

1. 分维度归一化与映射；
2. 店铺内容分布简介；
3. 店铺欢迎语候选；
4. 在线分布查询与搜索辅助技能。

## 2. 输入/输出

## 2.1 离线输入

- CSV 字段：
  - `category_path`
  - `tags`
  - `target_audience`
  - `usage_scene`
  - `season`
  - `selling_points`

## 2.2 离线输出（建议）

- `data/product_summaries/category_mapping.csv`
- `data/product_summaries/tag_mapping.csv`
- `data/product_summaries/audience_mapping.csv`
- `data/product_summaries/scene_mapping.csv`
- `data/product_summaries/effect_mapping.csv`
- `data/product_summaries/store_distribution.md`
- `data/product_summaries/store_welcome_messages.json`

## 2.3 在线查询输出（建议）

```json
{
  "dim": "scene",
  "key": "通勤",
  "count": 120,
  "ratio": 0.16,
  "top_examples": [
    {"id": "107365", "title_cn": "男士偏光飞行员太阳镜"}
  ],
  "markdown": "..."
}
```

## 3. 技能接口建议

1. `product_distribution(dim, key, tenant_id)`
2. `product_search_fuzzy(intent_slots)`
3. `product_search_exact(query)`
4. `result_summarize(user_goal, top_items)`

## 4. 归一化方法

1. 先统计 top50 高频词。
2. 交由 LLM 进行“层级压平 + 归一命名”。
3. 人工审核映射表。
4. 映射入库后供在线模块稳定复用。

## 5. 日志与质量控制

- 归一化映射版本号（如 `v2026-02-11`）。
- 每次发布输出对比报告（新增 key、合并 key、样本变化）。
- 在线接口记录 query 命中率与空结果率。

