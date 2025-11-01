#!/bin/bash

# Script to generate iOS app icons from SVG using svg2png
# Based on: https://stackoverflow.com/questions/51381016/what-is-the-best-way-of-converting-a-svg-into-app-icons-for-both-ios-and-android

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SVG_FILE="$PROJECT_ROOT/Make a Habit/Assets.xcassets/AppIcon.appiconset/app_logo.svg"
OUTPUT_DIR="$PROJECT_ROOT/Make a Habit/Assets.xcassets/AppIcon.appiconset"
CONFIG_FILE="$SCRIPT_DIR/ios_icon.json"
TEMP_DIR="$SCRIPT_DIR/temp_output"

# Check if SVG file exists
if [ ! -f "$SVG_FILE" ]; then
    echo "❌ Error: SVG file not found at $SVG_FILE"
    exit 1
fi

echo "📦 Checking for svg2png tool..."
echo ""

# Check if svg2png.jar exists
JAR_FILE="$SCRIPT_DIR/svg2png.jar"
if [ ! -f "$JAR_FILE" ]; then
    echo "⚠️  svg2png.jar not found. Downloading..."
    echo ""
    echo "Please download svg2png from: https://github.com/sterlp/svg2png"
    echo "Or use one of these alternative methods:"
    echo ""
    echo "Method 1: Download manually"
    echo "  1. Go to: https://github.com/sterlp/svg2png/releases"
    echo "  2. Download svg2png.jar"
    echo "  3. Place it in: $SCRIPT_DIR/"
    echo ""
    echo "Method 2: Using Maven (if available)"
    if command -v mvn &> /dev/null; then
        echo "  Running: mvn dependency:get -Dartifact=com.sterlp:svg2png:1.0.0"
        mvn dependency:get -Dartifact=com.sterlp:svg2png:1.0.0 2>/dev/null || echo "  Maven download failed, try manual download"
    fi
    echo ""
    echo "After downloading, place svg2png.jar in this directory and run the script again."
    exit 1
fi

# Check if Java is available
if ! command -v java &> /dev/null; then
    echo "❌ Error: Java is not installed or not in PATH"
    echo "Please install Java to run svg2png.jar"
    exit 1
fi

echo "✅ Found svg2png.jar"
echo "✅ Java is available"
echo ""

# Create temp output directory
mkdir -p "$TEMP_DIR"

echo "🔄 Generating app icons from SVG..."
echo "   Input:  $SVG_FILE"
echo "   Output: $OUTPUT_DIR"
echo ""

# Run svg2png
# Note: The tool expects the base filename without extension
SVG_BASENAME="app_logo"
java -jar "$JAR_FILE" -f "$SVG_FILE" -o "$TEMP_DIR" -c "$CONFIG_FILE" || {
    echo ""
    echo "❌ Error: Failed to generate icons"
    echo "Trying alternative approach..."
    
    # Alternative: Try with different naming
    java -jar "$JAR_FILE" -f "$SVG_FILE" -o "$TEMP_DIR" -c "$CONFIG_FILE" -n "$SVG_BASENAME" || {
        echo "❌ svg2png conversion failed"
        echo ""
        echo "Please check:"
        echo "  1. SVG file is valid: $SVG_FILE"
        echo "  2. Config file is valid: $CONFIG_FILE"
        echo "  3. Java is working: java -version"
        exit 1
    }
}

echo ""
echo "✅ Icons generated successfully!"
echo ""

# List generated files
echo "Generated files:"
ls -lh "$TEMP_DIR"/*.png 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'

echo ""
echo "📋 Next steps:"
echo "  1. Review the generated PNG files in: $TEMP_DIR"
echo "  2. Copy them to: $OUTPUT_DIR"
echo "  3. Update Contents.json to reference the files"
echo ""
echo "Run the next script to complete setup: ./copy_icons.sh"

