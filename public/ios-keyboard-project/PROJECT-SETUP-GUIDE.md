# Complete Xcode Project Setup Guide

## Step-by-Step Instructions

### 1. Create New Xcode Project

1. Open Xcode
2. Select **File > New > Project**
3. Choose **iOS > App**
4. Configure:
   - Product Name: `VoiceKeyboard`
   - Team: Your development team
   - Organization Identifier: `com.yourcompany`
   - Interface: **Storyboard** (or SwiftUI if iOS 14+)
   - Language: **Swift**
   - Include Tests: Optional
5. Click **Next** and choose a location
6. Click **Create**

### 2. Add Keyboard Extension Target

1. Select **File > New > Target**
2. Choose **iOS > Custom Keyboard Extension**
3. Configure:
   - Product Name: `VoiceKeyboardExtension`
   - Language: **Swift**
4. Click **Finish**
5. When prompted, click **Activate** for the new scheme

### 3. Configure App Groups (For API Key Sharing)

#### Main App Target:
1. Select your project in Project Navigator
2. Select **VoiceKeyboard** target
3. Go to **Signing & Capabilities** tab
4. Click **+ Capability**
5. Add **App Groups**
6. Click **+** and add: `group.com.yourcompany.voicekeyboard`

#### Keyboard Extension Target:
1. Select **VoiceKeyboardExtension** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **App Groups**
5. Click **+** and add: `group.com.yourcompany.voicekeyboard`

### 4. Add Source Files

#### Main App Files:
Copy these files to the VoiceKeyboard group:
- `AppDelegate.swift`
- `SceneDelegate.swift`
- `ViewController.swift`

#### Keyboard Extension Files:
Copy these files to the VoiceKeyboardExtension group:
- `KeyboardViewController.swift` (replace existing)
- `AudioRecorder.swift`
- `WhisperAPIClient.swift`
- `RecordButton.swift`

### 5. Configure Info.plist Files

#### Main App (VoiceKeyboard/Info.plist):
Replace with `Info-MainApp.plist` content

#### Keyboard Extension (VoiceKeyboardExtension/Info.plist):
Replace with `Info-KeyboardExtension.plist` content

**CRITICAL**: Ensure `RequestsOpenAccess` is set to `true` in keyboard extension Info.plist

### 6. Update Bundle Identifiers

1. Select **VoiceKeyboard** target
2. Go to **General** tab
3. Bundle Identifier should be: `com.yourcompany.VoiceKeyboard`

4. Select **VoiceKeyboardExtension** target
5. Bundle Identifier should be: `com.yourcompany.VoiceKeyboard.VoiceKeyboardExtension`

### 7. Set Deployment Target

1. Select **VoiceKeyboard** target
2. Set **iOS Deployment Target** to **14.0** (or higher)
3. Repeat for **VoiceKeyboardExtension** target

### 8. Configure Frameworks

Both targets should include:
- UIKit.framework
- AVFoundation.framework (for audio recording)
- Foundation.framework

These are included by default for iOS projects.

### 9. Build Settings

#### For Both Targets:

**Swift Language Version:**
- Set to **Swift 5** or later

**Optimization Level:**
- Debug: **No Optimization (-Onone)**
- Release: **Optimize for Speed (-O)**

#### Keyboard Extension Only:

**Memory Limit:**
Keyboard extensions have approximately 30MB memory limit. Keep this in mind when optimizing.

### 10. Build and Run

1. Select **VoiceKeyboard** scheme
2. Choose a physical device or simulator
3. Click **Run** (⌘R)

**Note**: Some microphone features may not work perfectly in simulator. Test on a physical device for full functionality.

## Project Structure

After setup, your project should look like this:

```
VoiceKeyboard.xcodeproj
├── VoiceKeyboard/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── ViewController.swift
│   ├── Info.plist
│   ├── Assets.xcassets/
│   ├── Main.storyboard (optional)
│   └── LaunchScreen.storyboard
│
└── VoiceKeyboardExtension/
    ├── KeyboardViewController.swift
    ├── AudioRecorder.swift
    ├── WhisperAPIClient.swift
    ├── RecordButton.swift
    ├── Info.plist
    └── Assets.xcassets/
```

## API Key Configuration

### Option 1: App Group Shared UserDefaults (Recommended)

The main app saves the API key to shared UserDefaults:
```swift
if let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.voicekeyboard") {
    sharedDefaults.set(apiKey, forKey: "groq_api_key")
}
```

The keyboard extension reads from shared UserDefaults:
```swift
if let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.voicekeyboard") {
    let apiKey = sharedDefaults.string(forKey: "groq_api_key")
}
```

### Option 2: Keychain (More Secure - Optional Enhancement)

For production apps, consider using iOS Keychain for secure API key storage.

## Testing Checklist

- [ ] Main app builds successfully
- [ ] Keyboard extension builds successfully
- [ ] App requests microphone permission
- [ ] API key can be saved in main app
- [ ] Keyboard appears in Settings > Keyboards
- [ ] "Allow Full Access" can be enabled
- [ ] Keyboard switches successfully
- [ ] Press and hold starts recording
- [ ] Release stops recording and triggers transcription
- [ ] Transcribed text appears at cursor
- [ ] Error messages display correctly
- [ ] Dark mode works properly
- [ ] Haptic feedback functions

## Common Issues and Solutions

### Issue: Keyboard not appearing in Settings
**Solution**: Ensure the keyboard extension Info.plist has correct NSExtension configuration

### Issue: Network requests fail
**Solution**: Verify "Allow Full Access" is enabled for the keyboard

### Issue: Microphone permission denied
**Solution**: Check NSMicrophoneUsageDescription in main app Info.plist

### Issue: App crashes on device
**Solution**: Check code signing and provisioning profiles

### Issue: Keyboard memory crash
**Solution**: Reduce audio quality or recording duration, profile with Instruments

## Next Steps

1. Get Groq API key from https://console.groq.com
2. Build and install main app on device
3. Configure API key in main app
4. Enable keyboard in iOS Settings
5. Enable "Allow Full Access"
6. Test in any app with text input

## Additional Resources

- [Apple Keyboard Extension Documentation](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/CustomKeyboard.html)
- [AVAudioRecorder Documentation](https://developer.apple.com/documentation/avfaudio/avaudiorecorder)
- [Groq API Documentation](https://console.groq.com/docs)
