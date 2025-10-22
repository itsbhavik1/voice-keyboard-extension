# Architecture Documentation

## System Overview

The Voice-to-Text Keyboard Extension consists of two main targets:
1. **Main App (VoiceKeyboard)**: Configuration and setup interface
2. **Keyboard Extension (VoiceKeyboardExtension)**: The actual custom keyboard

```
┌─────────────────────────────────────────────────────────────┐
│                         iOS System                           │
│  ┌─────────────────────┐      ┌───────────────────────────┐ │
│  │   Main App          │      │  Keyboard Extension       │ │
│  │  (VoiceKeyboard)    │◄────►│  (VoiceKeyboardExtension) │ │
│  │                     │      │                           │ │
│  │  • API Key Config   │      │  • Voice Recording        │ │
│  │  • Permissions      │      │  • Transcription          │ │
│  │  • Instructions     │      │  • Text Insertion         │ │
│  └─────────────────────┘      └───────────────────────────┘ │
│           │                              │                   │
│           │   App Groups                 │                   │
│           └──────────────┬───────────────┘                   │
│                          │                                   │
│                  ┌───────▼────────┐                          │
│                  │ Shared Storage │                          │
│                  │ (API Key)      │                          │
│                  └────────────────┘                          │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ HTTPS
                           ▼
                  ┌────────────────┐
                  │  Groq Whisper  │
                  │      API       │
                  └────────────────┘
```

## Component Architecture

### Main App (VoiceKeyboard)

#### Components:

**1. AppDelegate**
- Entry point for the application
- Handles app lifecycle events
- Manages scene sessions

**2. SceneDelegate**
- Manages window scenes
- Creates and presents ViewController

**3. ViewController**
- Main user interface
- Displays setup instructions
- Handles API key configuration
- Manages microphone permission requests
- Saves configuration to shared storage

**Data Flow:**
```
User Input → ViewController → UserDefaults (App Group) → Keyboard Extension
```

### Keyboard Extension (VoiceKeyboardExtension)

#### Component Diagram:

```
┌────────────────────────────────────────────────────────────┐
│                  KeyboardViewController                     │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  • Manages overall keyboard lifecycle                │  │
│  │  • Coordinates components                            │  │
│  │  • Handles user interactions                         │  │
│  │  • Updates UI based on state                         │  │
│  └──────────────────────────────────────────────────────┘  │
│           │              │              │                   │
│           ▼              ▼              ▼                   │
│  ┌────────────┐  ┌─────────────┐  ┌──────────────┐        │
│  │ RecordButton│  │AudioRecorder│  │WhisperAPIClient│       │
│  └────────────┘  └─────────────┘  └──────────────┘        │
│      │                  │                │                  │
│      │ Visual            │ Audio Data    │ Network          │
│      │ Feedback          │               │ Requests         │
│      │                  │                │                  │
│      ▼                  ▼                ▼                  │
│  UIKit/Core     AVFoundation     URLSession               │
│  Animation                                                  │
└────────────────────────────────────────────────────────────┘
```

#### Components Detail:

**1. KeyboardViewController**
- **Responsibilities:**
  - Main coordinator for keyboard functionality
  - Manages component lifecycle
  - Handles gesture recognition (long-press)
  - State management (idle, recording, processing, error)
  - UI updates and animations
  - Haptic feedback coordination
  - Text insertion via UITextDocumentProxy

- **Key Properties:**
  - `recordButton`: Custom UI button
  - `audioRecorder`: Audio recording manager
  - `apiClient`: API communication handler
  - `currentState`: Current keyboard state
  - `feedbackGenerator`: Haptic feedback provider

- **Key Methods:**
  - `startRecording()`: Initiates audio capture
  - `stopRecording()`: Stops capture and triggers transcription
  - `transcribeAudio()`: Sends audio to API
  - `insertTranscription()`: Inserts text at cursor
  - `updateUI()`: Updates visual state

**2. AudioRecorder**
- **Responsibilities:**
  - Audio session configuration
  - Audio recording management
  - File I/O for audio data
  - Duration limit enforcement
  - Error handling for audio operations

- **Key Properties:**
  - `audioRecorder`: AVAudioRecorder instance
  - `maxRecordingDuration`: 60 seconds limit
  - `audioSettings`: Optimized for speech (16kHz, mono, PCM)

- **Key Methods:**
  - `startRecording()`: Configures session and starts capture
  - `stopRecording()`: Stops capture and saves file
  - Delegate callbacks for completion/errors

