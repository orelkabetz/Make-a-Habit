#!/bin/bash

# Script to copy generated icons and update Contents.json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMP_DIR="$SCRIPT_DIR/temp_output"
OUTPUT_DIR="$PROJECT_ROOT/Make a Habit/Assets.xcassets/AppIcon.appiconset"
CONTENTS_JSON="$OUTPUT_DIR/Contents.json"

# Check if icons were generated
if [ ! -d "$TEMP_DIR" ] || [ -z "$(ls -A "$TEMP_DIR"/*.png 2>/dev/null)" ]; then
    echo "❌ Error: No generated icons found in $TEMP_DIR"
    echo "Please run generate_icons.sh first"
    exit 1
fi

echo "📋 Copying icons to AppIcon.appiconset..."
echo ""

# Copy all PNG files
cp "$TEMP_DIR"/*.png "$OUTPUT_DIR/"

echo "✅ Icons copied successfully!"
echo ""

# Update Contents.json
echo "🔄 Updating Contents.json..."

cat > "$CONTENTS_JSON" << 'EOF'
{
  "images" : [
    {
      "filename" : "app_logo-20x20@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "app_logo-20x20@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    {
      "filename" : "app_logo-29x29@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "app_logo-29x29@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "29x29"
    },
    {
      "filename" : "app_logo-40x40@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "app_logo-40x40@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "40x40"
    },
    {
      "filename" : "app_logo-60x60@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "60x60"
    },
    {
      "filename" : "app_logo-60x60@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "60x60"
    },
    {
      "filename" : "app_logo-20x20@1x.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "20x20"
    },
    {
      "filename" : "app_logo-20x20@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "app_logo-29x29@1x.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "29x29"
    },
    {
      "filename" : "app_logo-29x29@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "app_logo-40x40@1x.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "40x40"
    },
    {
      "filename" : "app_logo-40x40@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "app_logo-76x76@1x.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "76x76"
    },
    {
      "filename" : "app_logo-76x76@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "76x76"
    },
    {
      "filename" : "app_logo-83.5x83.5@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "83.5x83.5"
    },
    {
      "filename" : "app_logo-1024x1024@1x.png",
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "✅ Contents.json updated!"
echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "  1. In Xcode, refresh the Assets.xcassets folder (right-click → Refresh)"
echo "  2. Clean build folder: Product → Clean Build Folder (⇧⌘K)"
echo "  3. Delete app from simulator and rebuild"
echo "  4. The app icon should now appear on the home screen!"

