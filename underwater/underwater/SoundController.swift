import SwiftUI
import AVFoundation

class SoundEngine {
    var audioEngine: AVAudioEngine!
    var sourceNode: AVAudioSourceNode!
    var isPlaying = false
    var amplitude: Double = 0.5
    var frequency: Double = 440.0 // Frequency in Hz
    var modulationType: String = "AM" // Placeholder for modulation type
    var pulseDuration: Double = 1.0 // Placeholder for pulse duration
    var pulseInterval: Double = 2.0 // Placeholder for pulse interval
    var phase: Double = 0.0 // Placeholder for phase control
    var bandwidth: Double = 20.0 // Placeholder for bandwidth control
    var equalization: Double = 1.0 // Placeholder for equalization control
    
    func updateParameters(from viewModel: SoundViewModel) {
            self.amplitude = viewModel.amplitude
            self.frequency = viewModel.frequency
            self.modulationType = viewModel.modulationType
            self.pulseDuration = viewModel.pulseDuration
            self.pulseInterval = viewModel.pulseInterval
            self.phase = viewModel.phase
            self.bandwidth = viewModel.bandwidth
            self.equalization = viewModel.equalization
        }
    
    func generateWave(frame: Int, frameCount: AVAudioFrameCount) -> Int16 {
            // Integrate amplitude, phase, and other variables here to generate the wave
            let value = amplitude * sin(2.0 * .pi * frequency * Double(frame) / 44100.0 + phase)
            let scaledValue = Int16(value * 32767.0)
            return scaledValue
        }
    
    func setup(in view: UIView) {
        audioEngine = AVAudioEngine()
        
        sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let scaledValue = self.generateWave(frame: frame, frameCount: frameCount)
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
    }
    
    func startPlaying() {
        if !isPlaying {
            guard let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1),
                  let mixer = audioEngine?.mainMixerNode else {
                return
            }
            audioEngine?.attach(sourceNode)
            audioEngine?.connect(sourceNode, to: mixer, format: format)
            try? audioEngine?.start()
            isPlaying = true
        }
    }
    
    func stopPlaying() {
            if isPlaying {
                audioEngine.stop()
                isPlaying = false
            }
        }
}
