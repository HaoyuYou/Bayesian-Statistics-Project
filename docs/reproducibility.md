# Reproducing the analysis

[Back to the project overview](../README.md)

## 1. Install prerequisites

Use R 4.1 or newer (the notebook uses the native `|>` pipe), a working C++
toolchain, CmdStan, and Pandoc. RStudio is optional and normally supplies Pandoc.
PDF rendering additionally requires a LaTeX distribution. HTML is the simplest
first output format.

Install the R packages in an R session:

```r
install.packages(c(
  "ggplot2", "dplyr", "corrplot", "car", "bayesplot",
  "posterior", "distr", "rmarkdown", "knitr"
), repos = "https://cloud.r-project.org")

install.packages(
  "cmdstanr",
  repos = c("https://stan-dev.r-universe.dev", "https://cloud.r-project.org")
)
cmdstanr::check_cmdstan_toolchain()
cmdstanr::install_cmdstan(cores = 2)
```

If CmdStan is already installed, use that installation and check
`cmdstanr::cmdstan_path()`. For setup details, see the official
[CmdStanR guide](https://mc-stan.org/cmdstanr/articles/cmdstanr.html).
For optional PDF support, install a LaTeX distribution; one R-based option is:

```r
install.packages("tinytex", repos = "https://cloud.r-project.org")
tinytex::install_tinytex()
```

## 2. Check the environment

Open `Bayesian-Statistics-Project.Rproj` in RStudio, or open a terminal at the
repository root:

```sh
Rscript scripts/check_environment.R
```

This checks R version, package availability, Pandoc, and the configured CmdStan
version. It does not install anything, compile a model, or verify the C++
toolchain. Use `cmdstanr::check_cmdstan_toolchain()` for the latter.

The repository bundles the data used in the original submission; no additional
dataset download or Kaggle credential is needed for this notebook.

## 3. Render a document

```sh
# Full baseline workflow: preprocessing, prior checks, MCMC, VI, comparisons
Rscript scripts/render.R analysis html

# Same workflow as a PDF, after installing LaTeX
Rscript scripts/render.R analysis pdf

# Hierarchical model specification only (no model fitting)
Rscript scripts/render.R hierarchical html

# Historical bike-sharing proposal only
Rscript scripts/render.R proposal html
```

The renderer resolves paths from its own location, uses the repository root as
the knitting working directory, and writes to the ignored `outputs/` directory.
It does not overwrite the original PDFs in `reports/`. MCMC uses four parallel
chains; lower `parallel_chains` in the notebook if the machine has limited memory
or CPU capacity. Render time depends on compilation and sampling speed.

| Command target | Input | Output with `html` |
| :--- | :--- | :--- |
| `analysis` | `analysis/final-project.Rmd` | `outputs/final-project.html` |
| `hierarchical` | `analysis/hierarchical-model.Rmd` | `outputs/hierarchical-model.html` |
| `proposal` | `archive/proposal/proposal.Rmd` | `outputs/proposal.html` |

The main notebook can also be opened and knitted in RStudio. Its setup chunk
supports rendering from the repository root or the `analysis/` directory. When
running chunks interactively, set the working directory to the repository root.

## 4. Interpret the outputs

- The original preprocessing retained **1,126 of 1,460 rows**. Check the printed
  counts before comparing results.
- Prior simulations use seed 1; MCMC and VI use seed 123.
- MCMC summaries, traces, predictive plots, and in-sample RMSE/MAE are followed by
  the corresponding VI results and a parameter comparison table.
- VI performed poorly in the original run. Its diagnostics are now visible;
  review them rather than assuming a successful command means a valid posterior.
- The final section prints `sessionInfo()` and the CmdStan version for future runs.

## Reproducibility limits

The original submission did not include a package lockfile, session information,
or saved posterior draws. The committed PDFs are historical evidence of that
run, not artifacts regenerated during repository organization. Package and Stan
version changes may affect numerical results, particularly VI. The hierarchical
model and Kaggle test predictions are not part of the executed workflow.

This repository refresh was checked for file integrity, data dimensions, local
links, and source-path consistency. R/Rscript was unavailable in the maintenance
environment, so the updated rendering commands and Stan sampling have **not**
been executed there.

## Troubleshooting

| Symptom | Action |
| :--- | :--- |
| `Rscript: command not found` | Install R and add its executable directory to your terminal PATH. |
| Missing R package | Install the package named by the environment check. |
| CmdStan path/version unavailable | Install CmdStan, or configure `cmdstanr::set_cmdstan_path()` in your R environment. |
| Stan compilation fails | Run `cmdstanr::check_cmdstan_toolchain()` and resolve its compiler guidance. |
| Pandoc is unavailable | Use the RStudio environment or install Pandoc and make it discoverable by `rmarkdown`. |
| LaTeX is unavailable | Render HTML first, or install LaTeX for PDF output. |
| File not found when executing chunks | Set the working directory to the repository root or use `scripts/render.R`. |
| VI fails or produces implausible values | Inspect optimizer output and predictive checks; see the original failed approximation in the report. |
