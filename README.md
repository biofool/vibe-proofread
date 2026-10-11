# vibe-proofread

A Grammarly replacement that costs nothing to run: paste text, get inline
edit suggestions (strikethrough → replacement, with a reason), accept or
revert each one, and copy the corrected result.

Single static page. No build, no tracking, no subscription. The text goes
only to the LLM endpoint you configure — LM Studio on localhost by default.

## Replaces

- **Grammarly** (~$144/yr) — context-aware grammar/style checking.

## Requirements

- Any OpenAI-compatible chat endpoint:
  - **LM Studio** (recommended for privacy): load any decent instruct model,
    start the local server at `http://127.0.0.1:1234/v1`.
  - Or Ollama (`http://127.0.0.1:11434/v1`), llama.cpp server, or a hosted
    provider (set an API key in Settings — note your text then leaves the
    machine).

## Run

```bash
./serve.sh            # binds 0.0.0.0:8000
# open http://127.0.0.1:8000
```

Opening `index.html` directly (`file://`) also works if the LLM endpoint
sends permissive CORS headers (LM Studio does).

## How it works

1. The page sends your text with a strict proofreader system prompt and asks
   for JSON edits: `{original, replacement, reason, type}`.
2. Only edits whose `original` is a verbatim substring of your text are shown —
   hallucinated spans are dropped.
3. Revert = keep original, Ignore = dismiss. **Apply accepted → copy** applies
   the remaining edits and puts the corrected text on the clipboard.

## Limitations

- Whole-text round trip per proofread; no streaming yet.
- Suggestion quality = model quality. A small local model catches typos and
  agreement errors but misses subtle style issues a frontier model would flag.
