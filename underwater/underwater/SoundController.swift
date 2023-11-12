import SwiftUI
import AVFoundation
import UIKit

struct SoundController: UIViewControllerRepresentable {
    @Binding var frequency: Double
    @Binding var chirpRate: Double
    @Binding var time: Float
    @Binding var spreadingFactor: Int
    var onFrequencyTimeChange: ((Double, Float) -> Void)?

    func makeUIViewController(context: Context) -> SoundViewController {
        let controller = SoundViewController()
        controller.frequency = frequency
        controller.chirpRate = chirpRate
        controller.time = time
        controller.spreadingFactor = spreadingFactor
        controller.onFrequencyTimeChange = self.onFrequencyTimeChange
        return controller
    }

    func updateUIViewController(_ uiViewController: SoundViewController, context: Context) {
        uiViewController.frequency = frequency
        uiViewController.chirpRate = chirpRate
        uiViewController.time = time
        uiViewController.spreadingFactor = spreadingFactor
        uiViewController.onFrequencyTimeChange = self.onFrequencyTimeChange
    }
}

class SoundViewController: UIViewController {
    var frequency: Double = 0.0
    var chirpRate: Double = 50.0
    var time: Float = 0.01
    var spreadingFactor: Int = 12
    var onFrequencyTimeChange: ((Double, Float) -> Void)?
    var audioEngine: AVAudioEngine!
    var sourceNode: AVAudioSourceNode!
    var isPlaying = false
    var timer: Timer?
    var phaseAccumulator: Double = 0.0
    var frequencyAccumulator: Double = 0.0
    let frequencyIncrement: Double = 10
    var chirpDuration: Double = 4

    func generateChirp() -> Int16 {
        phaseAccumulator += 2.0 * .pi * frequency / 44100.0
        if phaseAccumulator > 2.0 * .pi {
            phaseAccumulator -= 2.0 * .pi
        }
        let chirp = sin(phaseAccumulator)
        return Int16(chirp * 32767.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            let currentTime = Date().timeIntervalSince1970.truncatingRemainder(dividingBy: self.chirpDuration)
            self.frequency = (0 + (22000 / (4 * self.chirpDuration)) * currentTime)
            self.time = Float(currentTime)
            self.onFrequencyTimeChange?(self.frequency, self.time)
        }
    }

    func setup() {
        audioEngine = AVAudioEngine()
        sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let chirp = self.generateChirp()
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Int16> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = chirp
                }
            }
            return noErr
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
        let button = UIButton(frame: CGRect(x: 120, y: 200, width: 80, height: 40))
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(togglePlay(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func togglePlay(_ sender: UIButton) {
        if isPlaying {
            audioEngine.stop()
            audioEngine.disconnectNodeOutput(sourceNode)
            sender.setTitle("Play", for: .normal)
        } else {
            if let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1) {
                let mixer = audioEngine.mainMixerNode
                audioEngine.attach(sourceNode)
                audioEngine.connect(sourceNode, to: mixer, format: format)
                do {
                    try audioEngine.start()
                    sender.setTitle("Stop", for: .normal)
                } catch {
                    print("Error starting audio engine: \(error)")
                }
            } else {
                print("Cannot create AVAudioFormat")
            }
        }
        isPlaying = !isPlaying
    }
}
