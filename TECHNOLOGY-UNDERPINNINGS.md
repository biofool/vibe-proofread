# vibe-proofread — Technology underpinnings

## Overview

The entire app is one file: `index.html` (~160 lines, markup + CSS + one
`<script>` block). No dependencies, no build step, no backend. The browser
calls an OpenAI-compatible chat-completions endpoint directly.

`serve.sh` is a four-line wrapper around `python3 -m http.server` that
binds `0.0.0.0:${PORT:-8000}` per repo convention.

## Feature → implementation map

**Settings (endpoint, model, API key).** The `<details>` panel in
`index.html` holds three inputs. They load from and save to `localStorage`
under the `vp_endpoint`, `vp_model`, and `vp_apikey` keys (script top,
lines 71–74). Nothing is hardcoded; the API key never leaves the browser.

**Proofread request.** The `Proofread` button handler (`$("go").onclick`,
line 85) POSTs to `{endpoint}/chat/completions` with:
- `temperature: 0` for deterministic output,
- `response_format: {type: "json_object"}` for structured output,
- `Authorization: Bearer <key>` only when a key is set.

**System prompt.** The `SYSTEM` constant (line 76) instructs the model to
act as a strict proofreader, not a ghostwriter. It requires JSON of the
form `{"edits":[{original, replacement, reason, type}]}`, forbids
restyling, and requires `original` to be a verbatim substring of the input.
Clean text returns `{"edits":[]}`.

**Hallucination filter — `parseEdits(raw, text)` (line 113).** Parses the
response (with a `{...}` regex fallback for models that wrap JSON in
prose), then keeps only edits whose `original` is a verbatim substring of
the source (`text.indexOf`). First occurrence wins; duplicates at the same
offset are dropped via a `seen` set. This is the core correctness guard —
CLAUDE.md forbids weakening it.

**Suggestion list — `render(text)` (line 129).** Builds one `.edit` div
per suggestion: `<s>original</s> → replacement` plus a `type — reason`
line and Revert / Ignore buttons. Text is inserted via `textContent`, so
model output cannot inject HTML.

**Accept / revert state.** Each edit record carries `accepted` and
`rejected` flags. The buttons toggle the flags and `refresh(i)` (line 148)
dims rejected rows (opacity 0.4). All edits start accepted.

**Apply + copy — `$("apply").onclick` (line 150).** Filters to accepted,
non-rejected edits, sorts them right-to-left by offset, and splices each
`replacement` into the text. Right-to-left ordering keeps earlier offsets
valid as the string shrinks or grows. The result replaces the textarea
content and is written to the clipboard via `navigator.clipboard`, with a
fallback status message when the clipboard is blocked.

**Styling.** Inline CSS with a small custom-property palette
(`--bg`, `--panel`, `--add`, `--del`, `--accent`). Two-column grid that
collapses to one column under 900 px.

## Repo conventions and tooling

- `CLAUDE.md` — project rules: single-file app, runtime-only settings,
  verbatim-substring verification must not be weakened.
- `.claude/settings.json` + `.claude/hooks/post_edit_lint.py` — a
  PostToolUse hook that runs fast checks on every edited file (ruff or
  `py_compile` for `.py`, `php -l`, `node --check`, `bash -n` +
  shellcheck, `json.tool`, `gofmt`, YAML safe-load). Each check no-ops
  when its tool is absent. Findings print to stderr and exit 2.
- `wiki/` — mini wiki: `Home.md`, `Architecture.md`, `Development.md`,
  `Security.md` (repo layout, commands, 2026-10 audit outcome).
- `LICENSE` — MIT.

## Data flow

```
textarea → fetch(endpoint/chat/completions, SYSTEM + text)
        → JSON edits → parseEdits (verbatim-substring filter)
        → render (accept/revert UI)
        → apply right-to-left splices → textarea + clipboard
```

No server-side state, no analytics, no outbound calls except the single
LLM request.
