# 系统总体设计（vNext）

## 1. 目标

围绕“像真人导购一样持续澄清需求、组织推荐并促成转化”，系统升级为三层：

1. **理解层**：`user_understanding` + `product_understanding`
2. **编排层**：`orchestrator`（先计划，再执行）
3. **生成层**：`assistant`（面向用户输出）

## 2. 当前实现复用点

- `src/graph.py`：已有状态图，适合扩展一个 `orchestrator` 节点。
- `src/tools.py`：已有工具注册机制，可新增 product/user/web 等工具。
- `src/state.py`：可扩展上下文字段（画像摘要、分布摘要、计划对象等）。
- `app.py`：可扩展左侧“中间过程”展示，适配调度结果可视化。

## 3. 目标目录结构建议

```text
.
├── assistant/
│   ├── orchestrator.py
│   ├── responder.py
│   └── prompts/
├── product_understanding/
│   ├── process_products.py           # 现有
│   ├── aggregate_dimensions.py       # 新增
│   └── output_logs/
├── user_understanding/
│   ├── profile_builder.py
│   ├── recommendation_builder.py
│   └── mock_inputs/
├── evaluation/
│   ├── eval_orchestrator.py
│   ├── eval_response_quality.py
│   └── datasets/
├── logs/
│   ├── assistant_*.log
│   ├── product_*.log
│   └── user_*.log
├── docs/
└── scripts/
```

## 4. 核心流程

### 4.1 会话开始
1. 读取店铺欢迎语池（离线生成）。
2. 读取用户画像（若无则默认空画像）。
3. 若有个性化欢迎语则优先展示。

### 4.2 每轮对话
1. 用户输入。
2. Orchestrator 产出结构化计划对象（JSON）。
3. 后端按计划调用技能（可并行 + 优先级）。
4. 汇总技能结果，注入 Assistant。
5. Assistant 输出“补信息 + 推荐 + 轻引导”。
6. 记录结构化日志（计划、工具 I/O、最终回复）。

### 4.3 会话结束/手动触发
1. 用户画像更新。
2. 离线推荐列表更新。
3. 个性化欢迎语更新。

## 5. 两种编排实现路径

### 方案 A：System Prompt + 结构化文本块
- 优点：实现快，兼容性高。
- 风险：JSON 约束弱，需 parser 兜底。

### 方案 B：Function Calling（推荐）
- 优点：结构化稳定，方便后端执行。
- 风险：对模型能力要求更高。

建议：**先 A 后 B**，先快速验证策略，再切换 Function Calling 提升稳定性。

## 6. 分阶段落地

### Phase 1（1~2 周）
- 完成离线商品聚合与欢迎语生成。
- 实现 Orchestrator 基础版（A 方案）。
- 完成日志规范与可视化透传。

### Phase 2（2~3 周）
- 用户画像前端 mock + 后端生成 markdown 画像。
- 引入评估脚本，形成自动回归。
- 对接 Tavily（受控触发）。

### Phase 3（2 周）
- Orchestrator 升级 Function Calling（B 方案）。
- 增加 compare/style 等技能。
- 前端可视化“计划对象 + 工具执行轨迹 + 商品卡片”。

