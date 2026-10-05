# R Weekly Claude Code Skills

Claude Code skills that automate the weekly editor workflow. Each skill lives in its own folder as a `SKILL.md`.

## How to use them

1. Open Claude Code from the **repo root** (`rweekly.org/`). The skills use paths relative to the root, such as `draft.md` and `scripts/`.
2. Type the skill as a slash command, e.g. `/curate`.

All skills set `disable-model-invocation: true`, so Claude never runs them on its own. You have to start each one with its slash command. Several of them stop and wait for your confirmation partway through.

## Weekly workflow

| Order | Command             | When                         | What it does |
|-------|---------------------|------------------------------|--------------|
| 1     | `/curate`           | After Saturday's curatinator run | Classifies `curatinator_latest.md` RSS posts and CRANberries packages into `draft.md` sections, then checks for duplicates |
| 2     | `/highlights-poll`  | Once the draft is frozen (Sunday) | Picks 10 highlight candidates and outputs two Slack `/poll` commands for `#highlights` |
| 3     | `/highlight-images` | After the vote, once `### Highlight` is filled | Finds, resizes, and pushes images for the 3 highlights to `rweekly/image`, then embeds them in `draft.md` |
| 4     | `/release`          | Monday                       | Validates the draft, writes `_posts/DATE-YEARWEEK.md`, and resets `draft.md` for next week |
| —     | `/reset-draft`      | As needed                    | Resets a stale `draft.md` for the next issue and carries over links added since the last release |

## Skills

### `/curate`
Fills `draft.md` with this week's content.
- Checks open PRs first and waits if there are any.
- Re-runs `scripts/curatinator.R` only if `curatinator_latest.md` is stale. Outside the Nix env, this needs `tidyRSS`, `RCurl`, `pkgsearch`, and `OPENAI_API_KEY`.
- Fetches each RSS post to confirm it's R-related before adding it.
- Keeps the top ~40 new and ~25 updated CRAN packages by last-week downloads.
- Never touches `### Highlight` or `### Quotes of the Week`.

**Needs:** `gh` CLI, R.

### `/highlights-poll`
Generates the editor poll.
- Lists every draft link by section and marks duplicates from recent issues with `[DUP]`.
- Suggests 10 picks and re-checks that each is actually R-related. Waits for you to confirm.
- Outputs two `/poll` commands with 5 items each, ready to paste into Slack.

**Needs:** R (for `scripts/find_duplicates.R`).

### `/highlight-images`
Adds images for the 3 chosen highlights. It has three review gates:
1. confirm the image candidates,
2. confirm the resized files before pushing,
3. confirm the embed lines before editing `draft.md`.

Embeds go under each link's **original section**, not under `### Highlight`.

**Needs:**
- The `rweekly/image` repo cloned locally. The path is currently hardcoded to `/Users/sam/Documents/01-projects/rweekly-image` in `SKILL.md`, so update it for your machine.
- The `rweekly.tools` R package (for `upload_image()`) and `magick` (for SVG conversion).
- Push access to `rweekly/image`.

### `/release`
Publishes the issue.
- Hard checks: `### Highlight` isn't empty, no section is empty, and the draft has at least 3 images.
- Advisory check: duplicate links. You decide whether to keep them.
- Writes `_posts/YYYY-MM-DD-YYYY-Www.md` with a title summarizing the highlights, then resets `draft.md` from `for-editor-only-draft.txt` with the next week number.
- Doesn't commit or push. Review the diff and commit yourself.

### `/reset-draft`
Recovers when `draft.md` still holds an issue that's already published, for example because `/release`'s reset step was skipped.
- Works out the next issue number from the latest file in `_posts/`.
- Finds draft links that aren't in the last published post (usually contributor PRs merged since the release) and lists them for you to confirm.
- Rewrites `draft.md` from `for-editor-only-draft.txt` and puts those links back in their sections. `### Highlight` starts empty.
- Stops without changes if the draft is already reset. Doesn't commit.

**Needs:** nothing beyond the repo.

## Adding or editing a skill

Create `.claude/skills/<name>/SKILL.md` with YAML front matter (`name`, `description`, `allowed-tools`, and `disable-model-invocation: true` for editor-triggered workflows), then add a row to the tables above.
