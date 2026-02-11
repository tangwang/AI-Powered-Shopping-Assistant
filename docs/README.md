# Docs 导航

- `技术实现报告.md`：已有项目技术拆解（v1）
- `技术实现升级方案（面向新导购设计）.md`：结合新需求的升级方案
- `modules/assistant.md`：导购模块设计与 I/O
- `modules/product_understanding.md`：商品理解模块设计与 I/O
- `modules/user_understanding.md`：用户理解模块设计与 I/O
- `scripts/运行与启动脚本规范.md`：脚本职责与运行规范
- `evaluation/评估设计（LLM-as-Judge）.md`：评估体系设计
# AI 导购系统设计补充文档（vNext）

本文档集合用于在当前项目（LangGraph + 工具调用 + Streamlit）基础上，落地新一版“导购智能体 + 用户理解 + 商品理解 + 编排器”方案。

## 文档目录

- `docs/system_design_vnext.md`：总体架构、阶段化改造路线、模块边界。
- `docs/modules/assistant.md`：导购智能体与 Orchestrator 设计。
- `docs/modules/product_understanding.md`：商品理解离线/在线设计。
- `docs/modules/user_understanding.md`：用户画像与记忆模块设计。
- `docs/evaluation/llm_evaluation.md`：评估指标、评估数据、评估脚本建议。
- `docs/logs/logging_spec.md`：日志分层、字段规范、落盘建议。
- `docs/data/data_contracts.md`：核心数据输入输出契约（I/O schema）。
- `docs/scripts.md`：启动脚本职责与运行方式。

## 与当前仓库实现的关系

当前仓库已有能力：
- LangGraph 对话状态机与多角色路由（销售/客服）。
- 工具调用（检索、结构化检索、购物车等）。
- Streamlit Web 演示。

本套文档的重点是：
1. 在“现有能力可复用”前提下增加 **Orchestrator 计划层**。
2. 引入 **商品理解离线聚合** 与 **用户画像（前端 mock + LLM 汇总）**。
3. 建立 **日志与评估先行** 的测试驱动闭环。

