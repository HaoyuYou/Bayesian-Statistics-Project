# Methodology and implementation notes

[Back to the project overview](../README.md)

## Data preparation

The [analysis notebook](../analysis/final-project.Rmd) reads the 1,460-row housing
training file. It recodes selected structural missing values, creates amenity
indicators, maps ordinal categories to numeric scores, and then calls `na.omit()`
on the entire working data frame. The original run retained 1,126 rows and
removed 334. Some missing values remain outside the final five predictors, so
this is broader than complete-case filtering on the baseline predictors alone.

Subsequent steps create time-since-build/remodel variables and cyclical month
features, consolidate categorical levels, transform the response, and screen
predictors using correlations, ANOVA, alias checks, and variance inflation
factors. Numerical screening uses an absolute response correlation threshold of
0.3 and checks predictor-pair correlations above 0.7. The final baseline uses
five interpretable predictors and logs living area.

These are exploratory choices made on the same data used for fitting. A future
out-of-sample evaluation should perform preprocessing and selection within each
training split, rather than treating the current results as independent validation.

## Baseline model

For $y_i = \log(\mathrm{SalePrice}_i)$:

$$
y_i \sim \mathcal{N}(\mu_i, \sigma^2), \qquad
\mu_i = \beta_0 + \sum_{k=1}^{5}\beta_k x_{ik}.
$$

The [Stan source](../models/model_naive.stan) uses the following priors. Standard
deviations, rather than variances, are shown in the last column.

| Parameter | Predictor | Prior mean | Prior SD |
| :--- | :--- | ---: | ---: |
| `beta0` | Intercept | 8.8 | 0.05 |
| `beta1` | `OverallQual` | 0.10 | 0.03 |
| `beta2` | `log(GrLivArea)` | 0.25 | 0.08 |
| `beta3` | `GarageCars` | 0.06 | 0.03 |
| `beta4` | `TotalBsmtSF` | 0.00010 | 0.00003 |
| `beta5` | `YrSold - YearRemodAdd` | -0.003 | 0.004 |

Each coefficient has a normal prior. The positive residual scale `sigma` has a
half-normal prior with scale 0.10. Predictors are not standardized. These priors
are specific to the encoded variable scales; their informativeness should be
assessed through prior predictive and sensitivity checks.

Generated quantities include fitted means `mu`, posterior predictive draws
`y_rep`, and pointwise log likelihoods `log_lik`. The committed analysis does not
calculate LOO or WAIC.

## Posterior computation and evaluation

| Setting | MCMC | VI |
| :--- | :--- | :--- |
| Seed | 123 | 123 |
| Method | Stan HMC/NUTS | Mean-field variational approximation |
| Draws | 4 chains × 1,000 post-warmup draws | 2,000 output draws |
| Warmup | 1,000 iterations per chain | Not applicable |
| Other settings | `adapt_delta = 0.95`, `max_treedepth = 12` | Other optimizer settings use CmdStan defaults |

The notebook compares parameter means, SDs, 5th/95th percentiles, trace plots,
posterior densities, and posterior predictive checks. Its error metrics are:

$$
\hat y_i = \frac{1}{S}\sum_{s=1}^{S}y_i^{\mathrm{rep},s}, \quad
\mathrm{RMSE}=\sqrt{\frac{1}{N}\sum_i(y_i-\hat y_i)^2}, \quad
\mathrm{MAE}=\frac{1}{N}\sum_i|y_i-\hat y_i|.
$$

All quantities are on the natural-log scale and use the fitting data. Errors
therefore include Monte Carlo variation from `y_rep`. Exponentiating a predicted
log price does not, by itself, give the posterior predictive mean price in dollars.

The original report lists rounded MCMC R-hat values of 1.00 and large effective
sample sizes. Those summaries and the plots support the reported fit, but raw
draws and a full sampler-diagnostic log are not committed. The VI run's large
residual scale and implausible predictions make it unsuitable for substantive
inference. Its cause has not been established here. The editable notebook now
shows VI messages and exceptions to support investigation on reruns.

## Hierarchical extension and corrected prior notation

The [hierarchical source](../models/model_complex.stan) adds neighborhood effects:

$$
\mu_i=\beta_0+\alpha_{j[i]}+
(\beta_2+\gamma_{j[i]})\mathrm{LogGrLivArea}_i+
\beta_1\mathrm{OverallQual}_i+\beta_3\mathrm{GarageCars}_i+
\beta_4\mathrm{TotalBsmtSF}_i+\beta_5\mathrm{YearSinceRemodel}_i.
$$

Intercept and slope effects have a joint zero-mean normal distribution with
covariance $\Sigma=D\Omega D$, where
$D=\operatorname{diag}(\tau_\alpha,\tau_\gamma)$. The scale priors are half-normal
with scales 0.12 and 0.05. The implementation uses `lkj_corr_cholesky(2.0)` and a
non-centered parameterization.

**Correction:** The original PDF prose says $\rho\sim\mathrm{Uniform}(-1,1)$,
but the code uses $\Omega\sim\mathrm{LKJ}(2)$. These are different priors: LKJ(2)
favors correlations near zero. The editable
[model specification](../analysis/hierarchical-model.Rmd) now follows the code.
See the [Stan LKJ reference](https://mc-stan.org/docs/functions-reference/correlation_matrix_distributions.html).
The original PDFs have been preserved without rewriting historical results.

No fitting driver, posterior draws, or predictive comparison for this extension
is supplied. Fitting it requires integer neighborhood IDs from 1 to `J`, created
after preprocessing and aligned with every predictor row. Claims of improved
predictive performance would require fitting and independent evaluation.

## Next research steps

- Introduce held-out evaluation or cross-validation with training-only preprocessing.
- Investigate the VI failure through optimization diagnostics, scaling, and prior sensitivity.
- Fit the hierarchical model and examine its sampler diagnostics and predictive behavior.
- Assess sensitivity to whole-frame complete-case filtering and informative priors.
- Save software versions, posterior draws, and diagnostics for reproducible comparisons.
