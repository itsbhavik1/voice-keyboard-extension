//
//  AudioRecorder.swift
//  VoiceKeyboardExtension
//
//  Handles audio recording with AVAudioRecorder
//  Optimized for speech recognition (16kHz mono WAV)
//

import Foundation
import AVFoundation

// MARK: - AudioRecorderDelegate
protocol AudioRecorderDelegate: AnyObject {
    func audioRecorder(_ recorder: AudioRecorder, didFinishRecording fileURL: URL)
    func audioRecorder(_ recorder: AudioRecorder, didFailWithError error: Error)
}

// MARK: - AudioRecorderError
enum AudioRecorderError: LocalizedError {
    case recordingFailed
    case permissionDenied
    case audioSessionSetupFailed
    case fileCreationFailed
    case maxDurationExceeded
    
    var errorDescription: String? {
        switch self {
        case .recordingFailed:
            return "Failed to start recording"
        case .permissionDenied:
            return "Microphone permission denied"
        case .audioSessionSetupFailed:
            return "Failed to setup audio session"
        case .fileCreationFailed:
            return "Failed to create audio file"
        case .maxDurationExceeded:
            return "Recording exceeded maximum duration"
        }
    }
}

// MARK: - AudioRecorder
class AudioRecorder: NSObject {
    
    // MARK: - Properties
    weak var delegate: AudioRecorderDelegate?
    
    private var audioRecorder: AVAudioRecorder?
    private var recordingStartTime: Date?
    private var maxRecordingDuration: TimeInterval = 60.0 // 60 seconds max
    private var durationTimer: Timer?
    
    // Audio settings optimized for speech recognition
    private let audioSettings: [String: Any] = [
        AVFormatIDKey: Int(kAudioFormatLinearPCM),
        AVSampleRateKey: 16000.0,  // 16kHz - optimal for speech
        AVNumberOfChannelsKey: 1,   // Mono
        AVLinearPCMBitDepthKey: 16,
        AVLinearPCMIsFloatKey: false,
        AVLinearPCMIsBigEndianKey: false,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    // MARK: - Public Methods
    func startRecording() {
        // Setup audio session
        setupAudioSession { [weak self] success in
            guard let self = self, success else {
                self?.delegate?.audioRecorder(self!, didFailWithError: AudioRecorderError.audioSessionSetupFailed)
                return
            }
            
            // Create temporary file URL
            let tempDir = FileManager.default.temporaryDirectory
            let fileName = "recording_\(Date().timeIntervalSince1970).wav"
            let fileURL = tempDir.appendingPathComponent(fileName)
            
            do {
                // Initialize audio recorder
                self.audioRecorder = try AVAudioRecorder(url: fileURL, settings: self.audioSettings)
                self.audioRecorder?.delegate = self
                self.audioRecorder?.prepareToRecord()
                
                // Start recording
                let didStart = self.audioRecorder?.record() ?? false
                
                if didStart {
                    self.recordingStartTime = Date()
                    self.startDurationTimer()
                } else {
                    self.delegate?.audioRecorder(self, didFailWithError: AudioRecorderError.recordingFailed)
                }
                
            } catch {
                self.delegate?.audioRecorder(self, didFailWithError: error)
            }
        }
    }
    
    func stopRecording() {
        durationTimer?.invalidate()
        durationTimer = nil
        
        guard let recorder = audioRecorder, recorder.isRecording else {
            return
        }
        
        recorder.stop()
        
        // Deactivate audio session
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
    
    // MARK: - Private Methods
    private func setupAudioSession(completion: @escaping (Bool) -> Void) {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            // Set category for recording
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
            
            // Check permission
            audioSession.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        } catch {
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
    
    private func startDurationTimer() {
        durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self,
                  let startTime = self.recordingStartTime else {
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            
            if elapsed >= self.maxRecordingDuration {
                // Stop recording due to max duration
                self.stopRecording()
            }
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            delegate?.audioRecorder(self, didFinishRecording: recorder.url)
        } else {
            delegate?.audioRecorder(self, didFailWithError: AudioRecorderError.recordingFailed)
        }
        
        // Clean up
        audioRecorder = nil
        recordingStartTime = nil
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        delegate?.audioRecorder(self, didFailWithError: error ?? AudioRecorderError.recordingFailed)
        
        // Clean up
        audioRecorder = nil
        recordingStartTime = nil
    }
}
