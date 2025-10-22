# Project Assumptions Documentation

This document outlines all assumptions made during the development of the Voice-to-Text Keyboard Extension.

## Technical Specifications

### Audio Configuration

**Audio Format**: WAV (Waveform Audio File Format)
- **Reasoning**: WAV is uncompressed and widely supported by speech recognition APIs. Provides best quality for transcription accuracy.

**Sample Rate**: 16,000 Hz (16 kHz)
- **Reasoning**: Standard sample rate for speech recognition. Higher rates (44.1kHz) provide no benefit for speech and increase file size. Lower rates (8kHz) reduce quality.

**Channels**: Mono (1 channel)
- **Reasoning**: Speech recognition doesn't benefit from stereo. Mono reduces file size by 50% compared to stereo with no quality loss for speech.

**Bit Depth**: 16-bit
- **Reasoning**: CD-quality depth. 8-bit is too low quality, 24-bit is overkill for speech. 16-bit provides excellent quality-to-size ratio.

**Encoding**: Linear PCM
- **Reasoning**: Uncompressed format ensures maximum compatibility and no quality loss. Supported by all audio APIs.

### Recording Constraints

**Maximum Recording Duration**: 60 seconds
- **Reasoning**: 
  - Prevents excessive file sizes (16kHz mono WAV = ~1.9MB per minute)
  - Keyboard extensions have ~30MB memory limit
  - Most voice inputs are shorter utterances
  - Longer recordings increase transcription time and cost

**Minimum Recording Duration**: None enforced
- **Reasoning**: Users may have short interjections. API handles any length. Very short recordings may return empty transcriptions.

### Network Configuration

**API Timeout**: 30 seconds
- **Reasoning**:
  - Groq Whisper API typically responds in 2-10 seconds for normal recordings
  - Allows buffer for network latency and longer audio files
  - Prevents indefinite waiting
  - Provides better UX than longer timeouts

**Retry Logic**: Not implemented
- **Reasoning**: 
  - Keyboard extensions should be lightweight
  - Users can simply try recording again
  - Failed recordings don't persist
  - Reduces complexity

**Offline Mode**: Not supported
- **Reasoning**:
  - Whisper API requires internet connection
  - Local speech recognition would require different implementation
  - Queuing would add complexity and storage requirements

### UI/UX Specifications

**Keyboard Height**:
- iPhone: 216 points
- iPad: 264 points

**Reasoning**:
- Standard iOS custom keyboard heights
- Provides enough space for button and visual feedback
- Doesn't take excessive screen space
- Matches user expectations from other custom keyboards

**Button Size**: 120x120 points
- **Reasoning**:
  - Large enough for easy touch target (44pt minimum, 120pt excellent)
  - Prominent and centered
  - Accommodates icon and animations
  - Works across device sizes

**Visual Feedback States**:
1. Idle (Blue)
2. Recording (Red with pulse)
3. Processing (Gray with spinner)
4. Error (Red with shake)

**Reasoning**: 
- Color coding matches universal conventions (red = recording, blue = ready)
- Animations provide clear state feedback without text
- Works in any language
- Intuitive for users

### iOS Platform Assumptions

**Minimum iOS Version**: 14.0
- **Reasoning**:
  - AVAudioRecorder and UIInputViewController available in iOS 3.0+
  - Modern async/await patterns (optional, using completion handlers)
  - SwiftUI support if needed (iOS 14+)
  - Covers ~95% of active iOS devices (as of 2024)

**Device Support**: iPhone and iPad
- **Reasoning**: 
  - Custom keyboards supported on both
  - Different screen sizes handled with adaptive layout
  - Both have microphone capabilities

**Supported Orientations**: Portrait and Landscape
- **Reasoning**:
  - Keyboards must work in any orientation
  - Button centered, works in both orientations
  - Auto-layout handles rotation

### Memory Management

**Memory Limit**: ~30 MB for keyboard extensions
- **Reasoning**: 
  - iOS enforces strict limits on keyboard extensions
  - Exceeded limits cause immediate termination
  - Must aggressively release resources

**Audio File Management**:
- Files saved to temporary directory
- Deleted immediately after upload
- **Reasoning**: Prevents storage accumulation, respects user privacy

**In-Memory Audio**: Not kept after recording
- **Reasoning**: File-based approach reduces memory footprint

### Security and Privacy

**API Key Storage**: App Group Shared UserDefaults
- **Primary Method**: Shared UserDefaults via App Groups
- **Reasoning**: 
  - Simple implementation
  - Allows main app to configure, keyboard to access
  - Acceptable for personal use
  
**Alternative Mentioned**: iOS Keychain
- **Reasoning**: More secure, recommended for production/App Store
- **Not Implemented**: Adds complexity, document mentions as enhancement

