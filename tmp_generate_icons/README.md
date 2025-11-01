# Generate App Icons from SVG

This directory contains scripts to automatically generate all required iOS app icon sizes from the SVG logo.

## Method: svg2png (Java-based tool)

Based on the [Stack Overflow solution](https://stackoverflow.com/questions/51381016/what-is-the-best-way-of-converting-a-svg-into-app-icons-for-both-ios-and-android).

## Prerequisites

1. **Java** - Required to run svg2png.jar
   - Check if installed: `java -version`
   - Install if needed: Download from https://www.java.com/

2. **svg2png.jar** - Download from:
   - GitHub: https://github.com/sterlp/svg2png
   - Releases: https://github.com/sterlp/svg2png/releases
   - Place `svg2png.jar` in this directory (`tmp_generate_icons/`)

## Usage

### Step 1: Download svg2png.jar

```bash
# Option A: Download manually
# Go to: https://github.com/sterlp/svg2png/releases
# Download svg2png.jar
# Place it in: tmp_generate_icons/

# Option B: Using wget/curl (if available)
cd tmp_generate_icons
# Download latest release (update URL with actual release)
curl -L -o svg2png.jar https://github.com/sterlp/svg2png/releases/download/v1.0.0/svg2png.jar
```

### Step 2: Generate Icons

```bash
cd tmp_generate_icons
chmod +x generate_icons.sh copy_icons.sh
./generate_icons.sh
```

This will:
- Generate all required PNG sizes from the SVG
- Save them in `temp_output/` directory

### Step 3: Copy to AppIcon Asset

```bash
./copy_icons.sh
```

This will:
- Copy all PNG files to `Assets.xcassets/AppIcon.appiconset/`
- Update `Contents.json` with proper file references

### Step 4: Clean and Rebuild

1. In Xcode: **Product → Clean Build Folder** (⇧⌘K)
2. Delete the app from simulator
3. **Product → Build** (⌘B)
4. **Product → Run** (⌘R)

## Alternative: If svg2png doesn't work

You can use other tools:

### Using ImageMagick (if installed)
```bash
convert -background none app_logo.svg -resize 1024x1024 app_logo-1024x1024@1x.png
```

### Using macOS built-in tools
1. Open SVG in Preview
2. Export as PNG at 1024x1024
3. Use online tools like https://makeappicon.com/ to generate all sizes

## Files Generated

The script generates these icon sizes:
- 20x20 (1x, 2x, 3x) - iPhone notification icons
- 29x29 (1x, 2x, 3x) - Settings icons
- 40x40 (1x, 2x, 3x) - Spotlight icons
- 60x60 (2x, 3x) - App icons
- 76x76 (1x, 2x) - iPad app icons
- 83.5x83.5 (2x) - iPad Pro app icons
- 1024x1024 (1x) - App Store icon

