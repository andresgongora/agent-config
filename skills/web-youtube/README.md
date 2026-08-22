# web-youtube

Fetch YouTube metadata and caption-backed transcripts through `yt-dlp`.

## Design intent

Keep YouTube retrieval platform-native and narrow. Verbatim transcripts run locally through skill scripts; extraction and summaries may use a web executor. Captions are source material; video description is not a substitute.

## When it triggers

YouTube URLs, video metadata, caption availability, transcripts, and summaries of captioned video.

## When it does NOT trigger

Broad web research, cross-source verification, non-YouTube URLs, media downloads, or speech-to-text from audio.

## Maintainer constraints

- Keep `yt-dlp` commands metadata/caption-only unless user requests media.
- Keep verbatim caption text out of delegated worker reports.
- Preserve manual versus automatic-caption provenance in output.
- Test command changes against a public video with captions.

## See also

- `../web-search/`: cross-web research routing.
- <https://github.com/yt-dlp/yt-dlp#subtitle-options>: upstream subtitle options.
