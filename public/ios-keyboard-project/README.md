# Voice-to-Text Keyboard Extension - iOS Project

## Project Overview
Custom iOS keyboard extension that uses voice transcription via Groq's Whisper API. This keyboard displays a single button for press-and-hold recording, then transcribes the audio and inserts text at the cursor position.

## Project Structure
```
VoiceKeyboard/
├── VoiceKeyboard/                    # Main App Target
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── ViewController.swift
│   ├── Info.plist
│   └── Assets.xcassets/
├── VoiceKeyboardExtension/           # Keyboard Extension Target
│   ├── KeyboardViewController.swift
│   ├── AudioRecorder.swift
│   ├── WhisperAPIClient.swift
│   ├── RecordButton.swift
│   ├── Info.plist
│   └── Assets.xcassets/
└── VoiceKeyboard.xcodeproj
```

## Technical Specifications

### Documented Assumptions
1. **Audio Format**: 16kHz mono WAV format (optimal for speech recognition)
2. **Maximum Recording Duration**: 60 seconds per recording
3. **Network Timeout**: 30 seconds for API requests
4. **Keyboard Height**: 
   - iPhone: 216 points
   - iPad: 264 points
5. **Supported iOS Versions**: iOS 14.0 and above
6. **Memory Considerations**: Keyboard extensions have ~30MB memory limit

### Required Capabilities
- Microphone access
- Network access
- Audio recording and processing
- Secure API key storage

## Setup Instructions

### 1. Create Xcode Project
```bash
# Open Xcode
# File > New > Project
# Choose "App" template
# Product Name: VoiceKeyboard
# Language: Swift
# User Interface: Storyboard (or SwiftUI for iOS 14+)
```

### 2. Add Keyboard Extension Target
```bash
# File > New > Target
# Choose "Custom Keyboard Extension"
# Product Name: VoiceKeyboardExtension
# Language: Swift
```

### 3. Configure Info.plist Files

#### Main App Info.plist
Add microphone permission:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This keyboard needs microphone access to record your voice for transcription.</string>
```

#### Keyboard Extension Info.plist
```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionAttributes</key>
    <dict>
        <key>IsASCIICapable</key>
        <false/>
        <key>PrefersRightToLeft</key>
        <false/>
        <key>PrimaryLanguage</key>
        <string>en-US</string>
        <key>RequestsOpenAccess</key>
        <true/>
    </dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.keyboard-service</string>
    <key>NSExtensionPrincipalClass</key>
    <string>$(PRODUCT_MODULE_NAME).KeyboardViewController</string>
</dict>
```

**Important**: `RequestsOpenAccess` must be `true` for network access (required for API calls).

### 4. Configure App Groups (Optional but Recommended)
For sharing data between main app and extension:
```bash
# Main App Target > Signing & Capabilities > + Capability > App Groups
# Add: group.com.yourcompany.voicekeyboard

# Repeat for Keyboard Extension Target
```

### 5. API Key Configuration

#### Option 1: UserDefaults with App Groups
Store API key in main app, access from extension via shared UserDefaults.

#### Option 2: Keychain (More Secure - Recommended)
Use iOS Keychain for secure storage.

### 6. Install Dependencies (If Any)
This project uses native iOS frameworks only, no external dependencies required.

## Building and Running

### 1. Build Main App
```bash
# Select VoiceKeyboard scheme
# Build and run on device or simulator
# Grant microphone permissions when prompted
```

### 2. Configure API Key
- Open main app
- Navigate to Settings
- Enter your Groq API key
- Save

### 3. Enable Keyboard
```bash
# iOS Settings > General > Keyboard > Keyboards > Add New Keyboard
# Select "VoiceKeyboard"
# Enable "Allow Full Access" (required for network access)
```

### 4. Test Keyboard
- Open any app with text input (Notes, Messages, etc.)
- Long-press globe icon to switch to VoiceKeyboard
- Press and hold the microphone button
- Speak clearly
- Release button
- Wait for transcription

## API Integration

### Groq Whisper API
**Endpoint**: `https://api.groq.com/openai/v1/audio/transcriptions`

**Required Headers**:
- `Authorization: Bearer YOUR_API_KEY`

**Request Format**: Multipart form data
- `file`: Audio file (WAV format)
- `model`: "whisper-large-v3"
- `language`: "en" (optional)

**Response Format**: JSON
```json
{
  "text": "Transcribed text here"
}
```

### Getting API Key
1. Sign up at https://console.groq.com
2. Navigate to API Keys section
3. Create new API key
4. Copy and store securely

## Testing Scenarios

### Functional Tests
1. ✅ Press and hold records audio
2. ✅ Release stops recording
3. ✅ Transcription appears at cursor
4. ✅ Visual feedback during states
5. ✅ Haptic feedback on interactions
6. ✅ Dark mode support

### Error Handling Tests
1. ✅ No internet connection
2. ✅ Invalid API key
3. ✅ API timeout
4. ✅ Microphone permission denied
5. ✅ Memory limit exceeded
6. ✅ Audio recording failure

## Memory Optimization

Keyboard extensions have strict memory limits (~30MB). Optimizations:
1. Release audio data immediately after upload
2. Use compressed audio format (16kHz mono)
3. Limit maximum recording duration
4. Avoid keeping large objects in memory
5. Monitor memory usage with Instruments

## Troubleshooting

### Keyboard Not Appearing
- Check extension is enabled in iOS Settings
- Verify "Allow Full Access" is enabled
- Restart device

### No Transcription
- Check internet connection
- Verify API key is configured
- Check API key has valid credits
- Review console logs for errors

### Audio Not Recording
- Check microphone permissions in main app
- Verify "Allow Full Access" is enabled
- Test on physical device (simulator microphone may have issues)

### Memory Crashes
- Reduce recording duration
- Lower audio quality settings
- Profile with Instruments

## Code Quality Notes

### Swift Best Practices Followed
- ✅ Strong typing throughout
- ✅ Proper error handling with Result types
- ✅ Protocol-oriented design
- ✅ MARK comments for organization
- ✅ Comprehensive inline documentation
- ✅ Memory management with weak references
- ✅ Thread safety for async operations
- ✅ Proper delegate patterns

### iOS Guidelines Compliance
- ✅ Extension size constraints respected
- ✅ Background execution limits considered
- ✅ User privacy respected
- ✅ Accessibility support
- ✅ Dark mode support

## Bonus Features (Optional)

### Implemented
- Haptic feedback
- Dark mode support
- Comprehensive error handling

### Not Implemented (Future Enhancements)
- Waveform visualization
- Offline mode with queue
- Multiple language support
- Unit tests
- Theme customization

## License
MIT License - See LICENSE file

## Author
[Your Name]
[Your Email]

## Acknowledgments
- Groq for Whisper API access
- Apple for iOS SDK documentation
