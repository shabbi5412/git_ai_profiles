# git_ai_profiles

Static hosting for **AI player profile pictures** used by the Ludo app. Update images here and redeploy this repo — no Ludo app store release required.

## Layout

| Path | Purpose |
|------|--------|
| `manifest.json` | Maps normalized AI names → image paths; `defaultProfile` is used when no per-name entry exists. |
| `profiles/` | Image files (PNG/WebP/JPEG). Keep each file **under 1 MB** (compressed). |

## Normalized names

The app normalizes a profile name for lookup: lowercase, spaces → `_`, ASCII letters/digits/underscore only (non‑Latin names fall back to `defaultProfile` until you add a mapping).

Example — add a specific picture for “Alex Smith”:

```json
{
  "version": 1,
  "defaultProfile": "profiles/default.png",
  "byNormalizedName": {
    "alex_smith": "profiles/alex_smith.png"
  }
}
```

## Local testing (before GitHub)

1. From this directory run a static server, for example:
   ```bash
   python3 -m http.server 8787
   ```
2. On your **phone/emulator**, the Ludo debug build uses `http://<PC_LAN_IP>:8787/` (see Ludo `lib/constants/ai_profile_remote_config.dart` and `--dart-define=AI_PROFILE_BASE_URL=...`).
3. Android emulator: `http://10.0.2.2:8787/` if the server runs on the host machine.

## GitHub (production)

After you push this repo, set the raw base URL in Ludo (release) to:

`https://raw.githubusercontent.com/<YOUR_USER>/git_ai_profiles/main/`

Or pass at build time:

`flutter build apk --dart-define=AI_PROFILE_BASE_URL=https://raw.githubusercontent.com/<YOUR_USER>/git_ai_profiles/main/`

## CORS

`raw.githubusercontent.com` serves files with permissive headers for GET; static `python -m http.server` is fine for local dev.
