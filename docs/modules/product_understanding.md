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

