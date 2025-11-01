# Creating the App Icon

To set up the app icon for iOS, you need a 1024x1024 PNG file.

## Option 1: Using Preview (macOS)
1. Open the SVG file: `Make a Habit/Assets.xcassets/AppIcon.appiconset/app_logo.svg`
2. File → Export
3. Format: PNG
4. Resolution: 1024x1024
5. Save as `AppIcon-1024.png`

## Option 2: Using Online Converter
1. Visit https://cloudconvert.com/svg-to-png or similar
2. Upload `app_logo.svg`
3. Set size to 1024x1024
4. Download and save as `AppIcon-1024.png`

## Option 3: Using Xcode Preview
1. Open `Resources/AppLogo.swift` in Xcode
2. Use the preview pane to view the logo
3. Take a screenshot at 1024x1024 resolution
4. Save as `AppIcon-1024.png`

## Adding to Xcode
1. Open `Assets.xcassets` → `AppIcon`
2. Drag `AppIcon-1024.png` into the 1024x1024 slot
3. Xcode will automatically generate all required sizes

