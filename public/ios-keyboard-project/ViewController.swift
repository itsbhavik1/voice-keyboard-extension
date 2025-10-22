//
//  ViewController.swift
//  VoiceKeyboard (Main App)
//
//  Main app for keyboard setup and API key configuration
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Voice Keyboard Setup"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Follow these steps to enable your voice keyboard:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stepsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let apiKeyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Groq API Key"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save API Key", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let requestPermissionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Grant Microphone Permission", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
        loadSavedAPIKey()
        setupActions()
        checkMicrophonePermission()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(instructionsLabel)
        contentView.addSubview(stepsStackView)
        contentView.addSubview(apiKeyTextField)
        contentView.addSubview(saveButton)
        contentView.addSubview(statusLabel)
        contentView.addSubview(requestPermissionButton)
        
        // Setup steps
        setupSteps()
        
        // Layout constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            instructionsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            stepsStackView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 30),
            stepsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stepsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            requestPermissionButton.topAnchor.constraint(equalTo: stepsStackView.bottomAnchor, constant: 30),
            requestPermissionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            requestPermissionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            requestPermissionButton.heightAnchor.constraint(equalToConstant: 50),
            
            apiKeyTextField.topAnchor.constraint(equalTo: requestPermissionButton.bottomAnchor, constant: 30),
            apiKeyTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            apiKeyTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            apiKeyTextField.heightAnchor.constraint(equalToConstant: 44),
            
            saveButton.topAnchor.constraint(equalTo: apiKeyTextField.bottomAnchor, constant: 15),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            statusLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 15),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupSteps() {
        let steps = [
            "1. Configure your Groq API key below",
            "2. Grant microphone permission",
            "3. Go to Settings > General > Keyboard > Keyboards",
            "4. Tap 'Add New Keyboard'",
            "5. Select 'VoiceKeyboard'",
            "6. Enable 'Allow Full Access' (required for transcription)",
            "7. Open any app with text input",
            "8. Long-press the globe icon and select 'VoiceKeyboard'",
            "9. Press and hold the microphone button to record",
            "10. Release to transcribe and insert text"
        ]
        
        for step in steps {
            let label = createStepLabel(text: step)
            stepsStackView.addArrangedSubview(label)
        }
    }
    
    private func createStepLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveAPIKey), for: .touchUpInside)
        requestPermissionButton.addTarget(self, action: #selector(requestMicrophonePermission), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func saveAPIKey() {
        guard let apiKey = apiKeyTextField.text, !apiKey.isEmpty else {
            showStatus("Please enter an API key", isError: true)
            return
        }
        
        // Save to UserDefaults
        UserDefaults.standard.set(apiKey, forKey: "groq_api_key")
        
        // Also save to App Group for keyboard extension access
        if let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.voicekeyboard") {
            sharedDefaults.set(apiKey, forKey: "groq_api_key")
        }
        
        showStatus("API key saved successfully! ✓", isError: false)
        
        // Clear text field for security
        apiKeyTextField.text = ""
    }
    
    @objc private func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    self.requestPermissionButton.setTitle("Microphone Granted ✓", for: .normal)
                    self.requestPermissionButton.backgroundColor = .systemGreen
                } else {
                    self.showStatus("Microphone permission denied. Please enable in Settings.", isError: true)
                }
            }
        }
    }
    
    private func checkMicrophonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            requestPermissionButton.setTitle("Microphone Granted ✓", for: .normal)
            requestPermissionButton.backgroundColor = .systemGreen
        case .denied:
            requestPermissionButton.setTitle("Enable in Settings", for: .normal)
            requestPermissionButton.backgroundColor = .systemRed
        case .undetermined:
            requestPermissionButton.setTitle("Grant Microphone Permission", for: .normal)
            requestPermissionButton.backgroundColor = .systemBlue
        @unknown default:
            break
        }
    }
    
    private func loadSavedAPIKey() {
        if let apiKey = UserDefaults.standard.string(forKey: "groq_api_key"), !apiKey.isEmpty {
            showStatus("API key configured ✓", isError: false)
        }
    }
    
    private func showStatus(_ message: String, isError: Bool) {
        statusLabel.text = message
        statusLabel.textColor = isError ? .systemRed : .systemGreen
        
        // Fade out after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.3) {
                self.statusLabel.alpha = 0
            } completion: { _ in
                self.statusLabel.text = ""
                self.statusLabel.alpha = 1
            }
        }
    }
}
