import Link from "next/link";
import { FileCode, Book, TestTube, Database, Settings, Download, ExternalLink } from "lucide-react";

export default function IOSKeyboardProjectPage() {
  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-12 max-w-6xl">
        {/* Header */}
        <div className="mb-12 text-center">
          <h1 className="text-4xl font-bold mb-4">Voice-to-Text Keyboard Extension</h1>
          <p className="text-xl text-muted-foreground mb-6">
            Complete iOS Keyboard Extension Project with Swift Code
          </p>
          <div className="flex flex-wrap gap-3 justify-center">
            <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary/10 text-primary">
              Swift 5+
            </span>
            <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary/10 text-primary">
              iOS 14.0+
            </span>
            <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary/10 text-primary">
              Groq Whisper API
            </span>
            <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary/10 text-primary">
              UIKit
            </span>
          </div>
        </div>

        {/* Quick Start */}
        <div className="bg-card border rounded-lg p-6 mb-8">
          <h2 className="text-2xl font-semibold mb-4 flex items-center gap-2">
            <Settings className="w-6 h-6" />
            Quick Start
          </h2>
          <ol className="space-y-3 text-muted-foreground">
            <li className="flex items-start gap-3">
              <span className="font-semibold text-foreground min-w-6">1.</span>
              <span>Download all files from the sections below</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="font-semibold text-foreground min-w-6">2.</span>
              <span>Open Xcode and create a new iOS App project named "VoiceKeyboard"</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="font-semibold text-foreground min-w-6">3.</span>
              <span>Add a Custom Keyboard Extension target named "VoiceKeyboardExtension"</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="font-semibold text-foreground min-w-6">4.</span>
              <span>Copy the Swift files to their respective targets</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="font-semibold text-foreground min-w-6">5.</span>
              <span>Configure Info.plist files for both targets</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="font-semibold text-foreground min-w-6">6.</span>
              <span>Set up App Groups for API key sharing</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="font-semibold text-foreground min-w-6">7.</span>
              <span>Build and run on a physical device</span>
            </li>
          </ol>
        </div>

        {/* Documentation Files */}
        <div className="grid md:grid-cols-2 gap-6 mb-8">
          <FileCard
            icon={<Book className="w-5 h-5" />}
            title="README.md"
            description="Complete project overview, setup instructions, and API configuration guide"
            href="/ios-keyboard-project/README.md"
            color="blue"
          />
          <FileCard
            icon={<Settings className="w-5 h-5" />}
            title="PROJECT-SETUP-GUIDE.md"
            description="Step-by-step Xcode project setup and configuration instructions"
            href="/ios-keyboard-project/PROJECT-SETUP-GUIDE.md"
            color="green"
          />
          <FileCard
            icon={<TestTube className="w-5 h-5" />}
            title="TESTING-GUIDE.md"
            description="Comprehensive testing scenarios, acceptance criteria, and bug reporting"
            href="/ios-keyboard-project/TESTING-GUIDE.md"
            color="purple"
          />
          <FileCard
            icon={<Database className="w-5 h-5" />}
            title="ASSUMPTIONS.md"
            description="Technical specifications, constraints, and architectural decisions"
            href="/ios-keyboard-project/ASSUMPTIONS.md"
            color="orange"
          />
          <FileCard
            icon={<FileCode className="w-5 h-5" />}
            title="ARCHITECTURE.md"
            description="System architecture, component diagrams, and data flow documentation"
            href="/ios-keyboard-project/ARCHITECTURE.md"
            color="red"
          />
        </div>

        {/* Swift Code Files */}
        <div className="mb-8">
          <h2 className="text-2xl font-semibold mb-4 flex items-center gap-2">
            <FileCode className="w-6 h-6" />
            Keyboard Extension Code
          </h2>
          <div className="grid md:grid-cols-2 gap-4">
            <CodeFileCard
              title="KeyboardViewController.swift"
              description="Main keyboard controller with state management and UI coordination"
              href="/ios-keyboard-project/KeyboardViewController.swift"
              lines="~250 lines"
            />
            <CodeFileCard
              title="AudioRecorder.swift"
              description="Audio recording manager with AVFoundation integration"
              href="/ios-keyboard-project/AudioRecorder.swift"
              lines="~180 lines"
            />
            <CodeFileCard
              title="WhisperAPIClient.swift"
              description="Groq Whisper API client with multipart upload support"
              href="/ios-keyboard-project/WhisperAPIClient.swift"
              lines="~200 lines"
            />
            <CodeFileCard
              title="RecordButton.swift"
              description="Custom button with animations and visual feedback"
              href="/ios-keyboard-project/RecordButton.swift"
              lines="~220 lines"
            />
          </div>
        </div>

        {/* Main App Code Files */}
        <div className="mb-8">
          <h2 className="text-2xl font-semibold mb-4 flex items-center gap-2">
            <FileCode className="w-6 h-6" />
            Main App Code
          </h2>
          <div className="grid md:grid-cols-2 gap-4">
            <CodeFileCard
              title="ViewController.swift"
              description="Main app UI for setup, permissions, and API key configuration"
              href="/ios-keyboard-project/ViewController.swift"
              lines="~200 lines"
            />
            <CodeFileCard
              title="AppDelegate.swift"
              description="Application delegate and lifecycle management"
              href="/ios-keyboard-project/AppDelegate.swift"
              lines="~30 lines"
            />
            <CodeFileCard
              title="SceneDelegate.swift"
              description="Scene management and window configuration"
              href="/ios-keyboard-project/SceneDelegate.swift"
              lines="~50 lines"
            />
          </div>
        </div>

        {/* Configuration Files */}
        <div className="mb-8">
          <h2 className="text-2xl font-semibold mb-4 flex items-center gap-2">
            <Settings className="w-6 h-6" />
            Configuration Files
          </h2>
          <div className="grid md:grid-cols-2 gap-4">
            <CodeFileCard
              title="Info-MainApp.plist"
              description="Main app Info.plist with permissions and configurations"
              href="/ios-keyboard-project/Info-MainApp.plist"
              lines="XML configuration"
            />
            <CodeFileCard
              title="Info-KeyboardExtension.plist"
              description="Keyboard extension Info.plist with extension configurations"
              href="/ios-keyboard-project/Info-KeyboardExtension.plist"
              lines="XML configuration"
            />
          </div>
        </div>

        {/* Features */}
        <div className="bg-card border rounded-lg p-6 mb-8">
          <h2 className="text-2xl font-semibold mb-4">Key Features</h2>
          <div className="grid md:grid-cols-2 gap-4">
            <FeatureItem title="Press & Hold Recording" description="Natural push-to-talk interaction" />
            <FeatureItem title="Visual Feedback" description="Clear state indicators with animations" />
            <FeatureItem title="Haptic Feedback" description="Tactile confirmation for interactions" />
            <FeatureItem title="Dark Mode Support" description="Adapts to system appearance" />
            <FeatureItem title="Error Handling" description="Graceful handling of edge cases" />
            <FeatureItem title="Memory Optimized" description="Respects 30MB extension limit" />
            <FeatureItem title="Secure API Key Storage" description="Shared UserDefaults with App Groups" />
            <FeatureItem title="Clean Architecture" description="Protocol-oriented, well-documented code" />
          </div>
        </div>

        {/* Technical Stack */}
        <div className="bg-card border rounded-lg p-6 mb-8">
          <h2 className="text-2xl font-semibold mb-4">Technical Stack</h2>
          <div className="grid md:grid-cols-3 gap-4">
            <TechItem title="Language" value="Swift 5+" />
            <TechItem title="Minimum iOS" value="14.0" />
            <TechItem title="UI Framework" value="UIKit" />
            <TechItem title="Audio" value="AVFoundation" />
            <TechItem title="Networking" value="URLSession" />
            <TechItem title="API" value="Groq Whisper" />
            <TechItem title="Audio Format" value="16kHz Mono WAV" />
            <TechItem title="Max Duration" value="60 seconds" />
            <TechItem title="Dependencies" value="Zero (native only)" />
          </div>
        </div>

        {/* Download All Button */}
        <div className="text-center">
          <a
            href="/ios-keyboard-project"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 px-6 py-3 bg-primary text-primary-foreground rounded-lg font-semibold hover:bg-primary/90 transition-colors"
          >
            <Download className="w-5 h-5" />
            View All Files
          </a>
        </div>

        {/* Footer */}
        <div className="mt-12 pt-6 border-t text-center text-sm text-muted-foreground">
          <p>
            This project includes complete Swift code, documentation, and setup instructions.
            <br />
            Ready to build in Xcode on macOS with iOS SDK.
          </p>
        </div>
      </div>
    </div>
  );
}

