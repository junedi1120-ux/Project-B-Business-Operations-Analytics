# Hypothesis Register and Evidence Labels

This register labels simulation mechanisms and exploratory questions. v1 results were inspected before v2 generation; this is not an untouched preregistered confirmatory study.

| ID | Classification | Question to test later | Evidence rule |
|---|---|---|---|
| H1 | Pre-embedded mechanism | Does Mid-market show a longer onboarding cycle and higher completed-record SLA breach rate than SMB and Enterprise? | Report as a simulated, pre-embedded mechanism. Do not use causal language. |
| H2 | Pre-embedded mechanism | Is APAC Enterprise Proposal-to-Won conversion lower than other proposal segments? | Report as a simulated, pre-embedded mechanism. |
| H3 | Pre-embedded mechanism | Among Large deals, is lower logged follow-up activity frequency associated with lower win rate? | Includes Completed and No Response; report association, not causality. |
| H4 | Exploratory comparison | How does closed win rate differ by lead source at opportunity grain? | Show group counts and percentage-point differences. The 5-point descriptive threshold is a chosen convention, not a statistical equivalence test; an inconclusive result is acceptable. |

## Required labels in later outputs

- **Pre-embedded mechanism:** included in the simulated data-generation logic.
- **Exploratory finding:** not pre-embedded and found after the dataset freeze.
- **No material observed difference:** an exploratory comparison below the chosen practical threshold, not proof of no effect.
- **Inconclusive:** retained when sample size, generation dependence or confounding prevents a useful interpretation. No discovery or null outcome is required.

No label implies causation. Every later finding must cite its SQL output and dashboard measure.
