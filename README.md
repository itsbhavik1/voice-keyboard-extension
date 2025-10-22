# iOS Voice Keyboard Project

A complete iOS Voice-to-Text Keyboard Extension implementation with Swift code and comprehensive documentation.

## 📱 Project Overview

This project contains all the code and documentation needed to build a custom iOS keyboard extension that uses voice transcription via Groq's Whisper API. The keyboard features a press-and-hold recording interface that transcribes audio to text.

## 🌐 View Project Files

Visit the web interface to browse and download all project files:

- **Development Server**: [http://localhost:3000/ios-keyboard-project](http://localhost:3000/ios-keyboard-project)

## 📁 Project Structure

### Swift Source Code
- `KeyboardViewController.swift` - Main keyboard controller with state management
- `AudioRecorder.swift` - Audio recording with AVFoundation integration  
- `WhisperAPIClient.swift` - Groq Whisper API client with multipart upload
- `RecordButton.swift` - Custom button UI with animations
- `ViewController.swift` - Main app setup and configuration UI
- `AppDelegate.swift` & `SceneDelegate.swift` - App lifecycle management

### Configuration Files
- `Info-MainApp.plist` - Main app permissions and configuration
- `Info-KeyboardExtension.plist` - Keyboard extension configuration

### Documentation
- `README.md` - Complete project overview and setup guide
- `PROJECT-SETUP-GUIDE.md` - Step-by-step Xcode instructions
- `TESTING-GUIDE.md` - Comprehensive testing scenarios
- `ASSUMPTIONS.md` - Technical specifications and constraints
- `ARCHITECTURE.md` - System architecture documentation

## 🚀 Quick Start

1. **Download Files**: Visit [/ios-keyboard-project](http://localhost:3000/ios-keyboard-project) and download all Swift and configuration files
2. **Open Xcode**: Create a new iOS App project named "VoiceKeyboard"
3. **Add Extension**: Add a Custom Keyboard Extension target named "VoiceKeyboardExtension"
4. **Copy Files**: Place the Swift files in their respective targets
5. **Configure**: Update Info.plist files and set up App Groups
6. **Build**: Run on a physical iOS device (keyboard extensions don't work in simulator)

## ✨ Key Features

- **Press & Hold Recording** - Natural push-to-talk interaction
- **Visual Feedback** - Clear state indicators with animations
- **Groq Whisper API** - Fast, accurate speech-to-text transcription
- **Dark Mode Support** - Adapts to system appearance
- **Memory Optimized** - Respects 30MB extension limit
- **Zero Dependencies** - Uses only native iOS frameworks

## 🛠 Technical Stack

- **Language**: Swift 5+
- **Minimum iOS**: 14.0
- **UI**: UIKit
- **Audio**: AVFoundation (16kHz Mono WAV)
- **API**: Groq Whisper
- **Networking**: URLSession

## 📚 Full Documentation

All project documentation and code files are available in the `/ios-keyboard-project` directory and can be browsed via the web interface.

## 🧪 Testing

See `TESTING-GUIDE.md` for:
- Acceptance criteria
- Test scenarios
- Bug reporting guidelines
- Known limitations

## 📄 License

This project is provided as-is for educational and development purposes.

---

**Ready to build your iOS Voice Keyboard!** 🎤✨