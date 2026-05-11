# iOS TestFlight Release

This repo is wired for GitHub Actions + Fastlane TestFlight uploads from a macOS runner.

## App Store Connect

- App name: `Poise`
- Bundle ID: `com.poiseai.app`
- App Store Connect app ID: `6768316006`
- SKU: `poise-ai-ios`
- Primary language: English
- Distribution: TestFlight internal testing first

Create an App Store Connect API key with App Manager or Admin access. Apple only lets the `.p8` private key be downloaded once.

## GitHub Repository Settings

Set these repository secrets:

- `APPLE_TEAM_ID`: Apple Developer Team ID
- `ASC_KEY_ID`: App Store Connect API key ID
- `ASC_ISSUER_ID`: App Store Connect issuer ID
- `ASC_KEY_P8`: the full `.p8` private key content
- `IOS_PROVISIONING_PROFILE_BASE64`: base64 content of the provisioning profile
- `IOS_PROVISIONING_PROFILE_UUID`: provisioning profile UUID

Set this repository variable:

- `IOS_BUNDLE_ID`: `com.poiseai.app`
- `APP_STORE_APP_ID`: `6768316006`

## Release

Run **Actions > iOS TestFlight > Run workflow**, or push a tag matching `v*` or `ios-v*`.

The workflow runs `flutter analyze`, `flutter test`, builds a signed iOS archive with automatic App Store Connect signing, then uploads the IPA to TestFlight without waiting for Apple processing.
