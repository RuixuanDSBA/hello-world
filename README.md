# GSSA 南澳大利亚地理学与矿业月度数据报表（框架与部署说明）

本仓库提供使用 GSSA（Geological Survey of South Australia）公开数据构建“每月更新”的南澳大利亚地学与矿业数据报表的文档与框架，并给出在 Azure 上的部署路径以及自然语言交互（对话式问答 + 图表生成）的最小可行方案。

### 目标
- **每月更新**：按月从 GSSA 数据源增量/全量同步，完成清洗、标准化与汇总。
- **可视化报表**：提供以矿权、钻孔、地质图层、地球物理与产量为核心的可视化视图。
- **自然语言交互**：用户可用中文或英文自然语言查询，并在报表上下文中获得答案与图表。
- **可复用架构**：基于 Azure 原生服务，支持 IaC、可观测性与数据治理。

---

### 数据源（GSSA）与接入方式
- **典型数据域**：
  - 矿权（勘探许可、采矿租约等）
  - 钻孔与测井数据
  - 地质图层（构造、岩性、地层）
  - 地球物理数据（重力、磁法、航测）
  - 产量与活动通报（若公开）
- **常见获取渠道**：
  - WFS/WMS/REST GIS 服务
  - 批量下载（CSV/GeoJSON/Shapefile）
  - 数据门户 API（若提供）
- **配置环境变量（示例）**：
  - `GSSA_TENEMENT_WFS_URL="https://<GSSA_WFS_ENDPOINT>/tenements"`
  - `GSSA_DRILLHOLE_WFS_URL="https://<GSSA_WFS_ENDPOINT>/drillholes"`
  - `GSSA_GEOLOGY_WFS_URL="https://<GSSA_WFS_ENDPOINT>/geology"`
  - `GSSA_DOWNLOAD_BASE="https://<GSSA_DOWNLOAD_BASE>"`
  - 将以上放入 `.env` 或 Azure Key Vault 中，由数据管道在运行时读取。

> 备注：实际端点与字段请以 GSSA/SARIG 官方发布为准，将其填入 `infra` 或 `data_pipeline` 中的配置。

---

### 总体架构（参考实现）
- **采集层（Ingestion）**：
  - 使用 Azure Data Factory（或 GitHub Actions）按月触发，调用 GSSA WFS/API 或批量下载接口；
  - 原始数据存入 Azure Data Lake Storage Gen2（Raw 区）。
- **处理层（Processing）**：
  - 使用 Azure Databricks/Synapse 进行清洗、Schema 对齐、坐标投影转换、增量合并（Delta Lake）；
  - 产出标准化表（Curated 区）与聚合表（Gold 区）。
- **服务层（Serving）**：
  - 报表：Power BI/Fabric Direct Lake 或 Azure Data Explorer（Kusto）视图；
  - 对话与检索：Azure Cognitive Search（索引元数据/字典/业务定义），Azure OpenAI 实现 NL→SQL/DAX/KQL；
  - 应用：前端（如静态站点/Power BI Embedded）+ 轻量 API（Azure Functions/Container Apps）。
- **治理与安全**：
  - 身份与访问：Microsoft Entra ID + RBAC；
  - 机密：Azure Key Vault；
  - 监控：Azure Monitor/Log Analytics；
  - 版本与审计：Delta 版本、管道运行日志、Artifact 版本。

---

### 数据管道（按月更新）
1) **采集（Raw）**：
   - 拉取当月全量/增量（依据数据源能力与时间戳字段）；
   - 保存原始文件与快照（便于追溯）。
2) **标准化（Curated）**：
   - 字段命名统一、坐标系统一（如 GDA2020/WGS84）；
   - 类型修正与字典映射（矿权类型、地层编码等）。
3) **聚合与衍生（Gold）**：
   - 典型聚合：按矿区/矿权类型/时间的指标；
   - 空间聚合：与行政区、矿区边界、地质单元叠加统计。
4) **质量与回归**：
   - 基础校验（非空、范围、唯一性）；
   - 模式漂移与异常波动告警；
   - 采集与处理的可重放与幂等。
5) **发布与变更管理**：
   - 将 Gold 表暴露给报表与查询端点；
   - 变更日志（数据口径/字段变更）。

