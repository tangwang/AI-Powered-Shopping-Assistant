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

