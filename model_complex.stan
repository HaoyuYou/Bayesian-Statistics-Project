data {
  int<lower=1> N;
  int<lower=1> J;
  array[N] int<lower=1, upper=J> neighborhood;

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

  vector<lower=0>[2] tau;

  cholesky_factor_corr[2] L_Omega;

  matrix[2, J] z_u;
}

transformed parameters {
  matrix[2, J] u;
  vector[J] alpha;
  vector[J] gamma;
  vector[N] mu;

  u = diag_pre_multiply(tau, L_Omega) * z_u;

  alpha = to_vector(u[1]');
  gamma = to_vector(u[2]');

  for (i in 1:N) {
    mu[i] =
      beta0
      + alpha[neighborhood[i]]
      + (beta2 + gamma[neighborhood[i]]) * LogGrLivArea[i]
      + beta1 * OverallQual[i]
      + beta3 * GarageCars[i]
      + beta4 * TotalBsmtSF[i]
      + beta5 * YearSinceRemodel[i];
  }
}

model {
  beta0 ~ normal(8.8, 0.05);
  beta1 ~ normal(0.10, 0.03);
  beta2 ~ normal(0.25, 0.08);
  beta3 ~ normal(0.06, 0.03);
  beta4 ~ normal(0.00010, 0.00003);
  beta5 ~ normal(-0.003, 0.004);

  tau[1] ~ normal(0, 0.12);
  tau[2] ~ normal(0, 0.05);

  sigma ~ normal(0, 0.10);

  L_Omega ~ lkj_corr_cholesky(2.0);

  to_vector(z_u) ~ normal(0, 1);

  y ~ normal(mu, sigma);
}

generated quantities {
  corr_matrix[2] Omega;
  matrix[2, 2] Sigma;
  vector[N] y_rep;

  Omega = multiply_lower_tri_self_transpose(L_Omega);
  Sigma = quad_form_diag(Omega, tau);

  for (i in 1:N) {
    y_rep[i] = normal_rng(mu[i], sigma);
  }
}
