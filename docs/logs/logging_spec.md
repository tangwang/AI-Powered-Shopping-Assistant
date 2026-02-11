# 日志规范（Logs）

## 1. 目标

实现模块化、可回放、可审计日志，特别记录 LLM 输入输出与工具调用链路。

## 2. 日志文件前缀

- `logs/assistant_YYYYMMDD.log`
- `logs/product_YYYYMMDD.log`
- `logs/user_YYYYMMDD.log`
- `logs/evaluation_YYYYMMDD.log`

## 3. 统一字段

```json
{
  "ts": "2026-01-01T12:00:00+08:00",
  "trace_id": "uuid",
  "session_id": "uuid",
  "tenant_id": "demo",
  "module": "assistant|product|user|evaluation",
  "stage": "orchestrate|tool_call|respond|profile_update|offline_aggregate",
  "input": {},
  "output": {},
  "latency_ms": 1234,
  "model": "qwen-plus|gpt-4o|...",
  "success": true,
  "error": null
}
```

## 4. 必记过程

1. Orchestrator 原始输入与计划对象。
2. 每个工具调用入参/出参（截断大字段）。
3. Assistant 最终提示词关键片段与输出。
4. 画像更新前后 diff 摘要。

## 5. 安全与脱敏

- 记录前脱敏用户手机号/地址/邮箱。
- 仅保留必要上下文，避免写入完整隐私文本。

