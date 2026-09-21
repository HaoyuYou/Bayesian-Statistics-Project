# Earlier proposal

[Back to the final project](../README.md)

The project initially proposed modeling daily bike-sharing demand with Poisson
regression and a monthly hierarchical extension. A BMW sales dataset was listed
as a backup. The final submitted project instead studies Ames house prices with
Gaussian regression on log prices.

These files document the earlier direction and are not part of the final
analysis or its results.

| File | Purpose |
| :--- | :--- |
| [proposal/proposal.Rmd](proposal/proposal.Rmd) | Original proposal source, with updated data paths and a historical-context note |
| [proposal/proposal.pdf](proposal/proposal.pdf) | Original rendered proposal, unchanged |
| [proposal/data/day.csv](proposal/data/day.csv) | Bike-sharing daily data: 731 rows, 16 columns |
| [proposal/data/bmw_global_sales_2018_2025.csv](proposal/data/bmw_global_sales_2018_2025.csv) | Backup BMW data: 3,072 rows, 11 columns |

Sources recorded in the original proposal:

- [UCI Bike Sharing Dataset](https://archive.ics.uci.edu/dataset/275/bike+sharing+dataset).
- [Kaggle BMW Global Automotive Sales](https://www.kaggle.com/datasets/dmahajanbe23/bmw-global-automotive-sales).

The proposal's planned contributions and inference methods describe intentions at
that time. For actual final-project contributions, see the root README and final
report. To render this proposal from the repository root:

```sh
Rscript scripts/render.R proposal html
```
