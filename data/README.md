# Data guide

[Back to the project overview](../README.md)

## Final project: Ames house prices

The files in `house-prices-advanced-regression-techniques/` were included in the
original project and originate from the Kaggle
[House Prices competition](https://www.kaggle.com/competitions/house-prices-advanced-regression-techniques/data).
They have been retained without modification. Consult the source for applicable
data access and reuse terms.

| File | Rows | Columns | Used by this analysis? |
| :--- | ---: | ---: | :--- |
| [train.csv](house-prices-advanced-regression-techniques/train.csv) | 1,460 | 81 | Yes; includes `SalePrice` |
| [test.csv](house-prices-advanced-regression-techniques/test.csv) | 1,459 | 80 | No; lacks observed `SalePrice` |
| [sample_submission.csv](house-prices-advanced-regression-techniques/sample_submission.csv) | 1,459 | 2 | No; submission-format example, not observed test outcomes |
| [data_description.txt](house-prices-advanced-regression-techniques/data_description.txt) | — | — | Reference dictionary for the source variables |

CSV row counts exclude headers. The original analysis retains 1,126 training
rows after missing-value recoding and complete-case filtering.

## Variables used by the models

| Variable | Role and transformation |
| :--- | :--- |
| `SalePrice` | Response; transformed to `LogSalePrice = log(SalePrice)` |
| `OverallQual` | Overall material and finish quality, used as a numeric score |
| `GrLivArea` | Above-ground living area, transformed to `LogGrLivArea = log(GrLivArea)` |
| `GarageCars` | Garage capacity in cars |
| `TotalBsmtSF` | Total basement area, in square feet |
| `YrSold`, `YearRemodAdd` | Used to construct `YearSinceRemodel = YrSold - YearRemodAdd` |
| `Neighborhood` | Grouping variable required by the proposed hierarchical model |

The notebook uses additional columns during exploratory screening and removes
rows with missingness before restricting to baseline variables. See
[methodology notes](../docs/methodology.md) for the implications.

## Earlier datasets

The 731-row bike-sharing file and 3,072-row BMW file belong to the earlier
proposal. They are stored in [archive/proposal/data/](../archive/proposal/data/)
and are not inputs to the final housing analysis. Their source links are listed
in the [archive guide](../archive/README.md).
