---
name: highlight-images
description: Find, download, resize, and embed images for the three Highlight links in draft.md. Fetches each article, picks a representative image, runs upload_image() to push to the rweekly/image repo, then inserts the image embed below each highlight link in draft.md. Has human-in-the-loop review gates before downloading, before pushing to GitHub, and before editing draft.md.
disable-model-invocation: true
allowed-tools: Read, Edit, Bash, WebFetch
---

# Highlight Images

Automates the image workflow for the `### Highlight` section of `draft.md`.

There are three human review gates — **do not skip them**:
1. Before downloading: confirm all three candidate image URLs with the editor
2. Before pushing: confirm the resized images in the local image repo look good
3. Before editing draft.md: confirm the final embed URLs

## Prerequisites

- `rweekly-image` repo cloned at `/Users/sam/Documents/01-projects/rweekly-image`
- `scripts/img_raw/` directory exists (create if not: `mkdir -p scripts/img_raw`)
- `rweekly.tools` R package installed

## Steps

### Step 1: Get issue week and highlight links

Read `draft.md`:
- Extract issue week from `title:` front matter (e.g. `R Weekly 2026-W25` → `W25`)
- Extract all three links from the `### Highlight` section (lines matching `+ [Title](URL)`)

The image repo target dir will be `2026/{WEEK}` (e.g. `2026/W25`).

### Step 2: For each highlight link, find a good image

For each of the three highlight articles:

1. Fetch the article URL with WebFetch. Ask: "What is the main representative image on this page? Give me the full absolute image URL (prefer PNG, JPG, or WebP — avoid icons/logos/avatars/favicons). If there are multiple, pick the one most representative of the article content."
2. **OG image fallback**: If the article body only has SVGs, generated plots, or no good raster image, check the page's `og:image` / `twitter:image` meta tags:
   ```bash
   curl -s "{URL}" | grep -i 'og:image\|twitter:image'
   ```
3. **SVG fallback**: If the best available image is an SVG (common with knitr/R Markdown posts), note it — it will need conversion in Step 4. raw.githubusercontent.com serves SVG as `text/plain`, so SVGs cannot be embedded directly via `![]()`.
4. **No image found**: If neither article body, OG tags, nor SVG yield a candidate, say so and ask the editor to supply a URL or skip the embed for that highlight.
5. If WebFetch fails entirely, try Jina: `curl https://r.jina.ai/{URL}` and scan for image URLs.
6. Pick a short kebab-case slug for each filename (e.g. `history-posit-agents`, `three-dots-readable`, `ulam-prime-spiral`).

---

### ⏸ GATE 1 — Confirm image candidates with the editor

Present a summary of all three candidates before downloading anything:

```
Proposed images:
1. [Article title]
   URL: {image-url}
   Slug: {slug}

2. [Article title]
   URL: {image-url}
   Slug: {slug}

3. [Article title]
   URL: {image-url}
   Slug: {slug}

Do these look good, or would you like to swap any out?
```

**Wait for explicit confirmation before proceeding.** The editor may supply a different URL — use whatever they provide.

---

### Step 3: Download images to img_raw

For each confirmed image:

```bash
curl -L -o "scripts/img_raw/{slug}.{ext}" "{image-url}"
```

Save with the original file extension (`.png`, `.jpg`, `.webp`, `.svg`).

If an image is an **SVG**, convert it to PNG using R magick immediately after download:
```bash
Rscript -e '
library(magick)
img <- image_read("scripts/img_raw/{slug}.svg")
img_resized <- image_resize(img, "600x")
image_write(img_resized, "scripts/img_raw/{slug}-chart.png", format="png")
cat("done\n")
'
```
Use `{slug}-chart.png` as the file going forward. (System ImageMagick has rsvg support even without the R `rsvg` package.)

Verify all files are present and non-empty:
```bash
ls -lh scripts/img_raw/
```

If any download fails (404, empty file), stop and ask the editor for an alternative.

### Step 4: Resize images with `upload_image()` — push=FALSE

Run `upload_image()` for each image with **`push = FALSE`** — this resizes and copies to the local image repo but does NOT push to GitHub yet:

```bash
Rscript -e '
library(rweekly.tools)
upload_image(
  file = "scripts/img_raw/{slug}.{ext}",
  caption = "",
  width = "600",
  issue = "2026/{WEEK}",
  image_repo = "/Users/sam/Documents/01-projects/rweekly-image",
  push = FALSE
)
cat("done\n")
'
```

Note: `upload_image()` appends `_600` to the filename (e.g. `ulam-prime-spiral.png` → `ulam-prime-spiral_600.png`).

Run all three sequentially. Then list the result:
```bash
ls -lh /Users/sam/Documents/01-projects/rweekly-image/2026/{WEEK}/
```

---

### ⏸ GATE 2 — Confirm resized images before pushing to GitHub

Tell the editor:

```
Resized images are ready in /Users/sam/Documents/01-projects/rweekly-image/2026/{WEEK}/:
  {slug}_600.{ext}  ({size})
  {slug}_600.{ext}  ({size})
  {slug}_600.{ext}  ({size})

Please review the files (open them locally if you'd like).
Ready to push to the rweekly/image GitHub repo?
```

**Wait for the editor to confirm before pushing.**

---

### Step 5: Push to GitHub

Once the editor confirms, push the image repo:

```bash
cd /Users/sam/Documents/01-projects/rweekly-image && git add 2026/{WEEK}/ && git commit -m "Add W{WEEK} highlight images" && git push
```

Check for errors. If push fails due to auth, let the editor know they should push manually from the image repo.

---

### ⏸ GATE 3 — Confirm embed URLs before editing draft.md

Show the editor the three embed lines that will be inserted, noting which section each goes into:

```
Ready to insert into draft.md (in each link's original section, not in ### Highlight):

[Insights] ![A brief and biased history of...](https://raw.githubusercontent.com/rweekly/image/master/2026/{WEEK}/{slug1}_600.{ext})
[Tutorials] ![Three small dots for...](https://raw.githubusercontent.com/rweekly/image/master/2026/{WEEK}/{slug2}_600.{ext})
[Gist & Cookbook] ![Little useless-useful...](https://raw.githubusercontent.com/rweekly/image/master/2026/{WEEK}/{slug3}_600.{ext})

OK to insert?
```

**Wait for confirmation.**

---

### Step 6: Insert image embeds into draft.md

Image embeds go in each link's **original section** (e.g. Insights, Tutorials, Gist & Cookbook) — NOT in the `### Highlight` section. The Highlight section contains only the bare links.

For each highlight link, find its duplicate in the original section and insert the image embed immediately after that line:

```
+ [Title](article-url)
![Title](https://raw.githubusercontent.com/rweekly/image/master/2026/{WEEK}/{slug}_600.{ext})
```

Use the Edit tool. Image alt text should match the link title exactly.

### Step 7: Verify

Read back the `### Highlight` section of `draft.md` to confirm all three embeds are in place and correctly formatted.

## Notes

- Highlight links are **copies** — they stay in both `### Highlight` and their original section. Image embeds go **only** under the original-section copy — never under the `### Highlight` copy, which stays bare links only.
- Image filenames: short, lowercase, kebab-case slugs — no dates or issue numbers.
- `upload_image()` always appends `_600` to the resized output filename.
- `scripts/img_raw/` is gitignored — safe to use as temporary staging.
- If `upload_image()` is unavailable, fall back to: `cp scripts/img_raw/{slug}.png /Users/sam/Documents/01-projects/rweekly-image/2026/{WEEK}/` then push manually.
