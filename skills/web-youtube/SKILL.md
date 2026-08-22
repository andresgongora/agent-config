---
name: web-youtube
description: "Fetches YouTube video or channel metadata, captions, transcripts, and transcript-based summaries with yt-dlp. Use for YouTube URLs, video transcripts, caption availability, or video summaries. Not for broad web research, unsupported-platform URLs, media downloads, or generating a transcript from audio."
---

# web-youtube

## Core rules

- Use `yt-dlp`; fetch metadata and captions without media download.
- Require `yt-dlp` on `PATH`; report missing dependency, do not install it.
- Captions are source material. Summary needs fetched captions; metadata or description alone cannot support a video summary.
- Distinguish uploader captions from automatic captions. Preserve language, caption type, URL, and timestamps when available.
- Do not claim transcript exists when no requested caption track downloads. Audio transcription needs separate explicit tooling.
- Do not download media unless user explicitly requests it.

## Workflow

1. Fetch metadata first:

   ```bash
   yt-dlp --no-playlist --skip-download \
     --print 'title=%(title)s' \
     --print 'channel=%(channel)s' \
     --print 'published=%(upload_date>%Y-%m-%d)s' \
     --print 'duration=%(duration_string)s' \
     --print 'description=%(description)s' \
     "$url"
   ```

2. Before transcript request, inspect tracks:

   ```bash
   yt-dlp --no-playlist --skip-download --list-subs "$url"
   ```

3. Download requested-language captions to temporary workspace. Request uploader captions plus automatic fallback. When language is absent, inspect tracks and choose platform's identified original-language track. `json3` preserves timed caption events.

   ```bash
   yt-dlp --no-playlist --skip-download \
     --write-subs --write-auto-subs \
     --sub-langs "$language" --sub-format json3 \
     -o "$tempdir/%(id)s.%(ext)s" "$url"
   ```

4. For "get transcript from <URL>": fetch metadata, inspect tracks, download best matching caption, then return transcript. Include timestamps unless user asks plain text. If no matching track, report unavailable; do not summarize description as video content.
5. For "summarize <URL>": fetch transcript first. Summarize transcript only; label automatic captions. State caption language and omissions caused by unavailable captions.

## Return shape

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
- Response labels caption provenance and language.
