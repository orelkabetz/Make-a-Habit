# Quick App Icon Setup Guide

The app icon isn't showing because no PNG image has been added to the asset catalog yet. Follow these steps:

## Step 1: Create the PNG File (Choose One Method)

### ✅ Method 1: Using macOS Preview (Easiest)
1. In Finder, navigate to:
   ```
   Make a Habit/Assets.xcassets/AppIcon.appiconset/app_logo.svg
   ```
2. Double-click `app_logo.svg` to open in Preview
3. Go to **File → Export...**
4. Set:
   - **Format**: PNG
   - **Resolution**: 1024 x 1024 pixels
   - Make sure "Maintain aspect ratio" is checked
5. Save as `AppIcon-1024.png` on your Desktop

### Method 2: Using Terminal Script
Run this command in Terminal from the project root:
```bash
./create_app_icon.sh
```

### Method 3: Online Converter
1. Go to https://cloudconvert.com/svg-to-png
2. Upload: `Make a Habit/Assets.xcassets/AppIcon.appiconset/app_logo.svg`
3. Set width: 1024, height: 1024
4. Convert and download as `AppIcon-1024.png`

---

## Step 2: Add Icon to Xcode

1. **Open Xcode** with your project

2. **Open Assets Catalog:**
   - In the Project Navigator (left sidebar), find and click **`Assets.xcassets`**
   - You'll see folders like `AppIcon`, `AccentColor`, etc.
   - **Click on `AppIcon`** (the icon item itself, not just the folder)

3. **Add Your PNG:**
   - You'll see a grid/interface showing different icon size slots
   - Find the slot labeled **"App Icon - 1024pt"** or **"iOS App Icon - 1024 x 1024 pt"**
   - **Drag your `AppIcon-1024.png` file** from your Desktop into this slot
   - OR click the "+" icon in the slot and browse to select your PNG file

4. **Verify:**
   - You should see your logo image appear in the 1024x1024 slot
   - Xcode may show a note that it can generate other sizes from this one

---

## Step 3: Clean and Rebuild

1. **Clean Build Folder:**
   - In Xcode: **Product → Clean Build Folder** (⇧⌘K)

2. **Delete App from Simulator:**
   - On the simulator home screen, long-press the app icon
   - Tap the "X" to delete the app
   - (This ensures the new icon is used)

3. **Rebuild and Run:**
   - **Product → Build** (⌘B)
   - **Product → Run** (⌘R)

4. **Check:**
   - The app should appear on the simulator home screen with your logo icon!

---

## Troubleshooting

**Still don't see the icon?**
- ✅ Make sure the PNG is exactly 1024x1024 pixels
- ✅ Make sure you dragged it into the correct slot (1024x1024)
- ✅ Clean build folder (Shift+Cmd+K)
- ✅ Delete the app from simulator and reinstall
- ✅ Check the AppIcon asset shows your image when you click on it in Xcode

**Icon looks blurry?**
- Make sure your source PNG is high quality (1024x1024)

**Can't find the AppIcon in Xcode?**
- Look for "Assets.xcassets" in the Project Navigator
- Expand it to see "AppIcon"
- Click on the "AppIcon" item (it should highlight in blue when selected)