---

### 自然语言交互（两种方案）
- **方案 A：报表内对话（推荐入门）**
  - Power BI/Fabric 报表为主体，结合 Azure OpenAI 作为“语义代理”，将用户问题转换为 DAX/SQL/KQL，并给出图表建议；
  - 对话记录与上下文（筛选器、时间范围）作为提示词一并输入。
- **方案 B：Web + RAG 检索增强**
  - 前端提供聊天 + 图表区，后端使用 Azure OpenAI + Cognitive Search 索引数据字典/度量定义/报表元数据；
  - 对于可执行查询的请求，生成 SQL/DAX/KQL 调用数据服务并返回结果，再生成图表配置（如 ECharts/Vega）。

---

### 在 Azure 上部署（最小可行路径）
1) **准备资源**（建议使用 IaC）：
   - 资源组、ADLS Gen2、Key Vault、Data Factory、Databricks 或 Synapse、Functions/Container Apps、Cognitive Search、Azure OpenAI、Power BI 工作区/容量（或 Fabric）。
2) **身份与权限**：
   - 为管道与计算赋予对存储与 Key Vault 的托管身份访问；
   - 为报表/应用配置 Entra ID 应用与访问策略。
3) **机密与配置**：
   - 将 GSSA 端点与密钥写入 Key Vault；
   - 在 ADF/Functions/Databricks 中以引用方式读取。
4) **数据管道发布**：
   - 导入/发布 ADF 管道与触发器（每月 1 号 UTC 定时）；
   - 在 Databricks/Synapse 配置作业任务，运行清洗与聚合 Notebook/脚本。
5) **索引与语义层**：
   - 基于字典与元数据建立 Cognitive Search 索引；
   - 配置 OpenAI 模型与系统提示，启用工具调用（SQL/DAX/KQL）。
6) **应用与报表**：
   - 部署 API（Functions）与前端（Static Web Apps/AKS/Container Apps）；
   - 发布 Power BI 报表并（可选）嵌入应用，或提供链接访问。
7) **CI/CD 与调度**：
   - 使用 GitHub Actions 每月计划任务触发数据刷新，或由 ADF 原生触发器负责；
   - 将 IaC、管道与应用部署纳入同一流水线。

---

### 仓库结构（框架）
```text
.
├── README.md                       # 说明与操作指南（当前文件）
├── .env.example                    # 本地开发的环境变量示例
├── data_pipeline/                  # 数据采集、处理与调度工件
│   ├── ingestion/                  # 采集脚本/ADF 模板占位
│   ├── processing/                 # 清洗与聚合（Notebook/脚本）
│   ├── models/                     # 语义层度量/词典/维表约定
│   └── tests/                      # 数据质量与回归校验
├── app/                            # 应用与接口（对话/查询/嵌入报表）
│   ├── api/                        # 轻量 API（Functions/FastAPI 占位）
│   └── web/                        # 前端占位（静态站点/框架）
├── infra/                          # 基础设施（Bicep/Terraform）
│   └── templates/                  # 资源模板与参数
├── docs/                           # 架构图、数据字典、SLA/变更记录
└── .github/
    └── workflows/
        └── monthly-pipeline.yml    # 每月调度（占位）
```

---

### 快速开始（仅框架占位）
1) 复制 `.env.example` 为 `.env` 并填写 GSSA 与 Azure 配置。
2) 将 GSSA 实际端点与字段字典填入 `data_pipeline/*` 与 `infra/*` 中对应占位文件。
3) 按“在 Azure 上部署”章节逐项实施（或使用 IaC 一键部署）。

---

### 数据治理与合规建议
- 标注来源与更新时间；
- 遵循数据许可与使用条款；
- 对关键指标建立基线与阈值告警；
- 记录口径变更并影响评估。

---

### 后续工作（建议）
- 填充采集脚本与实际端点映射；
- 完成处理 Notebook/脚本与数据质量用例；
- 选择 Serving 方案（Power BI/Fabric/ADX）并落地；
- 实现 NL→SQL/DAX 的函数调用与权限校验；
- 打通 CI/CD 与观测（运行时日志与告警）。
