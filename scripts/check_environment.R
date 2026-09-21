# Read-only checks for the full baseline analysis. Run with Rscript.
required <- c(
  "ggplot2", "dplyr", "corrplot", "car", "bayesplot",
  "posterior", "distr", "rmarkdown", "knitr", "cmdstanr"
)

cat("R:", as.character(getRversion()), "\n")
r_ok <- getRversion() >= "4.1.0"
if (!r_ok) cat("R 4.1 or newer is required for the native pipe.\n")

available <- vapply(required, requireNamespace, logical(1), quietly = TRUE)
for (pkg in required) {
  version <- if (available[[pkg]]) {
    as.character(utils::packageVersion(pkg))
  } else {
    "MISSING"
  }
  cat(sprintf("%-12s %s\n", pkg, version))
}

pandoc_ok <- available[["rmarkdown"]] && rmarkdown::pandoc_available()
cat("Pandoc:", if (pandoc_ok) "available" else "MISSING", "\n")

stan_version <- if (available[["cmdstanr"]]) {
  tryCatch(cmdstanr::cmdstan_version(), error = function(e) NULL)
} else {
  NULL
}
stan_ok <- length(stan_version) > 0L && !is.na(stan_version[1])
cat("CmdStan:", if (stan_ok) as.character(stan_version) else "MISSING", "\n")
cat("C++ toolchain and optional LaTeX are not checked by this script.\n")

ok <- r_ok && all(available) && pandoc_ok && stan_ok
if (!ok) cat("See docs/reproducibility.md for setup instructions.\n")
quit(status = if (ok) 0L else 1L)
