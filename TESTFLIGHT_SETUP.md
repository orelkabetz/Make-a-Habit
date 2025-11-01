# TestFlight Setup Guide for "Make a Habit"

## Prerequisites

✅ **Apple Developer Account**: You need a paid Apple Developer account ($99/year)
- Sign up at: https://developer.apple.com/programs/
- Your current Bundle ID: `com.orelkabetz.Make-a-Habit`

✅ **App Store Connect Access**: Link your Developer account to App Store Connect
- Go to: https://appstoreconnect.apple.com/

---

## Step-by-Step Process

### Step 1: Prepare Your App in Xcode

1. **Open your project in Xcode**
   ```bash
   open "Make a Habit.xcodeproj"
   ```

2. **Configure Signing & Capabilities** (if not already done):
   - Select the project in Navigator
   - Select "Make a Habit" target
   - Go to "Signing & Capabilities" tab
   - Ensure "Automatically manage signing" is checked
   - Select your Team (your Apple Developer account)
   - Xcode will automatically create provisioning profiles

3. **Verify Bundle Identifier**:
   - Should be: `com.orelkabetz.Make-a-Habit`
   - Found in: Target → General → Bundle Identifier

4. **Check Deployment Target**:
   - Currently: iOS 18.2
   - For broader testing, consider lowering to iOS 17.0 (minimum for SwiftData)
   - This is in: Target → General → Deployment Info → iOS Deployment Target

---

### Step 2: Create App in App Store Connect

1. **Go to App Store Connect**
   - Visit: https://appstoreconnect.apple.com/
   - Sign in with your Apple Developer account

2. **Create New App**:
   - Click "My Apps" → "+" button → "New App"
   - Fill in:
     - **Platform**: iOS
     - **Name**: "Make a Habit"
     - **Primary Language**: English (or your preference)
     - **Bundle ID**: `com.orelkabetz.Make-a-Habit` (must match exactly!)
     - **SKU**: A unique identifier (e.g., "make-a-habit-001")
     - **User Access**: Full Access (or App Manager)
   - Click "Create"

---

### Step 3: Archive and Upload Your App

1. **Select "Any iOS Device" or "Generic iOS Device"** in the scheme selector (top bar in Xcode)

2. **Archive the App**:
   - Menu: **Product → Archive**
   - Wait for build to complete (may take a few minutes)
   - The Organizer window will open automatically

3. **Validate the Archive** (Optional but recommended):
   - In Organizer, select your archive
   - Click "Validate App"
   - Follow the prompts
   - Fix any issues if found

4. **Distribute to App Store Connect**:
   - In Organizer, select your archive
   - Click "Distribute App"
   - Select "App Store Connect"
   - Click "Next"
   - Select "Upload" (not "Export")
   - Choose distribution options (usually defaults are fine)
   - Select your team
   - Review and click "Upload"
   - Wait for upload to complete (progress shown in Organizer)

---

### Step 4: Set Up TestFlight

1. **Wait for Processing**:
   - After upload, go to App Store Connect
   - Your app will appear under "My Apps" → "Make a Habit"
   - Click on your app
   - Go to "TestFlight" tab
   - Wait for processing (usually 5-30 minutes)
   - Status will show "Processing" → "Ready to Submit"

2. **Configure TestFlight**:
   - Once processing is complete, you'll see your build
   - You may need to add:
     - **Export Compliance**: Answer questions about encryption
     - **Beta App Information**: Description, feedback email, etc.
     - **Beta Build Notes**: What's new in this build (e.g., "Initial TestFlight build")

---

### Step 5: Add Testers

#### Internal Testing (Up to 100 testers, immediate availability)

1. Go to TestFlight → "Internal Testing"
2. Create a new group (e.g., "Internal Testers")
3. Add testers:
   - They must be added as users in App Store Connect first
   - Go to "Users and Access" → "Users" → Invite users
   - Users need to accept invitation via email
   - Then add them to the Internal Testing group
4. Select your build
5. Click "Start Testing"

#### External Testing (Up to 10,000 testers, requires App Review)

1. Go to TestFlight → "External Testing"
2. Create a new group (e.g., "Beta Testers")
3. Add testers (via email addresses or App Store Connect users)
4. Submit for Beta App Review:
   - Fill out Beta App Information
   - Answer export compliance questions
   - Submit for review (usually takes 24-48 hours)

---

### Step 6: Invite Testers

**For Internal Testers**:
- They'll receive an email invitation
- They need to install TestFlight app from App Store
- Open the invitation link in TestFlight app
- Install your app

**For External Testers**:
- They'll receive an email invitation
- After App Review approval, they can install via TestFlight

---

## Quick Commands Reference

### Check your signing configuration:
```bash
# Open project
open "Make a Habit.xcodeproj"
```

### Archive from command line (alternative):
```bash
xcodebuild archive \
  -project "Make a Habit.xcodeproj" \
  -scheme "Make a Habit" \
  -configuration Release \
  -archivePath "./build/MakeAHabit.xcarchive"
```

---

## Common Issues & Solutions

### Issue: "No accounts available"
- **Solution**: Add your Apple ID in Xcode → Preferences → Accounts

### Issue: "Bundle identifier already exists"
- **Solution**: The bundle ID is already registered. Make sure you're using the correct one

### Issue: "Invalid bundle"
- **Solution**: Check that all required Info.plist keys are present

### Issue: "Missing compliance"
- **Solution**: Answer the export compliance questions in App Store Connect

### Issue: Processing taking too long
- **Solution**: This is normal. First builds can take up to an hour. Check back later.

---

## Testing Checklist

Before uploading, verify:
- [ ] App icon is set
- [ ] Bundle identifier matches App Store Connect
- [ ] Signing is configured correctly
- [ ] All features work in simulator/device
- [ ] No console errors or crashes
- [ ] Info.plist has required permissions (Notifications, Contacts)

---

## Next Steps After TestFlight

1. **Monitor Feedback**: Check TestFlight for crash reports and feedback
2. **Fix Issues**: Address any bugs found by testers
3. **Update Build**: Create new archive with fixes, upload again
4. **Submit for Review**: When ready, submit to App Store for public release

---

## Need Help?

- Apple Documentation: https://developer.apple.com/testflight/
- App Store Connect Help: https://help.apple.com/app-store-connect/
- Xcode Help: Product → Archive → (Right-click) → "Show in Finder"

