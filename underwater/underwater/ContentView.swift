import SwiftUI

struct WaveformViewRepresentable: UIViewRepresentable {
    @Binding var data: [Int16]

    func makeUIView(context: Context) -> WaveformView {
        return WaveformView()
    }

    func updateUIView(_ uiView: WaveformView, context: Context) {
        uiView.data = data
    }
}

struct ContentView: View {
    @State var frequency: Double = 100.0
    @State var chirpRate: Double = 50.0
    @State var time: Float = 1.0
    @State var spreadingFactor: Int = 12
    @State private var waveform: [Int16] = []
    @State var soundController = SoundViewController()
    
    
    var body: some View {
        
        soundController.setWaveformUpdater { newWaveform in
            self.waveform = newWaveform
        }
        
        VStack {
            Text("Frequency: \(frequency, specifier: "%.1f") Hz")
            Slider(value: $frequency, in: 0...1000)
            
            Text("Chirp Rate: \(chirpRate, specifier: "%.1f") Hz/s")
            Slider(value: $chirpRate, in: 0...100)
            
            Text("Time: \(time, specifier: "%.2f") s")
            Slider(value: $time, in: 0...10)
            
            HStack {
                            Text("Spreading Factor: \(spreadingFactor)")
                            Button("−") {
                                if spreadingFactor > 1 {
                                    spreadingFactor -= 1
                                }
                            }
                            .padding(.leading, 20)
                            
                            Button("+") {
                                if spreadingFactor < 12 {
                                    spreadingFactor += 1
                                }
                            }
                            .padding(.leading, 10)
                        }
                        
                        SoundController(frequency: $frequency, chirpRate: $chirpRate, time: $time, spreadingFactor: $spreadingFactor)
                    }
        .padding()
    }
}
