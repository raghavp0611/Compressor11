# Shrinkwrap

Batch image compressor that runs entirely in the browser. Drop 100+ images, set a size limit
(default 200 KB), get a ZIP back. Nothing is uploaded anywhere.

## Files

- `shrinkwrap.html` — the page source (published as a Claude artifact). No `<html>`/`<head>` wrapper on purpose.
- `index.html` — standalone build of the same page. Open it directly, email it, or host it on any static host
  (Vercel, Netlify, GitHub Pages). Regenerate it after editing `shrinkwrap.html` with `./build.sh`.
- `build.sh` — wraps `shrinkwrap.html` into `index.html`.

## How compression works

1. Each image is decoded and re-encoded inside a pool of Web Workers (one per CPU core, up to 8), so the page
   stays responsive and all cores are used.
2. Images are first capped to the "longest side" limit, then encoded at quality 82. If that fits the budget,
   quality is raised to 92 when there is room.
3. If it does not fit, the bytes-per-pixel of that first encode predicts how far to shrink; the search then
   bisects quality between the chosen floor and 85 until the output is within 6% of the limit.
4. Typical cost is 2 encodes for easy files and 5 to 6 for large ones. Files already under the limit are
   passed through untouched (toggleable).
5. ZIP packing uses STORE (no deflate), since JPEG/WebP data does not compress further.

## Hosting

No backend, no database, no Vercel or Supabase required. The Claude artifact link is the easiest way to share.
If you prefer your own URL, upload `index.html` to any static host.

## Limits

- HEIC/HEIF (iPhone) files decode only in Safari. Chrome and Firefox will mark them as failed.
- Output is JPEG, or WebP for PNG inputs when the browser can encode WebP. Transparent PNGs sent to JPEG
  get a white background.
- EXIF metadata is dropped from re-encoded files (orientation is applied first).
