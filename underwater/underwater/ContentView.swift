import SwiftUI

struct ContentView: View {
    @State var frequency: Double = 440.0
    @State var chirpRate: Double = 50.0
    @State var time: Float = 0.0 // Initialize to 0
    @State var spreadingFactor: Int = 12

    var body: some View {
        VStack {
            Text("Frequency: \(frequency, specifier: "%.1f") Hz")
            
            Text("Chirp Rate: \(chirpRate, specifier: "%.1f") Hz/s")
            Slider(value: $chirpRate, in: 0...100)
            
            Text("Time: \(time, specifier: "%.2f") s (0 - 5)")
            
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

