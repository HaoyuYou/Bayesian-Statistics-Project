# 贝叶斯房价建模

**STAT 405 课程项目 · 小组成员：Ruohan Sun，Haoyu You**

[English](README.md) · [最终报告](reports/final-report.pdf) ·
[完整分析与结果](reports/analysis-notebook.pdf) · [复现说明](docs/reproducibility.md)

本项目使用 Ames 房屋数据，研究房屋特征与售价之间的关系，并比较两种贝叶斯后验推断方法：MCMC 和均值场变分推断（VI）。在已拟合的基线模型之外，项目还提出了按社区设置截距和居住面积斜率的分层模型。

## 项目做了什么

| 内容 | 说明 |
| :--- | :--- |
| 数据 | Kaggle House Prices 训练集，原始 1,460 条，预处理后 1,126 条 |
| 预测目标 | 房屋售价的自然对数 `log(SalePrice)` |
| 基线模型 | 含 5 个解释变量的贝叶斯高斯回归 |
| 解释变量 | 整体质量、对数居住面积、车库容量、地下室面积、距翻修年数 |
| 推断方法 | 4 条链的 MCMC；同一模型的均值场 VI |
| 模型扩展 | 社区层面的变截距、变斜率模型，已给出公式与 Stan 源码，尚未拟合 |

## 主要结果

| 原报告中的指标 | MCMC | VI |
| :--- | ---: | ---: |
| RMSE | 0.1706 | 5.464 |
| MAE | 0.1200 | 5.069 |
| 残差标准差的后验均值 | 0.171 | 3.902 |

这些数值来自原始报告，均对应**对数房价尺度**；RMSE 和 MAE 在拟合所用的训练数据上计算，不能当作测试集预测成绩。该次运行中，MCMC 的诊断和预测检查较为合理，而 VI 的后验近似明显异常。这不代表所有 VI 方法在此类问题上都会失败。

![MCMC 后验预测均值与实际对数房价对比，红线表示完全一致](docs/assets/mcmc-observed-vs-predicted.png)

图像摘自原分析 PDF 第 38 页，未重新拟合模型。

## 建议阅读顺序

1. [最终报告](reports/final-report.pdf)：了解问题、建模方法、结论及局限。
2. [分析结果 PDF](reports/analysis-notebook.pdf)：查看数据处理、参数结果、轨迹图与预测检查。
3. [分析源码](analysis/final-project.Rmd)：查看完整处理与推断流程。
4. [分层模型说明](analysis/hierarchical-model.Rmd)及 [Stan 实现](models/model_complex.stan)：理解社区差异与部分池化。
5. [方法说明](docs/methodology.md)与[复现指南](docs/reproducibility.md)：了解实现边界和运行方式。

## 目录说明

- `analysis/`：R Markdown 分析与模型说明。
- `R/`、`models/`：R 辅助函数及 Stan 模型源码。
- `data/`：最终房价项目的数据及字段说明。
- `reports/`：保留原始 PDF 报告，作为历史结果快照。
- `docs/`：补充方法、复现说明和首页图像。
- `scripts/`：环境检查与报告生成入口。
- `archive/`：早期共享单车选题、提案及 BMW 备用数据，与最终项目分开存放。

## 本地运行

阅读 PDF 无需安装 R。重新运行需先按[复现指南](docs/reproducibility.md)安装 R、相关包、CmdStan 和 C++ 工具链，然后在项目根目录执行：

```sh
Rscript scripts/check_environment.R
Rscript scripts/render.R analysis html
```

生成结果位于 `outputs/`。运行完整分析会重新进行 MCMC 和 VI 推断。原项目未保存依赖版本锁定文件及后验抽样文件，因此不同软件版本下的结果可能存在差异。

## 小组成员

| 姓名 | 最终报告记录的主要贡献 |
| :--- | :--- |
| **Ruohan Sun** | 分层模型开发、比较结果解读、最终报告撰写 |
| **Haoyu You** | 探索性数据分析、基线模型实现、图表和中间结果整理 |

原报告的分层模型文字将相关系数先验写为均匀分布，而 Stan 实现使用 LKJ(2)。可编辑说明已与代码保持一致；原始 PDF 保留不变，差异记录在[方法说明](docs/methodology.md)中。
