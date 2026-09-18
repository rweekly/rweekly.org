---
name: curate
description: Guide the R Weekly curation team through preparing a new weekly issue. Reads curatinator_latest.md, classifies posts by section, checks for duplicates, and populates draft.md. Use when an editor wants to process the weekly content pipeline.
disable-model-invocation: true
allowed-tools: Read, Edit, Bash, Grep, WebFetch
---

# R Weekly Release Curation

## Live Context

- Current draft: !`cat draft.md`

## Your Task

You are helping the R Weekly curation team prepare the weekly issue. Work through the candidate content from `curatinator_latest.md` and populate `draft.md`.

### Classification Rules

For each **RSS POST**, decide:

1. **Is it R-related?** Fetch and read the actual page content for every item before deciding — do not infer relatedness from the title, author, or domain alone. A post on a known R blogger's site or a stats-adjacent title can still be off-topic (e.g. a general statistics/data-ethics essay with no R content). If not R-related, skip it entirely.
2. **Is it already in the draft or flagged as a duplicate?** If so, skip it.
3. **Which section does it belong to?**

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

For **CRANberries NEW** entries: add under `### New Packages` -> `**CRAN**`.
For **CRANberries UPDATED** entries: add under `### Updated Packages`.
RSS posts announcing a package release (e.g. "RcppArmadillo 15.6.0-1 on CRAN") also go under `### Updated Packages`.
Bioconductor and GitHub packages go under `### New Packages` -> `**Bioconductor**` / `**GitHub or Bitbucket or GitLab**`.

> Do NOT add anything to `### Highlight` — editors vote for that section separately.
> Do NOT touch `### Quotes of the Week` — it uses raw social-embed HTML, added by hand.

### Link Format

```
+ [Title](URL)
```

For packages, keep the CRANberries description, and the diffify link for updated packages. Some descriptions wrap onto a second line in `curatinator_latest.md`: join them back into one line.

```
+ [{pkgname} version](https://cran.r-project.org/package=pkgname): Description - [diffify](https://diffify.com/R/pkgname)
```

Images (optional, editor discretion):

```
![Alt text](https://raw.githubusercontent.com/...)
```

### Fetching Page Content

To inspect a URL's content before classifying it, use any of:
- **WebFetch tool** — built-in; use it directly.
- `curl https://r.jina.ai/https://www.example.com` — fallback if WebFetch fails.
- `curl https://defuddle.md/example.com` — second fallback.
- `npx defuddle parse https://www.example.com --markdown` — third fallback if defuddle.md itself is down or rate-limited; runs the same extraction locally with no dependency on the hosted proxy.

### Steps

1. **Check open PRs** with `gh pr list --repo rweekly/rweekly.org`. If any are open, tell the user and **wait** for their go-ahead before continuing.
1. **Collect content** — only if `curatinator_latest.md` is missing or stale (the Saturday GitHub Action normally refreshes it): `Rscript -e 'source("scripts/curatinator.R")'`. This scrapes the network and overwrites the file, so skip it when the file is already current.
   - Stale = its CRAN packages already appear in the last `_posts/` issue (a recent mtime proves nothing).
   - Outside the Nix env, first check `Rscript -e 'library(tidyRSS); library(RCurl); library(pkgsearch)'` and that `OPENAI_API_KEY` is set: otherwise the RSS section comes out empty without any error.
1. **Read** `curatinator_latest.md` (the current `draft.md` is already loaded in Live Context above). Optionally parse it with `Rscript -e 'source("scripts/parse_curinator.R")'` for a tidy view.
1. **Process RSS POSTS**: for each link, classify and add to the correct section in `draft.md`. Skip non-R content.
1. **Process CRANberries NEW**: add new CRAN packages under `### New Packages` -> `**CRAN**`.
1. **Process CRANberries UPDATED**: add updated packages under `### Updated Packages`.
   - For both lists, keep only the most popular packages (about 40 new, 25 updated), ranked by last-week downloads: `curl -s 'https://cranlogs.r-pkg.org/downloads/total/last-week/pkg1,pkg2,...'`.
1. **Edit `draft.md`** using the Edit tool to insert the new links into the appropriate sections.
1. **Check duplicates** (after editing, so new links are checked too): `Rscript -e 'source("scripts/find_duplicates.R"); get_dups()'`; remove any flagged URLs.
1. **Report** a summary:
   - How many RSS posts were added (and to which sections)
   - How many CRAN new/updated packages were added
   - How many items were skipped (not R-related or duplicates)
   - Any items that were ambiguous and need editor review

Keep the existing content and structure of `draft.md` intact. Add new links at the bottom of each section, above any closing HTML comments.
