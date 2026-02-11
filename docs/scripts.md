# scripts 启动脚本说明

本项目建议拆分模块启动命令，支持独立开发与联调。

## 1. 脚本列表

- `scripts/start_product_module.sh`
- `scripts/start_user_module.sh`
- `scripts/start_agent_module.sh`
- `scripts/start_web.sh`

## 2. 约定

- 统一要求已激活环境：`conda activate aishopping-py312`
- 默认端口：Web 使用 `6008`
- 各脚本启动前输出关键环境变量检查结果

## 3. 当前仓库落地方式

先提供基础脚手架脚本（echo + 入口预留），后续按模块代码补充实际命令。

