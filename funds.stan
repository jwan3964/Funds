data {
  int<lower=0> N;
  vector[N] y;
  vector[N] x[3];
}
parameters {
  vector[N] phi[3];
  vector[N] alpha;
  real<lower=0> sigmaphi;
  real<lower=0> sigmay;
  real<lower=0> sigmaa;
}
transformed parameters {
  vector[N] beta[3];
  beta[1] <- exp(phi[1])./(exp(phi[1])+exp(phi[2])+exp(phi[3]));
  beta[2] <- exp(phi[2])./(exp(phi[1])+exp(phi[2])+exp(phi[3]));
  beta[3] <- exp(phi[3])./(exp(phi[1])+exp(phi[2])+exp(phi[3]));
}
model {
  sigmay ~ cauchy(0,5);
  sigmaa ~ cauchy(0,5);
  sigmaphi ~ cauchy(0,5);

  for (i in 2:N) {
    alpha[i] ~ normal(alpha[i-1],sigmaa);
  }
  for (k in 1:3) {
    for (i in 2:N) {
      phi[k,i] ~ normal(phi[k,i-1],sigmaphi);
    }
  }
y  ~  normal(alpha + rows_dot_product(x[1],beta[1]) + rows_dot_product(x[2],beta[2]) + rows_dot_product(x[3],beta[3]),sigmay);
}
