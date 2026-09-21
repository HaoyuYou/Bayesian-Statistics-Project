data {
  int<lower=1> N;

  vector[N] y;
  vector[N] OverallQual;
  vector[N] LogGrLivArea;
  vector[N] GarageCars;
  vector[N] TotalBsmtSF;
  vector[N] YearSinceRemodel;
}

parameters {
  real beta0;
  real beta1;
  real beta2;
  real beta3;
  real beta4;
  real beta5;
  real<lower=0> sigma;
}

model {
  vector[N] mu;

  beta0 ~ normal(8.8, 0.05);
  beta1 ~ normal(0.10, 0.03);
  beta2 ~ normal(0.25, 0.08);
  beta3 ~ normal(0.06, 0.03);
  beta4 ~ normal(0.00010, 0.00003);
  beta5 ~ normal(-0.003, 0.004);
  sigma ~ normal(0, 0.10);

  mu = beta0
      + beta1 * OverallQual
      + beta2 * LogGrLivArea
      + beta3 * GarageCars
      + beta4 * TotalBsmtSF
      + beta5 * YearSinceRemodel;

  y ~ normal(mu, sigma);
}

generated quantities {
  vector[N] mu;
  vector[N] y_rep;
  vector[N] log_lik;

  mu = beta0
      + beta1 * OverallQual
      + beta2 * LogGrLivArea
      + beta3 * GarageCars
      + beta4 * TotalBsmtSF
      + beta5 * YearSinceRemodel;

  for (n in 1:N) {
    y_rep[n] = normal_rng(mu[n], sigma);
    log_lik[n] = normal_lpdf(y[n] | mu[n], sigma);
  }
}
