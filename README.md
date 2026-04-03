# git_ai_profiles

Static hosting for **AI player profile pictures** used by the Ludo app. Update images here and redeploy this repo — no Ludo app store release required.

## Layout

| Path | Purpose |
|------|--------|
| `manifest.json` | Maps normalized AI names → image paths; `defaultProfile` is used when no per-name entry exists. |
| `profiles/` | Image files (PNG/WebP/JPEG). Keep each file **under 1 MB** (compressed). |

## Normalized names (lookup keys)

The manifest keys and on-disk filenames use the **same rule the app must use** when resolving `AIProfile.name`:

1. `trim()` whitespace  
2. Replace each run of whitespace with a single `_`  
3. Apply Dart’s **`String.toLowerCase()`** on the result  

Examples: `Maryam Javed` → `maryam_javed`; `Юлия Фёдорова` → `юлия_фёдорова` (Cyrillic is lowercased); `ماہنور احمد` → usually unchanged for Arabic letters after step 2–3.

**Why:** Flutter/Dart lowercases Cyrillic. If the manifest used `Юлия_Фёдорова` but the app looked up `юлия_фёдорова`, the image would never load.

Copy the helper from this repo into Ludo:

`ludo/normalize_ai_profile_lookup_key.dart` → use `normalizeAiProfileLookupKey(profile.name)` as the map key into `byNormalizedName`.

**Loading the image URL:** build the final URI with `Uri.parse(baseUrl).resolve(path)` (or equivalent) so path segments with non‑ASCII characters are encoded correctly for `NetworkImage` / HTTP.

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
