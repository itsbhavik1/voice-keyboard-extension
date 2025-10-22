import Image from "next/image";
import Link from "next/link";

export default function Home() {
  return (
    <div className="font-sans min-h-screen p-8 pb-20 sm:p-20">
      <main className="flex flex-col gap-8 items-center max-w-4xl mx-auto">
        <div className="text-center">
          <h1 className="text-4xl font-bold mb-4">iOS Voice-to-Text Keyboard Extension</h1>
          <p className="text-xl text-muted-foreground mb-8">
            Complete Swift project with source code, documentation, and setup guides
          </p>
        </div>

        <div className="w-full bg-card border rounded-lg p-8">
          <h2 className="text-2xl font-semibold mb-4">Project Overview</h2>
          <p className="text-muted-foreground mb-6">
            A custom iOS keyboard extension that uses voice transcription via Groq's Whisper API. 
            Features press-and-hold recording, real-time visual feedback, and seamless text insertion.
          </p>
          
          <div className="grid md:grid-cols-3 gap-4 mb-6">
            <div className="text-center p-4 bg-muted/50 rounded-lg">
              <div className="text-2xl font-bold text-primary mb-1">1000+</div>
              <div className="text-sm text-muted-foreground">Lines of Swift Code</div>
            </div>
            <div className="text-center p-4 bg-muted/50 rounded-lg">
              <div className="text-2xl font-bold text-primary mb-1">13</div>
              <div className="text-sm text-muted-foreground">Complete Files</div>
            </div>
            <div className="text-center p-4 bg-muted/50 rounded-lg">
              <div className="text-2xl font-bold text-primary mb-1">5</div>
              <div className="text-sm text-muted-foreground">Documentation Guides</div>
            </div>
          </div>

          <Link
            href="/ios-keyboard-project"
            className="inline-flex items-center justify-center w-full px-6 py-3 bg-primary text-primary-foreground rounded-lg font-semibold hover:bg-primary/90 transition-colors"
          >
            View Complete Project →
          </Link>
        </div>

        <div className="w-full bg-card border rounded-lg p-8">
          <h2 className="text-2xl font-semibold mb-4">What's Included</h2>
          <ul className="space-y-3">
            <li className="flex items-start gap-3">
              <span className="text-primary">✓</span>
              <span><strong>Complete Swift Source Code:</strong> KeyboardViewController, AudioRecorder, WhisperAPIClient, RecordButton, and more</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="text-primary">✓</span>
              <span><strong>Main App:</strong> Setup UI, API key configuration, permission handling</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="text-primary">✓</span>
              <span><strong>Configuration Files:</strong> Info.plist for both targets with proper settings</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="text-primary">✓</span>
              <span><strong>Comprehensive Documentation:</strong> README, setup guide, testing guide, architecture docs</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="text-primary">✓</span>
              <span><strong>Technical Specifications:</strong> All assumptions documented (audio format, constraints, etc.)</span>
            </li>
          </ul>
        </div>

        <div className="w-full bg-card border rounded-lg p-8">
          <h2 className="text-2xl font-semibold mb-4">Technical Highlights</h2>
          <div className="grid md:grid-cols-2 gap-4">
            <div>
              <h3 className="font-semibold mb-2">Core Features</h3>
              <ul className="text-sm text-muted-foreground space-y-1">
                <li>• Press & hold recording interaction</li>
                <li>• Visual feedback (pulsing, animations)</li>
                <li>• Haptic feedback</li>
                <li>• Dark mode support</li>
                <li>• Comprehensive error handling</li>
              </ul>
            </div>
            <div>
              <h3 className="font-semibold mb-2">Technical Stack</h3>
              <ul className="text-sm text-muted-foreground space-y-1">
                <li>• Swift 5+ with UIKit</li>
                <li>• AVFoundation for audio</li>
                <li>• Groq Whisper API integration</li>
                <li>• iOS 14.0+ compatible</li>
                <li>• Zero external dependencies</li>
              </ul>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}