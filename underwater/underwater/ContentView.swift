//
//  ContentView.swift
//  underwater
//
//  Created by Stuart Ray on 9/9/23.
//
import SwiftUI

struct ContentView: View {
    // ViewModel instance
    @ObservedObject var viewModel = SoundViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                // Amplitude Control
                HStack {
                    Text("Amplitude: \(viewModel.amplitude, specifier: "%.3f")")
                    Slider(value: $viewModel.amplitude)
                }
                
                // Frequency Control
                HStack {
                    Text("Frequency: \(Int(viewModel.frequency)) Hz")
                    Slider(value: $viewModel.frequency)
                }
                
                // Modulation
                Picker("Modulation Type (\(viewModel.modulationType))", selection: $viewModel.modulationType) {
                    Text("AM").tag("AM")
                    Text("FM").tag("FM")
                }
                
                // Pulse Duration & Interval
                HStack {
                    Text("Pulse Duration: \(viewModel.pulseDuration, specifier: "%.3f") s")
                    Slider(value: $viewModel.pulseDuration)
                }
                
                HStack {
                    Text("Pulse Interval: \(viewModel.pulseInterval, specifier: "%.3f") s")
                    Slider(value: $viewModel.pulseInterval)
                }
                
                // Phase Control
                HStack {
                    Text("Phase: \(viewModel.phase, specifier: "%.3f") radians")
                    Slider(value: $viewModel.phase)
                }
                
                // Bandwidth Control
                HStack {
                    Text("Bandwidth: \(Int(viewModel.bandwidth)) Hz")
                    Slider(value: $viewModel.bandwidth)
                }
                
                // Equalization Control
                HStack {
                    Text("Equalization: \(viewModel.equalization, specifier: "%.3f")")
                    Slider(value: $viewModel.equalization)
                }
                
                // Start/Stop button
                Button(viewModel.isPlaying ? "Stop" : "Start") {
                    viewModel.togglePlaying()
                }
                
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



