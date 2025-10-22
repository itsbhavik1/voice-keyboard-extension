//
//  KeyboardViewController.swift
//  VoiceKeyboardExtension
//
//  Custom keyboard extension with voice-to-text transcription
//  Uses Groq's Whisper API for speech recognition
//

import UIKit
import AVFoundation

// MARK: - Keyboard State
enum KeyboardState {
    case idle
    case recording
    case processing
    case error(String)
}

// MARK: - KeyboardViewController
class KeyboardViewController: UIInputViewController {
    
    // MARK: - Properties
    private var recordButton: RecordButton!
    private var audioRecorder: AudioRecorder!
    private var apiClient: WhisperAPIClient!
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    private var currentState: KeyboardState = .idle {
        didSet {
            updateUI(for: currentState)
        }
    }
    
    private let keyboardHeight: CGFloat = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 264.0 // iPad
        } else {
            return 216.0 // iPhone
        }
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        setupAudioRecorder()
        setupAPIClient()
        setupFeedbackGenerator()
        setupRecordButton()
        
        // Set keyboard height constraint
        let heightConstraint = NSLayoutConstraint(
            item: view!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: keyboardHeight
        )
        view.addConstraint(heightConstraint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAppearance()
    }
    
    // MARK: - Setup Methods
    private func setupKeyboard() {
        // Set background color based on appearance
        updateAppearance()
    }
    
    private func setupAudioRecorder() {
        audioRecorder = AudioRecorder()
        audioRecorder.delegate = self
    }
    
    private func setupAPIClient() {
        apiClient = WhisperAPIClient()
    }
    
    private func setupFeedbackGenerator() {
        feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator?.prepare()
    }
    
    private func setupRecordButton() {
        recordButton = RecordButton()
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordButton)
        
        // Center the button
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 120),
            recordButton.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // Add gesture recognizer for press and hold
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress(_:))
        )
        longPressGesture.minimumPressDuration = 0.0 // Start immediately
        recordButton.addGestureRecognizer(longPressGesture)
    }
    
    private func updateAppearance() {
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 1.0)
        } else {
            view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        }
    }
    
    // MARK: - Gesture Handling
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            startRecording()
        case .ended, .cancelled, .failed:
            stopRecording()
        default:
            break
        }
    }
    
    // MARK: - Recording Control
    private func startRecording() {
        guard currentState == .idle else { return }
        
        // Haptic feedback
        feedbackGenerator?.impactOccurred()
        
        // Check microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if granted {
                    self.currentState = .recording
                    self.audioRecorder.startRecording()
                } else {
                    self.currentState = .error("Microphone permission denied")
                }
            }
        }
    }
    
    private func stopRecording() {
        guard currentState == .recording else { return }
        
        // Haptic feedback
        feedbackGenerator?.impactOccurred()
        
        currentState = .processing
        audioRecorder.stopRecording()
    }
    
    // MARK: - Transcription
    private func transcribeAudio(fileURL: URL) {
        apiClient.transcribeAudio(fileURL: fileURL) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let transcription):
                    self.insertTranscription(transcription)
                    self.currentState = .idle
                    
                    // Success haptic
                    let successGenerator = UINotificationFeedbackGenerator()
                    successGenerator.notificationOccurred(.success)
                    
                case .failure(let error):
                    self.currentState = .error(error.localizedDescription)
                    
                    // Error haptic
                    let errorGenerator = UINotificationFeedbackGenerator()
                    errorGenerator.notificationOccurred(.error)
                    
                    // Reset to idle after showing error briefly
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.currentState = .idle
                    }
                }
                
                // Clean up audio file
                try? FileManager.default.removeItem(at: fileURL)
            }
        }
    }
    
    private func insertTranscription(_ text: String) {
        // Insert text at cursor position
        textDocumentProxy.insertText(text)
        
        // Add space after transcription for better UX
        textDocumentProxy.insertText(" ")
    }
    
    // MARK: - UI Updates
    private func updateUI(for state: KeyboardState) {
        switch state {
        case .idle:
            recordButton.setState(.idle)
            
        case .recording:
            recordButton.setState(.recording)
            
        case .processing:
            recordButton.setState(.processing)
            
        case .error(let message):
            recordButton.setState(.error)
            showError(message)
        }
    }
    
    private func showError(_ message: String) {
        // Create error label overlay
        let errorLabel = UILabel()
        errorLabel.text = message
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.alpha = 0
        
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Animate in
        UIView.animate(withDuration: 0.3, animations: {
            errorLabel.alpha = 1.0
        }) { _ in
            // Animate out after delay
            UIView.animate(withDuration: 0.3, delay: 2.0, options: [], animations: {
                errorLabel.alpha = 0
            }) { _ in
                errorLabel.removeFromSuperview()
            }
        }
    }
}

// MARK: - AudioRecorderDelegate
extension KeyboardViewController: AudioRecorderDelegate {
    func audioRecorder(_ recorder: AudioRecorder, didFinishRecording fileURL: URL) {
        transcribeAudio(fileURL: fileURL)
    }
    
    func audioRecorder(_ recorder: AudioRecorder, didFailWithError error: Error) {
        currentState = .error(error.localizedDescription)
        
        // Reset to idle after showing error
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.currentState = .idle
        }
    }
}
