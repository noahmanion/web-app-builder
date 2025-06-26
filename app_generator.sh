#!/bin/bash

# Prompt for App Name and URL using AppleScript dialogs
APP_NAME=$(osascript -e 'Tell application "System Events" to display dialog "Enter App Name:" default answer ""' -e 'text returned of result')
APP_URL=$(osascript -e 'Tell application "System Events" to display dialog "Enter App URL:" default answer "https://"' -e 'text returned of result')

if [ -z "$APP_NAME" ] || [ -z "$APP_URL" ]; then
  osascript -e 'display dialog "App name and URL are required." buttons {"OK"}'
  exit 1
fi

# Paths
APP_DIR="$HOME/Documents/ChromeApps"
LAUNCH_SCRIPT="$APP_DIR/launch_${APP_NAME// /_}.command"
APP_TARGET="$HOME/Applications/${APP_NAME}.app"
FAVICON_PATH="/tmp/${APP_NAME// /_}_favicon.icns"

mkdir -p "$APP_DIR"

# Create the Chrome App Mode launcher script
echo "#!/bin/bash" > "$LAUNCH_SCRIPT"
echo "open -na \"Google Chrome\" --args --app=\"$APP_URL\"" >> "$LAUNCH_SCRIPT"
chmod +x "$LAUNCH_SCRIPT"

# Download the favicon
FAVICON_HOST=$(echo "$APP_URL" | awk -F/ '{print $1 "//" $3}')
curl -s -L -o /tmp/favicon.ico "$FAVICON_HOST/favicon.ico"

# Convert favicon to icns using sips if possible
if [ -f /tmp/favicon.ico ]; then
  sips -s format png /tmp/favicon.ico --out /tmp/favicon.png >/dev/null 2>&1
  sips -Z 128 /tmp/favicon.png --out /tmp/favicon_128.png >/dev/null 2>&1
  mkdir -p /tmp/icon.iconset
  cp /tmp/favicon_128.png /tmp/icon.iconset/icon_128x128.png
  iconutil -c icns /tmp/icon.iconset -o "$FAVICON_PATH"
else
  FAVICON_PATH=""
fi

# Use Platypus to wrap the .command as a .app
platypus --name "$APP_NAME" --interface-type "None" --interpreter "/bin/bash" --app-icon "$FAVICON_PATH" \
  --bundled-file "$LAUNCH_SCRIPT" --scripts "$LAUNCH_SCRIPT" "$APP_TARGET"

# Let user know
osascript -e 'display dialog "Your app has been created and saved to ~/Applications." buttons {"OK"}'