**Audio Data**: Never persisted long-term
- **Reasoning**: Privacy-first approach, no user audio stored

**Full Access Permission**: Required
- **Reasoning**: 
  - Keyboard extensions normally sandboxed with no network access
  - "Allow Full Access" grants network permissions
  - Required for API calls
  - Clearly explained to users

### API Integration

**API Provider**: Groq (Whisper API)
- **Reasoning**: 
  - Fast inference (~2-3s for typical audio)
  - OpenAI Whisper model (state-of-the-art accuracy)
  - Simple REST API
  - Affordable pricing

**API Endpoint**: `https://api.groq.com/openai/v1/audio/transcriptions`

**Model**: `whisper-large-v3`
- **Reasoning**: 
  - Best accuracy among Whisper models
  - Multilingual support (though defaulting to English)
  - Latest version

**Language Parameter**: English ("en")
- **Reasoning**: 
  - Project requirements specify English
  - Reduces transcription errors
  - Can be made configurable later

**Response Format**: JSON
- **Reasoning**: Standard, easy to parse

### Interaction Model

**Gesture**: Long-press (touch-down to touch-up)
- **Reasoning**:
  - Natural "push-to-talk" pattern
  - User controls exact recording duration
  - Clear start and stop points
  - Universal gesture across platforms

**Minimum Press Duration**: 0 seconds (immediate)
- **Reasoning**: 
  - UILongPressGestureRecognizer minimum set to 0
  - Starts recording immediately on touch
  - More responsive than default 0.5s minimum

**Haptic Feedback**: Medium impact
- **Reasoning**:
  - Clear tactile feedback
  - Not too strong or weak
  - Confirms action registered

**Transcription Insertion**: Automatic at cursor
- **Reasoning**:
  - No additional confirmation needed
  - Matches user expectation
  - Fast workflow
  - Space added after for convenience

### Error Handling Philosophy

**Error Display**: Temporary overlay (2 seconds)
- **Reasoning**:
  - Non-blocking
  - Provides feedback
  - Auto-dismisses
  - Keyboard remains functional

**Error Recovery**: Automatic return to idle
- **Reasoning**:
  - User can immediately retry
  - No manual dismissal needed
  - Reduces friction

**User-Friendly Messages**: Simplified technical errors
- **Reasoning**:
  - Most users don't understand technical details
  - Focus on action needed (e.g., "Check internet connection")

### Not Implemented (Explicitly Excluded)

**Real-Time Transcription**: Not supported
- **Reasoning**: 
  - Requirements specify post-recording transcription
  - Simpler implementation
  - Lower API costs
  - Better accuracy with complete audio

**Waveform Visualization**: Not implemented
- **Reasoning**: 
  - Listed as bonus feature
  - Adds complexity
  - Not critical for core functionality
  - Can be added later

**Multiple Languages**: English only
- **Reasoning**:
  - Simpler for initial version
  - Can be configured later
  - API supports multiple languages

**Offline Mode with Queue**: Not implemented
- **Reasoning**:
  - Requires persistent storage
  - Adds significant complexity
  - Listed as bonus feature

**Unit Tests**: Not included
- **Reasoning**:
  - Focus on core functionality first
  - Listed as bonus feature
  - Can be added for production

**Theme Customization**: Not implemented
- **Reasoning**:
  - Dark/light mode supported
  - Custom themes listed as bonus
  - Additional complexity

### Development Assumptions

**No External Dependencies**: Native iOS frameworks only
- **Reasoning**:
  - Reduces app size
  - Faster compilation
  - No dependency management issues
  - All required functionality available natively

**Code Structure**: Protocol-oriented with delegates
- **Reasoning**:
  - Swift best practice
  - Clear separation of concerns
  - Testable architecture
  - Memory-safe with weak references

**Comments**: Extensive inline documentation
- **Reasoning**:
  - Assessment specifically mentions documentation
  - Helps reviewers understand code
  - Good practice for team environments

## User Experience Assumptions

**User Expertise**: Assumes basic iOS familiarity
- **Reasoning**: Users know how to enable keyboards, grant permissions

**Recording Environment**: Assumes relatively quiet environment
- **Reasoning**: No noise cancellation implemented

**Network Availability**: Assumes internet connection available
- **Reasoning**: No offline fallback

**Language**: User speaks clear English
- **Reasoning**: Single language support as specified

## Compliance and Guidelines

**App Store Guidelines**: Followed
- Explains permissions clearly
- Privacy-respecting (no data stored)
- Appropriate for all ages

**iOS Extension Guidelines**: Followed
- Memory constraints respected
- Appropriate use of Full Access permission
- No unauthorized data collection

## Revision History

- **v1.0** (Initial): All assumptions documented based on requirements analysis
- **Date**: [Current date based on project creation]
- **Author**: [Your name]