- **Delegate Protocol:**
```swift
protocol AudioRecorderDelegate {
    func audioRecorder(_ recorder: AudioRecorder, didFinishRecording fileURL: URL)
    func audioRecorder(_ recorder: AudioRecorder, didFailWithError error: Error)
}
```

**3. WhisperAPIClient**
- **Responsibilities:**
  - API key retrieval from shared storage
  - Multipart form data request construction
  - Network request execution
  - Response parsing
  - Error handling and categorization

- **Key Properties:**
  - `baseURL`: Groq API endpoint
  - `model`: whisper-large-v3
  - `timeout`: 30 seconds

- **Key Methods:**
  - `transcribeAudio(fileURL:completion:)`: Main API call
  - `createMultipartRequest()`: Builds HTTP request
  - `parseErrorMessage()`: Extracts error details

- **Error Handling:**
```swift
enum WhisperAPIError: LocalizedError {
    case invalidAPIKey
    case networkError(Error)
    case invalidResponse
    case serverError(Int, String)
    case decodingError
    case fileReadError
    case timeout
}
```

**4. RecordButton**
- **Responsibilities:**
  - Visual representation of button
  - State-based animations
  - Touch feedback
  - Visual state transitions

- **Visual States:**
  - **Idle**: Blue background, white microphone icon
  - **Recording**: Red background, pulsing animation
  - **Processing**: Gray background, activity spinner
  - **Error**: Red background, shake animation

- **Animations:**
  - Pulse: Expanding red circle (recording)
  - Shake: Horizontal oscillation (error)
  - Scale: Touch feedback on press

## State Machine

### Keyboard States:

```
        ┌─────────────┐
        │    Idle     │◄──────────────┐
        └──────┬──────┘               │
               │                      │
        Press  │                      │ Timeout/Error
         Hold  │                      │
               ▼                      │
        ┌─────────────┐               │
        │  Recording  │               │
        └──────┬──────┘               │
               │                      │
       Release │                      │
               │                      │
               ▼                      │
        ┌─────────────┐               │
        │ Processing  │───────────────┤
        └──────┬──────┘               │
               │                      │
         Success                      │
               │                      │
               ▼                      │
        ┌─────────────┐               │
        │Text Inserted│───────────────┘
        └─────────────┘
```

### State Transitions:

| From State  | Event         | To State    | Actions                          |
|-------------|---------------|-------------|----------------------------------|
| Idle        | Touch Down    | Recording   | Start audio, show red, pulse     |
| Recording   | Touch Up      | Processing  | Stop audio, show spinner         |
| Processing  | API Success   | Idle        | Insert text, success haptic      |
| Processing  | API Error     | Error       | Show error, error haptic         |
| Error       | 2s Timer      | Idle        | Clear error, reset               |
| Recording   | 60s Timer     | Processing  | Auto-stop, process audio         |

## Data Flow

### Recording Flow:

```
User Press → Long Press Gesture Recognized
           ↓
    Check Microphone Permission
           ↓
    Configure Audio Session
           ↓
    Start AVAudioRecorder
           ↓
    Update UI (Red, Pulse)
           ↓
    Haptic Feedback
           ↓
    [User continues holding]
           ↓
    User Release → Stop AVAudioRecorder
           ↓
    Save Audio to Temp File
           ↓
    Update UI (Processing)
           ↓
    Read Audio File Data
```

### API Call Flow:

```
Audio File Data
    ↓
Retrieve API Key from UserDefaults
    ↓
Construct Multipart Request
    ├── Boundary
    ├── Model Parameter
    ├── Language Parameter
    └── Audio File Data
    ↓
Execute URLSession Request
    ↓
Wait for Response (30s timeout)
    ↓
Parse JSON Response
    ↓
Extract "text" Field
    ↓
Return to Main Thread
```

### Text Insertion Flow:

```
Transcription Text Received
    ↓
textDocumentProxy.insertText(text)
    ↓
textDocumentProxy.insertText(" ")
    ↓
Update UI (Success)
    ↓
Success Haptic
    ↓
Return to Idle State
    ↓
Clean up Audio File
```

## Threading Model

### Main Thread:
- All UI updates
- User interactions
- Gesture recognition
- State transitions
- Text insertion

### Background Threads:
- Audio recording (handled by AVFoundation)
- Network requests (handled by URLSession)

### Thread Safety:
```swift
// Network callback to main thread
DispatchQueue.main.async {
    self.updateUI(with: result)
}
```

## Memory Management

### Lifecycle:

**Keyboard Load:**
```
1. KeyboardViewController.viewDidLoad()
2. Initialize components (AudioRecorder, APIClient, RecordButton)
3. Setup UI constraints
4. Prepare feedback generator
```

