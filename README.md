# vibe-proofread

A Grammarly replacement that costs nothing to run: paste text, get inline
edit suggestions (strikethrough → replacement, with a reason), accept or
revert each one, and copy the corrected result.

Single static page. No build, no tracking, no subscription. The text goes
only to the LLM endpoint you configure — LM Studio on localhost by default.

## Replaces

- **Grammarly** (~$144/yr) — context-aware grammar/style checking.

## Requirements

- Python 3 (for `serve.sh`), or any static file server.
- Any OpenAI-compatible chat endpoint:
  - **LM Studio** (recommended for privacy): load an instruct model, start
    the local server at `http://127.0.0.1:1234/v1`.
  - Or Ollama (`http://127.0.0.1:11434/v1`), a llama.cpp server, or a hosted
    provider (set an API key in Settings — your text then leaves the
    machine).

## Run

```bash
./serve.sh                 # binds 0.0.0.0:8000
# open http://127.0.0.1:8000

PORT=8080 ./serve.sh       # use a different port
```

Opening `index.html` directly (`file://`) also works if the LLM endpoint
sends permissive CORS headers (LM Studio does).

## Use

1. Open **Settings** and confirm the endpoint and model. Values persist in
   `localStorage`. Leave the API key blank for local endpoints.
2. Paste text, click **Proofread**.
3. Each suggestion shows `original → replacement` with a reason and a type.
   - **Revert** keeps the original text (dims the suggestion).
   - **Ignore** dismisses the suggestion the same way.
4. Click **Apply accepted → copy**. The remaining edits are applied and the
   result is copied to the clipboard.

## How it works

1. The page sends your text with a strict proofreader system prompt and asks
   for JSON edits: `{original, replacement, reason, type}`.
2. Only edits whose `original` is a verbatim substring of your text are
   shown — hallucinated spans are dropped (`parseEdits` in `index.html`).
3. Accepted edits are applied right-to-left so offsets stay valid.

## Deploy

The app is one static file. Copy `index.html` to any static host or open
it locally. There is no server-side component; the browser talks directly
to the configured LLM endpoint. If the endpoint is on another host, that
host must send CORS headers that allow the page's origin.

## Limitations

- Whole-text round trip per proofread; no streaming.
- Suggestion quality = model quality. A small local model catches typos and
  agreement errors but misses subtle style issues a larger model would flag.
- Clipboard write needs a secure context (`localhost` or `https`) or a
  browser permission; the page reports if the copy was blocked.
