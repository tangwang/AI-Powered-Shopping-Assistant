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
# product_understanding 模块设计

## 1. 范围

基于已产出的 `product_understanding/output_logs/products_analyzed.csv`，补充离线聚合能力，供在线导购即时使用。

## 2. 离线任务

1. **维度 Top50 统计**
   - 品类路径（按 `>` 分割）
   - 细分标签（按 `,` 分割）
   - 人群、场景、季节、效果

2. **维度归一化**
   - 对 top50 词项进行语义合并（LLM + 人工可校正）。
   - 产出映射：`原始词 -> 归一化词`。

3. **归一化项概览**
   - 每个归一化项输出：商品数、占比、代表商品示例。

4. **商店内容分布简介生成**
   - 从品类、人群、场景、风格/功能维度生成简短概述。

5. **欢迎语池生成（10 条）**
   - 通用导购语 + 店铺风格定制。

## 3. 在线能力

- `product_distribution`：输入维度+key，输出该维度 markdown 概览。
- `product_search_fuzzy`：从归一化 keylist 挑选匹配 key，再返回候选商品范围。
- `product_search_precise`：调用搜索 API。
- `result_summarize`：判断满足度、改写 query、精选商品 ID。

## 4. 关键产物（建议）

```text
product_understanding/output_logs/
├── products_analyzed.csv                  # 已有
├── dimension_top50.json
├── normalization_mapping.json
├── normalized_distribution.json
├── store_distribution_summary.md
└── welcome_messages.json
```

## 5. 数据质量建议

- 归一化映射需记录 version 与更新时间。
- 每次离线任务保留 prompt 与 model 信息，便于回溯。
- 对“低频但高价值词”（如功能性术语）单独白名单保留。

