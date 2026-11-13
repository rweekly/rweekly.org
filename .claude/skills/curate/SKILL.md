---
name: curate
description: Guide the R Weekly curation team through preparing a new weekly issue. Reads curatinator_latest.md, classifies posts by section, checks for duplicates, and populates draft.md. Use when an editor wants to process the weekly content pipeline.
disable-model-invocation: true
allowed-tools: Read, Edit, Bash, Grep, WebFetch
---

# R Weekly Release Curation

You are helping the R Weekly curation team prepare the weekly issue. Work through the candidate content from `curatinator_latest.md` and populate `draft.md`.

## Steps

1. **Check open PRs**: `gh pr list --repo rweekly/rweekly.org`. If any are open, tell the user and **wait** for their go-ahead before continuing.
2. **Build the digest**: `Rscript scripts/curate_prep.R`, then Read `/tmp/curate_digest.md`. It holds:
   - a staleness verdict for `curatinator_latest.md` (the Saturday GitHub Action normally refreshes it);
   - the RSS posts not already in `draft.md` or the last 20 issues, each with a text excerpt of the page;
   - the top ~40 new and ~25 updated CRAN packages by last-week downloads, as ready-to-paste lines.

   If it says STALE or that a CRANberries section FAILED: `Rscript -e 'source("scripts/curatinator.R")'` (scrapes the network and overwrites the file), then rebuild the digest. Outside the Nix env, first check `Rscript -e 'library(tidyRSS); library(RCurl); library(pkgsearch)'`: `get_rss.R` swallows feed errors, so a broken setup yields an empty RSS section with no error.
3. **Read `draft.md`** (Edit requires it).
4. **Classify each RSS post** from its excerpt with the rules below. Decide from the content, never from the title, author or domain alone: a post on a known R blogger's site can still be off-topic. If the excerpt is missing or doesn't settle it, fetch the page (see Fetching Page Content). Skip non-R content.
5. **Edit `draft.md`**, one Edit per section: append the new links at the bottom of the section, above any closing HTML comment. Paste the package lines as-is under `### New Packages` -> `**CRAN**` and `### Updated Packages`.
6. **Check duplicates**: `Rscript -e 'source("scripts/find_duplicates.R"); get_dups()'`; remove any flagged URL.
7. **Report**: posts added per section, packages added (new / updated), items skipped (not R-related, duplicates), items that need editor review.

Keep the existing content and structure of `draft.md` intact.

## Classification Rules

| Section in draft.md               | Use when                                                                |
| --------------------------------- | ----------------------------------------------------------------------- |
| `### Tutorials`                   | R tutorials showing how to use packages/tools; code is usually embedded |
| `### Insights`                    | Articles about R and data science in general; usually no code           |
| `### R in the Real World`         | Analyses using R on real-world data                                     |
| `### R in Organizations`          | R use cases in organizations / companies                                |
| `### R in Academia`               | R use cases in academic / research settings                             |
| `### Videos and Podcasts`         | Videos, screencasts, podcasts about R                                   |
| `### Resources`                   | Books, slides, cheatsheets, websites, longer learning resources         |
| `### Gist & Cookbook`             | Short code snippets, gists, recipes                                     |
| `### Shiny Apps`                  | Shiny applications                                                      |
| `### R Internationally`           | Non-English R content                                                   |
| `### R Project Updates`           | Updates from R Core / R-devel (base R, NEWS)                            |
| `### Call for Participation`      | R groups, competitions, community calls                                 |
| `### Upcoming Events in 3 Months` | Upcoming R events (max 3 links)                                         |
| `### Grants & Funding`            | Grants, funding opportunities related to R                              |
| `### Datasets`                    | Newly released or noteworthy datasets                                   |
| `### Connect`                     | R jobs, communities                                                     |
| `### rtistry`                     | Generative art made with R                                              |

RSS posts announcing a package release (e.g. "RcppArmadillo 15.6.0-1 on CRAN") go under `### Updated Packages`.
Bioconductor and GitHub packages go under `### New Packages` -> `**Bioconductor**` / `**GitHub or Bitbucket or GitLab**`.

> Do NOT add anything to `### Highlight` — editors vote for that section separately.
> Do NOT touch `### Quotes of the Week` — it uses raw social-embed HTML, added by hand.

## Link Format

```
+ [Title](URL)
```

Escape any `|` in a title as `\|` (e.g. `[Talk \| Speaker \| Series](URL)`). Kramdown otherwise renders the line as a table. YouTube titles often contain pipes.

Package lines come ready-made from the digest:

```
+ [{pkgname} version](https://cran.r-project.org/package=pkgname): Description - [diffify](https://diffify.com/R/pkgname)
```

Images (optional, editor discretion):

```
![Alt text](https://raw.githubusercontent.com/...)
```

## Fetching Page Content

When the digest excerpt isn't enough, inspect the page with any of:
- **WebFetch tool** — built-in; use it directly.
- `curl https://r.jina.ai/https://www.example.com` — fallback if WebFetch fails.
- `curl https://defuddle.md/example.com` — second fallback.
- `npx defuddle parse https://www.example.com --markdown` — third fallback if defuddle.md itself is down or rate-limited; runs the same extraction locally with no dependency on the hosted proxy.
