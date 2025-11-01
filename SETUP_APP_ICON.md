# How to Set Up the App Icon on iPhone Home Screen

Follow these steps to add your logo as the app icon:

## Step 1: Create a 1024x1024 PNG Image

You need to convert the SVG logo to a PNG file at 1024x1024 pixels.

### Method A: Using macOS Preview (Easiest)
1. Open the SVG file in Finder:
   - Navigate to: `Make a Habit/Assets.xcassets/AppIcon.appiconset/app_logo.svg`
   - Double-click to open in Preview
2. Export as PNG:
   - File → Export
   - Format: PNG
   - Set width: 1024, height: 1024 (Maintain aspect ratio)
   - Save as `AppIcon-1024.png` on your Desktop

### Method B: Using Online Converter
1. Go to: https://cloudconvert.com/svg-to-png
2. Upload: `Make a Habit/Assets.xcassets/AppIcon.appiconset/app_logo.svg`
3. Settings:
   - Width: 1024
   - Height: 1024
4. Convert and download as `AppIcon-1024.png`

### Method C: Using Xcode Preview
1. Open `Resources/AppLogo.swift` in Xcode
2. Open the Preview panel
3. Take a screenshot or export at 1024x1024 resolution

## Step 2: Add Icon to Xcode

1. **Open Assets Catalog:**
   - In Xcode, click on `Assets.xcassets` in the Project Navigator
   - Click on `AppIcon` (not the folder, the AppIcon item itself)

2. **Add the 1024x1024 Image:**
   - You'll see a grid with different icon sizes
   - Find the slot labeled "App Icon - 1024pt" or "iOS App Icon - 1024 x 1024 pt"
   - Drag your `AppIcon-1024.png` file into this slot
   - OR click the "+" button and select "iOS App Icon 1024pt" then drag your image

3. **Verify:**
   - The image should appear in the 1024x1024 slot
   - Xcode will automatically note that other sizes can be generated from this one

## Step 3: Build and Run

1. **Clean Build Folder:**
   - Product → Clean Build Folder (⇧⌘K)

2. **Build the App:**
   - Product → Build (⌘B)

3. **Run on Simulator:**
   - Select a simulator from the device menu
   - Product → Run (⌘R)

4. **Check the Icon:**
   - The app should appear on the simulator's home screen with your logo!

## Troubleshooting

**If the icon doesn't appear:**
- Make sure the PNG is exactly 1024x1024 pixels
- Clean build folder and rebuild
- Delete the app from simulator and reinstall
- Check that the image was added to the correct slot (1024x1024)

**If icon appears but looks blurry:**
- Make sure your source PNG is high quality (1024x1024)
- The SVG should be exported at full resolution

**Note:** For production/App Store submission, you may need all icon sizes, but for development and simulator testing, just the 1024x1024 version is sufficient.

