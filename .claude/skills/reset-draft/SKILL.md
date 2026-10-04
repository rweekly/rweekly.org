---
name: reset-draft
description: Reset draft.md from for-editor-only-draft.txt for the next R Weekly issue, carrying over any links contributors added after the last release. Use when draft.md still holds an already-published issue (e.g. /release's reset step was skipped).
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash
---

# Reset the R Weekly Draft

Replace `draft.md` with a fresh copy of `for-editor-only-draft.txt` for the next issue. Keep any content that was added after the last release (usually merged contributor PRs) so it isn't lost.

## Steps

### Step 1: Find the last published issue

```bash
ls _posts/ | sort | tail -1
```

For example, `2026-09-28-2026-W40.md` means the last issue was `2026-W40`, so the next one is `2026-W41`. Cross-check against `date +%G-W%V` and use whichever is later. At a year boundary, use the ISO week from `date`.

### Step 2: Check whether a reset is needed

Read `draft.md`'s `title:`.
- If it already names the next issue (e.g. `R Weekly 2026-W41`) and its `### Highlight` links aren't in the last post, the draft is already reset. Tell the editor and stop.
- If it names the last published issue, or `W00`, continue.

### Step 3: Find content to carry over

List every link in `draft.md` that isn't in the last published post:

```bash
LAST=_posts/$(ls _posts/ | sort | tail -1)
grep -oE '\]\(https?://[^)]+\)' draft.md | sort -u | while read l; do grep -qF "$l" "$LAST" || echo "$l"; done
```

Ignore the boilerplate links that are already in `for-editor-only-draft.txt`.

For each remaining link, record:
- its full entry from `draft.md` (the `+ [Title](URL)` line plus any description, wrapped continuation lines, and an image line directly under it), and
- its section heading.

Also look for non-link content that is new, such as embeds in `### rtistry` or `### Quotes of the Week` that aren't in the last post. Carry those over too.

### Step 4: Confirm with the editor

Show what will happen before writing anything:

```
Last published: 2026-W40 (_posts/2026-09-28-2026-W40.md)
draft.md currently: R Weekly 2026-W40 (stale)
New draft title: R Weekly 2026-W41

Carrying over N item(s):
  [Resources] + [Title](URL)
  [Tutorials] + [Title](URL)
  ...
```

**Wait for the editor's confirmation.**

### Step 5: Write the new draft

1. Read `for-editor-only-draft.txt` and change the title from `R Weekly YYYY-W00` to the next issue (e.g. `R Weekly 2026-W41`).
2. Use the Write tool to overwrite `draft.md` with it.
3. Use the Edit tool to put each carried-over entry back in its original section, keeping the exact text and the blank lines between entries.
4. Never carry anything into `### Highlight`; that section should start empty.

### Step 6: Verify and report

Re-run the Step 3 check against the new `draft.md`. Every carried-over URL should be present, and nothing from the last post should remain.

Tell the editor:
- the new title,
- how many items were carried over, and to which sections.

Don't commit. Let the editor review the diff.
