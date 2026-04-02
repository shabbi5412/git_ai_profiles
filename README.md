# git_ai_profiles

Static hosting for **AI player profile pictures** used by the Ludo app. Update images here and redeploy this repo — no Ludo app store release required.

## Layout

| Path | Purpose |
|------|--------|
| `manifest.json` | Maps normalized AI names → image paths; `defaultProfile` is used when no per-name entry exists. |
| `profiles/` | Image files (PNG/WebP/JPEG). Keep each file **under 1 MB** (compressed). |

## Normalized names

For **Latin** names, normalize for lookup: **lowercase**, spaces → `_`, keep ASCII letters/digits/underscore (e.g. `Maryam Javed` → `maryam_javed`).

For **non‑Latin** names (Urdu, Cyrillic, Thai, Devanagari, etc.), use the **same script and spelling as in `names.dart`**, with **spaces → `_` only** (do **not** apply Latin-style `toLowerCase()`). Use that string as both the manifest key and the image filename stem (e.g. `ماہنور احمد` → `ماہنور_احمد`; `Юлия Фёдорова` → `Юлия_Фёдорова`). Do not transliterate to ASCII for the manifest key when the display name is not Latin.

The Ludo app must build the same lookup string so it matches `byNormalizedName` in `manifest.json`.

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
