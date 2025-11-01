#!/bin/bash

# Script to help create the app icon PNG from SVG
# This uses macOS built-in tools

SVG_FILE="Make a Habit/Assets.xcassets/AppIcon.appiconset/app_logo.svg"
OUTPUT_FILE="AppIcon-1024.png"

echo "Creating 1024x1024 PNG from SVG..."

# Check if we're in the right directory
if [ ! -f "$SVG_FILE" ]; then
    echo "Error: SVG file not found at $SVG_FILE"
    echo "Make sure you're running this from the project root directory"
    exit 1
fi

# Try using qlmanage to convert (macOS built-in)
if command -v qlmanage &> /dev/null; then
    echo "Converting SVG to PNG using macOS Preview..."
    qlmanage -t -s 1024 -o . "$SVG_FILE" 2>/dev/null
    if [ -f "app_logo.png" ]; then
        mv "app_logo.png" "$OUTPUT_FILE"
        echo "✅ Created $OUTPUT_FILE"
        echo ""
        echo "Next steps:"
        echo "1. Open Xcode"
        echo "2. Click on 'Assets.xcassets' in the Project Navigator"
        echo "3. Click on 'AppIcon' (the icon item, not the folder)"
        echo "4. Drag $OUTPUT_FILE into the 1024x1024 slot"
        echo "5. Clean build folder (Shift+Cmd+K) and rebuild"
    else
        echo "⚠️  Automatic conversion failed. Please use one of these methods:"
        echo ""
        echo "Method 1: Using Preview (Recommended)"
        echo "  1. Double-click $SVG_FILE to open in Preview"
        echo "  2. File → Export..."
        echo "  3. Format: PNG"
        echo "  4. Resolution: 1024 x 1024"
        echo "  5. Save as AppIcon-1024.png"
        echo ""
        echo "Method 2: Online Converter"
        echo "  1. Go to https://cloudconvert.com/svg-to-png"
        echo "  2. Upload $SVG_FILE"
        echo "  3. Set size to 1024x1024"
        echo "  4. Download and save as AppIcon-1024.png"
    fi
else
    echo "Please use one of these methods to create the PNG:"
    echo ""
    echo "Method 1: Using Preview (Recommended)"
    echo "  1. Double-click $SVG_FILE to open in Preview"
    echo "  2. File → Export..."
    echo "  3. Format: PNG"
    echo "  4. Resolution: 1024 x 1024"
    echo "  5. Save as AppIcon-1024.png"
    echo ""
    echo "Method 2: Online Converter"
    echo "  1. Go to https://cloudconvert.com/svg-to-png"
    echo "  2. Upload $SVG_FILE"
    echo "  3. Set size to 1024x1024"
    echo "  4. Download and save as AppIcon-1024.png"
fi

