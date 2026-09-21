# Original report snapshots

[Back to the project overview](../README.md)

| File | Pages | Description |
| :--- | ---: | :--- |
| [final-report.pdf](final-report.pdf) | 10 | Final narrative report, originally `STAT405_Final_Report.pdf` |
| [analysis-notebook.pdf](analysis-notebook.pdf) | 46 | Executed baseline notebook, originally `Final-project.pdf` |
| [hierarchical-model-original.pdf](hierarchical-model-original.pdf) | 1 | Original model note, originally `complex.pdf` |

All three PDFs are preserved byte-for-byte from the original repository. They
have not been regenerated after the source files were organized. As a result,
printed code paths may refer to the former flat directory layout.

The hierarchical-model prose in the original PDFs specifies a uniform prior on
the intercept/slope correlation, while the Stan implementation uses LKJ(2).
The current [editable specification](../analysis/hierarchical-model.Rmd) follows
the implementation. See [methodology notes](../docs/methodology.md) for details.

New renders go to the ignored `outputs/` directory. The final narrative report
has no corresponding editable narrative source in the original submission;
`analysis/final-project.Rmd` generates the analysis notebook, not that report.
