//
//  RecordButton.swift
//  VoiceKeyboardExtension
//
//  Custom button with visual states and animations
//  Provides clear feedback for recording states
//

import UIKit

// MARK: - RecordButtonState
enum RecordButtonState {
    case idle
    case recording
    case processing
    case error
}

// MARK: - RecordButton
class RecordButton: UIView {
    
    // MARK: - Properties
    private var currentState: RecordButtonState = .idle
    
    private let microphoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        // Create microphone icon
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        imageView.image = UIImage(systemName: "mic.fill", withConfiguration: config)
        
        return imageView
    }()
    
    private let backgroundCircle: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.systemBlue.cgColor
        return layer
    }()
    
    private let pulseCircle: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
        layer.lineWidth = 3.0
        layer.opacity = 0
        return layer
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // Add layers
        layer.addSublayer(pulseCircle)
        layer.addSublayer(backgroundCircle)
        
        // Add subviews
        addSubview(microphoneImageView)
        addSubview(activityIndicator)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            microphoneImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            microphoneImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            microphoneImageView.widthAnchor.constraint(equalToConstant: 50),
            microphoneImageView.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Enable user interaction
        isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = bounds.width / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Update circle paths
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: true
        )
        
        backgroundCircle.path = circlePath.cgPath
        pulseCircle.path = circlePath.cgPath
    }
    
    // MARK: - State Management
    func setState(_ state: RecordButtonState) {
        guard currentState != state else { return }
        
        currentState = state
        updateAppearance(for: state)
    }
    
    private func updateAppearance(for state: RecordButtonState) {
        // Remove existing animations
        pulseCircle.removeAllAnimations()
        
        switch state {
        case .idle:
            showIdle()
            
        case .recording:
            showRecording()
            
        case .processing:
            showProcessing()
            
        case .error:
            showError()
        }
    }
    
    // MARK: - State Appearances
    private func showIdle() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundCircle.fillColor = UIColor.systemBlue.cgColor
            self.microphoneImageView.alpha = 1.0
            self.microphoneImageView.tintColor = .white
        }
        
        activityIndicator.stopAnimating()
        pulseCircle.opacity = 0
    }
    
    private func showRecording() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundCircle.fillColor = UIColor.systemRed.cgColor
            self.microphoneImageView.alpha = 1.0
            self.microphoneImageView.tintColor = .white
        }
        
        activityIndicator.stopAnimating()
        startPulseAnimation()
    }
    
    private func showProcessing() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundCircle.fillColor = UIColor.systemGray.cgColor
            self.microphoneImageView.alpha = 0.3
        }
        
        activityIndicator.startAnimating()
        pulseCircle.opacity = 0
    }
    
    private func showError() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundCircle.fillColor = UIColor.systemRed.cgColor
            self.microphoneImageView.alpha = 1.0
            self.microphoneImageView.tintColor = .white
        }
        
        activityIndicator.stopAnimating()
        pulseCircle.opacity = 0
        
        // Shake animation
        shakeAnimation()
        
        // Return to idle after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setState(.idle)
        }
    }
    
    // MARK: - Animations
    private func startPulseAnimation() {
        pulseCircle.strokeColor = UIColor.systemRed.withAlphaComponent(0.5).cgColor
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.3
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.8
        opacityAnimation.toValue = 0.0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = 1.5
        animationGroup.repeatCount = .infinity
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        pulseCircle.add(animationGroup, forKey: "pulse")
    }
    
    private func shakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-10, 10, -8, 8, -5, 5, 0]
        
        layer.add(animation, forKey: "shake")
    }
    
    // MARK: - Touch Feedback
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}
