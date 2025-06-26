# Web App Builder

Turn any website into a standalone Chrome-based Mac app in under 30 seconds.

## Why?

Modern work lives in the browser — but that also means constant distractions. This tool lets you isolate tools like BigQuery, Segment, or Snowflake into clean desktop apps, using Chrome App Mode and a simple GUI launcher.

## Features

- Uses Chrome App Mode for distraction-free UI
- Downloads and applies site favicon as app icon
- Creates `.app` files with Platypus
- Works with any URL
- Saved apps launch like native Mac apps

## Requirements

- macOS
- Google Chrome
- [Platypus](https://sveinbjorn.org/platypus) (`brew install --cask platypus`)

## Usage

1. Open the Web App Builder `.app`
2. Enter the App Name and URL
3. The new app appears in `~/Applications` with the favicon applied

## Manual Mode (optional)

```bash
chmod +x app_generator.sh
./app_generator.sh
```

## License

MIT
