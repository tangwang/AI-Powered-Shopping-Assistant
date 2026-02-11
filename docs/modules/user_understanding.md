# user_understanding 模块设计

## 1. 目标

维护用户长期记忆（会话前历史行为 + 历史对话摘要），并在前端 mock 数据基础上生成可被导购使用的画像 markdown。

## 2. 输入（前端 mock）

- 最近点击/加购/购买（各 20 条）
- 搜索记录（40 条，最近 10 条含详细行为）
- AI 导购历史摘要（40 条）
- 当前会话（若由对话触发更新）

## 3. 输出

### 3.1 用户画像 markdown
1. 稳定偏好（人群、尺码、风格等）
2. 使用场景偏好
3. 明确约束/雷区
4. 行为证据摘要（每条画像需有证据）

### 3.2 辅助产物
- `personalized_welcome_message`
- `offline_recommendation_list`（候选商品 ID + 推荐原因）

## 4. 更新机制（当前阶段）

- 不做自动触发。
- 由前端按钮手动触发：
  1. 更新画像
  2. 生成个性化欢迎语

## 5. 与 assistant 协作原则

- 画像作为“背景”，不能压制用户当前表达。
- 当当前需求与历史偏好冲突时，以当前需求优先。
- 如识别到新禁忌/新档案信息，建议在回合结束后写回画像。

## 6. 建议数据文件

```text
user_understanding/
├── mock_inputs/
│   ├── user_behavior.json
│   └── conversation_history.json
└── output/
    ├── user_profile.md
    ├── recommendation_list.json
    └── personalized_welcome.txt
```

