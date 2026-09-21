# Usage: Rscript scripts/render.R [analysis|hierarchical|proposal] [html|pdf]
args <- commandArgs(trailingOnly = TRUE)
target <- if (length(args) >= 1L) args[[1]] else "analysis"
format <- if (length(args) >= 2L) args[[2]] else "html"
documents <- c(
  analysis = "analysis/final-project.Rmd",
  hierarchical = "analysis/hierarchical-model.Rmd",
  proposal = "archive/proposal/proposal.Rmd"
)
if (length(args) > 2L || !target %in% names(documents) ||
    !format %in% c("html", "pdf")) {
  stop("Usage: Rscript scripts/render.R [analysis|hierarchical|proposal] [html|pdf]",
       call. = FALSE)
}
if (!requireNamespace("rmarkdown", quietly = TRUE)) {
  stop("Install rmarkdown first; see docs/reproducibility.md.", call. = FALSE)
}
if (!rmarkdown::pandoc_available()) {
  stop("Pandoc is required; see docs/reproducibility.md.", call. = FALSE)
}

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(script_arg) != 1L) {
  stop("Run this script with Rscript.", call. = FALSE)
}
script_path <- normalizePath(sub("^--file=", "", script_arg), mustWork = TRUE)
root <- dirname(dirname(script_path))
stopifnot(file.exists(file.path(root, "Bayesian-Statistics-Project.Rproj")))
setwd(root)
output_dir <- file.path(root, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

rendered <- rmarkdown::render(
  input = file.path(root, documents[[target]]),
  output_format = paste0(format, "_document"),
  output_dir = output_dir,
  knit_root_dir = root,
  envir = new.env(parent = globalenv()),
  clean = TRUE
)
cat("Rendered:", rendered, "\n")
