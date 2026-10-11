<!-- AI coding config version: 2026-10-11 — sourced from biofool/starter template. -->

# CLAUDE.md

## Project overview

vibe-proofread — zero-dependency static HTML proofreader that replaces
Grammarly using any OpenAI-compatible LLM endpoint (LM Studio default).
One `index.html` file is the entire app; `serve.sh` hosts it locally.

## Commands

```bash
./serve.sh                 # serve on 0.0.0.0:8000 (open http://127.0.0.1:8000)
```

No build, no tests, no dependencies.

## Conventions

- Keep the app a single self-contained `index.html` — no bundlers.
- Endpoint/model/API key are runtime settings (localStorage), never
  hardcoded. Never commit secrets.
- All edits must be verified against the source text verbatim
  (`parseEdits` drops non-substring hallucinations) — do not weaken that.
