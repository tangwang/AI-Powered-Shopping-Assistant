# assistant 模块设计文档

## 1. 模块职责

assistant 模块负责将“编排层执行后的上下文”转为面向用户的自然语言回复，目标是：

- 解释推荐依据；
- 提供有价值的建议；
- 以用户立场提出 1~2 个关键问题；
- 维持导购语气一致性。

## 2. 输入/输出

## 2.1 输入（建议 schema）

```json
{
  "session_id": "string",
  "user_input": "string",
  "orchestration_plan": {},
  "tool_results": {
    "product_distribution": "markdown or json",
    "search_results": [],
    "style_suggestions": [],
    "web_insights": []
  },
  "memory_context": {
    "profile_markdown": "string",
    "recent_dialogue_summary": "string"
  },
  "scene_context": {
    "region": "string|null",
    "season": "string|null",
    "weather": "string|null"
  }
}
```

## 2.2 输出

```json
{
  "assistant_reply": "string",
  "next_questions": ["string"],
  "selected_products": ["id"],
  "confidence": 0.0
}
```

## 3. 提示词分层

1. **System**：导购角色、语气、行为边界。
2. **Context**：画像摘要、店铺分布、场景信息、技能结果。
3. **Policy**：
   - 每轮最多 2 问；
   - 问题以“感受/场景/偏好”为主；
   - 避免参数盘问。

## 4. 关键实现建议

1. 采用低温度（0.2~0.4）保证稳定性。
2. 支持候选回复重排（n=2~3）后选最优。
3. 增加输出校验：
   - 问题数量 > 2 自动裁剪；
   - 空推荐时自动回退为澄清策略。

## 5. 日志要求

每轮记录：

- prompt 版本
- 输入上下文摘要
- 模型输出
- 规则校验结果
- token 与耗时
# assistant 模块设计

## 1. 模块职责

assistant 模块拆分为两个角色：

1. **Orchestrator（编排器）**：做意图分析、缺口判断、技能规划。
2. **Assistant（导购）**：基于补充后的上下文输出用户可读回复。

## 2. 输入输出

### 2.1 Orchestrator 输入
- 用户输入
- 最近 7~10 轮对话摘要
- 用户画像 markdown
- 店铺分布简介
- 当前地域/季节信息

### 2.2 Orchestrator 输出（结构化）
- `goal` / `intent`
- `gaps`
- `skills_to_call`（含优先级、参数、must）
- `questions_to_ask`
- `response_strategy`

### 2.3 Assistant 输入
- 用户输入
- Orchestrator 计划 + 技能结果
- 用户画像（只做背景，不覆盖当前意图）

### 2.4 Assistant 输出
- 面向用户的自然语言回复（推荐/追问/总结）

## 3. 推荐执行策略

- 缺口大：先问 1~2 个问题 + 给 2~3 个临时方向。
- 缺口小：直接给推荐，并做轻引导确认。
- 每轮最多 2 问，避免审问感。

## 4. 技能触发建议

- `product_distribution`：意图模糊时先看分布。
- `product_search_fuzzy`：只有宽泛意图时触发。
- `product_search_precise` + `result_summarize`：意图收敛后触发。
- `style_agent`：用户出现“搭配/场合怎么穿”等需求时触发。
- `compare_agent`：候选 2~5 个时触发。
- `web_search_trend`：只在时效趋势/新概念术语下触发。

## 5. 与现有代码的改造点

1. `src/state.py` 增加字段：
   - `user_profile_md`
   - `store_distribution_md`
   - `orchestration_plan`
   - `tool_results`

2. `src/graph.py` 增加节点：
   - `orchestrator`
   - `tool_executor`
   - `assistant_responder`

3. `src/prompts.py` 拆分提示词：
   - `orchestrator_prompt`
   - `assistant_prompt`

## 6. 输出质量基线

- 回复中必须包含：
  1. 价值信息（推荐依据或差异点）
  2. 一句以内的轻引导问题
  3. 不强行参数盘问

