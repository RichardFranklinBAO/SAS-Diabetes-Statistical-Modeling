# Data dictionary and safe sharing

Only **synthetic** data are included in this public-facing portfolio. Individual-level original course records are intentionally excluded pending appropriate data-sharing authorization.

| Column | Type | Meaning |
| --- | --- | --- |
| `id` | Integer | Synthetic row identifier |
| `race` | Integer 1–4 | Four group labels corresponding to the course scenario |
| `wtkg` | Float | Simulated body weight (kg) |
| `gluc` | Integer | Simulated glucose value (mg/dL) |
| `hba1c` | Float | Simulated HbA1c (%) |

The CSV has 487 simulated observations, generated independently from a pseudorandom distribution (fixed seed) with no individual-level original rows used as inputs. Its relationship coefficients, distributions, and statistical outcomes **are not the course study results**. Do not use this synthetic data for any medical conclusion.