function FileCard({
  icon,
  title,
  description,
  href,
  color,
}: {
  icon: React.ReactNode;
  title: string;
  description: string;
  href: string;
  color: string;
}) {
  const colorClasses = {
    blue: "bg-blue-500/10 text-blue-600 dark:text-blue-400",
    green: "bg-green-500/10 text-green-600 dark:text-green-400",
    purple: "bg-purple-500/10 text-purple-600 dark:text-purple-400",
    orange: "bg-orange-500/10 text-orange-600 dark:text-orange-400",
    red: "bg-red-500/10 text-red-600 dark:text-red-400",
  };

  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      className="block bg-card border rounded-lg p-4 hover:border-primary/50 transition-colors group"
    >
      <div className={`inline-flex items-center justify-center w-10 h-10 rounded-lg mb-3 ${colorClasses[color as keyof typeof colorClasses]}`}>
        {icon}
      </div>
      <h3 className="font-semibold mb-1 group-hover:text-primary transition-colors flex items-center gap-2">
        {title}
        <ExternalLink className="w-4 h-4 opacity-0 group-hover:opacity-100 transition-opacity" />
      </h3>
      <p className="text-sm text-muted-foreground">{description}</p>
    </a>
  );
}

function CodeFileCard({
  title,
  description,
  href,
  lines,
}: {
  title: string;
  description: string;
  href: string;
  lines: string;
}) {
  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      className="block bg-card border rounded-lg p-4 hover:border-primary/50 transition-colors group"
    >
      <div className="flex items-start justify-between mb-2">
        <h3 className="font-mono text-sm font-semibold group-hover:text-primary transition-colors">
          {title}
        </h3>
        <span className="text-xs text-muted-foreground">{lines}</span>
      </div>
      <p className="text-sm text-muted-foreground">{description}</p>
    </a>
  );
}

function FeatureItem({ title, description }: { title: string; description: string }) {
  return (
    <div className="flex items-start gap-3">
      <div className="w-1.5 h-1.5 rounded-full bg-primary mt-2 flex-shrink-0" />
      <div>
        <div className="font-medium">{title}</div>
        <div className="text-sm text-muted-foreground">{description}</div>
      </div>
    </div>
  );
}

function TechItem({ title, value }: { title: string; value: string }) {
  return (
    <div className="text-center">
      <div className="text-sm text-muted-foreground mb-1">{title}</div>
      <div className="font-semibold">{value}</div>
    </div>
  );
}
