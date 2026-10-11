# vibe-proofread — Executive summary

vibe-proofread is a browser-based proofreader. It sends text to an LLM
endpoint and returns inline edit suggestions with a reason for each change.
The user accepts or reverts each suggestion and copies the corrected text.

## What it does for somatic studios and movement fields

Studios write often: class descriptions, workshop announcements, client
emails, intake forms, website copy, and documentation. Small errors in
that text cost time and reduce clarity. vibe-proofread addresses this:

- **Clearer client communication.** Catches grammar, spelling, and
  punctuation errors in emails and announcements before they are sent.
- **Cleaner documentation.** Flags unclear phrasing in consent forms,
  policies, and class descriptions, where precise wording matters.
- **No subscription.** Runs against a local model (LM Studio default).
  There is no per-seat fee and no recurring cost.
- **Privacy by default.** With a local endpoint, client-adjacent text
  stays on the machine. Nothing goes to a third party unless a hosted
  endpoint is configured.
- **No rewrite pressure.** The prompt tells the model to fix objective
  errors only, not to restyle. The writer's voice stays intact, which
  suits studios whose tone is part of their brand.
- **Human review stays in the loop.** Every suggestion is shown with a
  reason and must be accepted. The tool advises; the writer decides.

## Practical notes

- One static `index.html` file; no install, no build, no account.
- Suggestion quality depends on the model chosen. A local model covers
  common errors; a larger model catches subtler issues.
- Each suggestion must name a verbatim span of the source text.
  Hallucinated edits are dropped automatically.