**Recording:**
```
1. Allocate ~2MB for 60s audio buffer
2. Keep in memory during recording
3. Write to temp file on stop
4. Release memory buffer
```

**API Call:**
```
1. Read file data (~2MB)
2. Create multipart body (~2.5MB with overhead)
3. Send via URLSession
4. Release request body
5. Receive response (~1KB)
6. Release response data
```

**Cleanup:**
```
1. Delete temp audio file
2. Release response objects
3. Return to idle (minimal memory)
```

### Memory Budget:

- **Base Keyboard**: ~5MB
- **Recording Buffer**: ~2MB
- **API Request**: ~2.5MB
- **Peak Usage**: ~10MB
- **Extension Limit**: ~30MB
- **Safety Margin**: ~20MB remaining

## Security Architecture

### API Key Protection:

```
Main App (Secure Context)
    ↓
    Stores API Key
    ↓
Shared App Group UserDefaults
    ↓
Keyboard Extension (Restricted Context)
    ↓
    Reads API Key
    ↓
    Uses for HTTPS Request Only
    ↓
Never Logs or Displays Key
```

### Privacy Measures:

1. **Audio Data**: Ephemeral, deleted after use
2. **Network**: HTTPS only (enforced by Groq API)
3. **Storage**: No persistent audio storage
4. **Permissions**: Clear explanations provided
5. **Full Access**: Required only for network capability

## Performance Optimizations

### Audio:
- 16kHz sample rate (vs 44.1kHz) = 64% size reduction
- Mono (vs stereo) = 50% size reduction
- Combined = ~80% size reduction with no speech quality loss

### UI:
- Core Animation for smooth 60fps animations
- Layer-based rendering for pulse effect
- Minimal view hierarchy

### Network:
- Single request per recording (no streaming)
- Compressed multipart encoding
- 30s timeout prevents hanging

### Memory:
- Immediate file cleanup
- No retained audio data
- Weak delegate references
- Autoreleasing network responses

## Error Handling Architecture

### Error Propagation:

```
Low-Level Error (AVFoundation, URLSession)
    ↓
Wrapped in Custom Error Type
    ↓
Propagated via Delegate/Completion
    ↓
Caught in KeyboardViewController
    ↓
Converted to User-Friendly Message
    ↓
Displayed with Visual Feedback
    ↓
Auto-Recovery to Idle State
```

### Error Categories:

1. **Recoverable**: Shown briefly, auto-retry available (network errors)
2. **Configuration**: User must fix (API key, permissions)
3. **Temporary**: Wait and retry (API timeout)
4. **Fatal**: Shouldn't happen, log and reset (edge cases)

## Testing Architecture

### Unit Testing (Potential):
- AudioRecorder state management
- WhisperAPIClient request building
- RecordButton state transitions

### Integration Testing (Potential):
- End-to-end recording flow
- API mocking for offline tests

### Manual Testing (Current):
- Real device testing with actual API
- Various iOS versions and devices

## Scalability Considerations

### Current Limitations:
- Single-threaded recording (one at a time)
- No queuing system
- No offline support

### Potential Enhancements:
- Queue multiple recordings
- Local caching for retry
- Multiple language support
- Waveform visualization
- Custom dictionaries

### Extension Points:
- `AudioRecorder`: Easy to swap recording formats
- `WhisperAPIClient`: Protocol-based, can add other providers
- `RecordButton`: Customizable appearance
- State machine: Can add new states

## Dependencies

### iOS Frameworks:
- **UIKit**: UI components and view controllers
- **AVFoundation**: Audio recording
- **Foundation**: Base types, networking, file I/O

### No Third-Party Dependencies:
- Reduces binary size
- No dependency conflicts
- Faster build times
- No security vulnerabilities from external code

## Build Configuration

### Debug:
- No optimization
- Full symbol information
- Assertions enabled
- Verbose logging (if implemented)

### Release:
- Full optimization (-O)
- Stripped symbols
- Assertions disabled
- Minimal logging

## Deployment Architecture

### Distribution:
1. Main app distributed via TestFlight or App Store
2. Keyboard extension bundled with main app
3. iOS automatically manages extension deployment

### Updates:
- Updating main app updates keyboard extension
- No separate update mechanism needed

## Compliance

### App Extension Guidelines:
✅ No access to shared containers (except App Groups)
✅ No camera/photo library access
✅ Limited memory usage
✅ No long-running background tasks
✅ Appropriate use of Full Access

### Privacy:
✅ No data collection
✅ No analytics
✅ No user tracking
✅ Ephemeral audio handling
✅ Clear permission explanations
