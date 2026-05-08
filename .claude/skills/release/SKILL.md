---
name: release
description: Publish the current R Weekly draft as a new weekly post. Use when an editor invokes /release or asks to "release", "publish", or "create the weekly post" from draft.md. Validates the draft before creating the file in _posts/.
disable-model-invocation: true
allowed-tools: Read, Write, Bash
---

# R Weekly Release

Publish `draft.md` as a new weekly issue in `_posts/`. Run pre-flight checks first — stop if any fail.

## Pre-flight Checks

Read `draft.md` and verify all three conditions. Report every failure found before stopping.

### Check 1: Non-empty Highlight section

The `### Highlight` section must contain at least one content line (a line starting with `+`, `*`, or `-`). If it is empty, report: "FAIL: ### Highlight section is empty. Editors must add content before releasing."

### Check 2: No empty sections

Every `### SECTION` block must have at least one non-blank line of content before the next `###` or end of file. A line is "content" if it is not blank and does not start with `###`.

List every empty section found. Report: "FAIL: The following sections are empty: [list]. Remove them or add content before releasing."

> Note: sections with only boilerplate HTML (like the CRANberries link in New Packages or the podcast link in Videos and Podcasts) count as non-empty — they have content lines.

### Check 3: At least 3 images

Count lines containing either a Markdown image `![...](...)` or an HTML `<img` tag in the draft body (not the front matter). If fewer than 3, report: "FAIL: Only N image(s) found. At least 3 are required."

If **any check fails**, stop and show all failures. Do not create the post file.

---

## Creating the Release

If all checks pass, proceed:

### Step 1: Compute date and week

Run in Bash:
```bash
echo "DATE=$(date +%Y-%m-%d)" && echo "YEARWEEK=$(date +%G-W%V)"
```

This gives you e.g. `DATE=2026-03-09` and `YEARWEEK=2026-W11`.

### Step 2: Summarize the Highlight section in three words

Read the items listed under `### Highlight`. Pick three short, descriptive words that capture the key themes — typically package names, tools, or topics. No punctuation between them.

Example: if Highlight links cover tidymodels, a shiny app, and ggplot2 extensions, the summary might be `tidymodels shiny ggplot2`.

### Step 3: Build the filename

```
_posts/DATE-YEARWEEK.md
```

Example: `_posts/2026-03-09-2026-W11.md`

### Step 4: Compose the post

The post consists of:

1. A new front matter block (do NOT copy the draft's front matter):

```
---
title: R Weekly YEARWEEK WORD1 WORD2 WORD3
description: Weekly News in the R Community
image: https://rweekly.org/public/facebook.png
---
```

2. The body of `draft.md` — everything after the closing `---` of its front matter, exactly as-is.

### Step 5: Write the file

Use the Write tool to create `_posts/DATE-YEARWEEK.md` with the composed content.

### Step 6: Reset the draft

Read `for-editor-only-draft.txt` and overwrite `draft.md` with its contents, but update the title with the next week number. For example, if you just released `2026-W15`, change the title from `R Weekly 2026-W00` to `R Weekly 2026-W16` before writing.

### Step 7: Confirm

Tell the editor:
- The filename created
- The title used
- A one-line summary of what the Highlight section contains
