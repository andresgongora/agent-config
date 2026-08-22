---
name: web-youtube
description: "Fetches YouTube video or channel metadata, captions, transcripts, and transcript-based summaries with yt-dlp. Use for YouTube URLs, video transcripts, caption availability, or video summaries. Not for broad web research, unsupported-platform URLs, media downloads, or generating a transcript from audio."
---

## Core rules

- Use `yt-dlp`; fetch metadata and captions without media download.
- Require `yt-dlp` on `PATH`; report missing dependency, do not install it.
- Captions are source material. Summary needs fetched captions; metadata or description alone cannot support a video summary.
- For metadata or summary, preserve language, caption type, URL, and timestamps when available. Transcript-only output follows its return contract.
- Do not claim transcript exists when no requested caption track downloads. Audio transcription needs separate explicit tooling.
- Do not download media unless user explicitly requests it.

## Workflow

Transcript-only request: calling agent runs this skill's scripts directly. Never delegate or transform caption text before returning it.

Interpretation request: calling agent delegates retrieval and analysis to a web executor. Pass original request and URL; executor returns compact result, not full transcript.

1. Fetch metadata first:

   ```bash
    scripts/youtube-captions metadata "$url"
   ```

2. Before transcript request, inspect tracks:

   ```bash
    scripts/youtube-captions tracks "$url"
   ```

3. Download requested-language captions to a task-owned temporary workspace. Request uploader captions plus automatic fallback. When language is absent, inspect tracks and choose platform's identified original-language track. `json3` preserves timed caption events.

    ```bash
    scripts/youtube-captions transcript "$language" plain "$url"
    ```

4. Replace `plain` with `timestamps` only when timestamps are requested. The helper extracts caption text from `json3` and cleans its task-owned workspace. Do not return raw JSON.
5. For "get transcript from <URL>": fetch metadata, inspect tracks, download best matching caption, then return transcript text only. Include timestamps only when requested. If no matching track, report unavailable with available tracks; do not summarize description as video content.
6. For "summarize <URL>": fetch transcript first. Summarize transcript only; label automatic captions. State caption language and omissions caused by unavailable captions.

## Return shape

Transcript-only request: return caption text only. No title, headings, source, provenance, language, summary, or commentary. Preserve timestamps only when requested. Caption failure: return blocker and available tracks.

Metadata or summary request:

```markdown
## Video
- Title: <title>.
- Channel: <channel>.
- Published: <date>.
- Duration: <duration>.
- Source: <canonical URL>.

## Transcript
- Captions: uploader | automatic.
- Language: <language>.
- Content: <timestamped transcript or requested excerpt>.

## Summary
<only when requested; transcript-based>
```

Omit unavailable fields. If captions fail, replace `## Transcript` with exact failure and available caption tracks.

## Boundaries

- Platform-native retrieval only. Cross-source discovery, corroboration, or external facts belong to general web research.
- Do not bypass age, login, paywall, geographic, or bot restrictions. State restriction; request user-provided authorized access only when needed.
- Search-result, channel, playlist, comments, or media-download workflows need explicit user scope before expanding beyond one video.

## Verification

- Metadata command completes without media download.
- Caption file exists before treating it as transcript source.
- Non-transcript-only response labels caption provenance and language.
