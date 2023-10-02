import SwiftUI
import AVFoundation

struct SoundController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SoundController>) -> UIViewController {
        let viewController = UIViewController()
        let soundEngine = SoundEngine()
        soundEngine.setup(in: viewController.view)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<SoundController>) {
        // Update code here, if needed
    }
}

class SoundEngine {
    var audioEngine: AVAudioEngine!
    var sourceNode: AVAudioSourceNode!
    var isPlaying = false
    var frequency: Double = 440.0 // Frequency in Hz
    var frequencyLabel: UILabel!
    
    func generateWave(frequency: Double, frame: Int, frameCount: AVAudioFrameCount) -> Int16 {
        let value = sin(2.0 * .pi * frequency * Double(frame) / 44100.0)
        let scaledValue = Int16(value * 32767.0)
        return scaledValue
    }

    
    func setup(in view: UIView) {
        audioEngine = AVAudioEngine()
        
        // Slider
        let slider = UISlider(frame: CGRect(x: 20, y: 100, width: 280, height: 20))
        slider.minimumValue = 20
        slider.maximumValue = 2000
        slider.value = 440
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        view.addSubview(slider)
        
        frequencyLabel = UILabel(frame: CGRect(x: 20, y: 50, width: 280, height: 20))
        frequencyLabel.text = "Frequency: \(frequency) Hz"
        view.addSubview(frequencyLabel)
        
        // Button
        let button = UIButton(frame: CGRect(x: 120, y: 200, width: 80, height: 40))
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(togglePlay(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let scaledValue = self.generateWave(frequency: self.frequency, frame: frame, frameCount: frameCount)
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Int16> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = scaledValue
                }
            }
            return noErr
        }

    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        frequency = Double(sender.value)
        frequencyLabel.text = "Frequency: \(frequency) Hz"
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
