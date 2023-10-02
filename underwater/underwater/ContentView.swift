//
//  ContentView.swift
//  umderwater_communication
//
//  Created by 黃柏森 on 2023/9/24.
//

import SwiftUI

struct ContentView: View {
    // ViewModel instance
    @ObservedObject var viewModel = SoundViewModel()
    @State private var celsius: Double = 0
    
    var body: some View {
        ScrollView {
            VStack {
                
                // Modulation
                Picker("Modulation Type (\(viewModel.modulationType))", selection: $viewModel.modulationType) {
                    Text("AM").tag("AM")
                    Text("FM").tag("FM")
                }
                
                // Frequency Control
                VStack {
                    Text("Frequency: \(viewModel.frequency, specifier: "%.1f") Hz")
                    Slider(value: $viewModel.frequency, in: 0...2200)
                }
                
                
                VStack {
                    Text("time: \(viewModel.pulseDuration, specifier: "%.2f") s")
                    Slider(value: $viewModel.pulseDuration, in: 0...0.05)
                }
                
                // Spreading Factor
                VStack {
                    Text("Spreading Factor: 12") .padding()
                    //Slider(value: $viewModel.amplitude)
                }
                
                // Chirp Rate = (End Frequency - Start Frequency) / Chirp Duration
                VStack {
                    Text("Chirp rate: 440 Hz") .padding()
                }
                
                }
                
                // Start/Stop button
                Button(viewModel.isPlaying ? "Stop" : "Start") {
                    viewModel.togglePlaying()
                }
                
            }.padding()
        }
    }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
