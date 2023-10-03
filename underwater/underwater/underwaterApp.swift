import SwiftUI
import AVFAudio

@main
struct underwaterApp: App {
    init() {
            // Request microphone permission
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                if granted {
                    print("Microphone access granted")
                } else {
                    print("Microphone access denied")
                }
            }
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
