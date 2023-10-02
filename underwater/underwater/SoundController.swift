import SwiftUI
import AVFoundation
import UIKit

struct SoundController: UIViewControllerRepresentable {
    @Binding var frequency: Double
    @Binding var chirpRate: Double
    @Binding var time: Float
    @Binding var spreadingFactor: Int
    
    func makeUIViewController(context: Context) -> SoundViewController {
        let controller = SoundViewController()
        controller.frequency = frequency
        controller.chirpRate = chirpRate
        controller.time = time
        controller.spreadingFactor = spreadingFactor
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SoundViewController, context: Context) {
        uiViewController.frequency = frequency
        uiViewController.chirpRate = chirpRate
        uiViewController.time = time
        uiViewController.spreadingFactor = spreadingFactor
    }
}

class SoundViewController: UIViewController {
    var frequency: Double = 100.0
    var chirpRate: Double = 50.0
    var time: Float = 1.0
    var spreadingFactor: Int = 12
    
    var audioEngine: AVAudioEngine!
    var sourceNode: AVAudioSourceNode!
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the audio engine and other audio properties
        setup()
    }
    
    // Generate the LoRa chirp
    func generateChirp(frame: Int, frameCount: AVAudioFrameCount, spreadingFactor: Int) -> Int16 {
        let fs: Double = 1000
        let symbolTime: Double = pow(2, Double(spreadingFactor)) / fs
        let t = Double(frame) * symbolTime / Double(frameCount)
            let chirp = cos(2 * .pi * (frequency * t + 0.5 * chirpRate * pow(t, 2)))
            return Int16(chirp * 32767.0)
        }
    
    func setup() {
        audioEngine = AVAudioEngine()
        
        sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let chirp = self.generateChirp(frame: frame, frameCount: frameCount, spreadingFactor: self.spreadingFactor)
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Int16> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = chirp
                }
            }
            return noErr
        }
        
        // Add button for play/stop toggle
        let button = UIButton(frame: CGRect(x: 120, y: 200, width: 80, height: 40))
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(togglePlay(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func togglePlay(_ sender: UIButton) {
            if isPlaying {
                audioEngine.stop()
                sender.setTitle("Play", for: .normal)
            } else {
                let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
                let mixer = audioEngine.mainMixerNode
                audioEngine.attach(sourceNode)
                audioEngine.connect(sourceNode, to: mixer, format: format)
                try? audioEngine.start()
                sender.setTitle("Stop", for: .normal)
            }
            isPlaying = !isPlaying
        }
}
