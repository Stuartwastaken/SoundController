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
                    Text("Amplitude:")
                    Slider(value: $viewModel.amplitude)
                }
                
                // Frequency Control
                HStack {
                    Text("Frequency:")
                    Slider(value: $viewModel.frequency)
                }
                
                // Modulation
                Picker("Modulation Type", selection: $viewModel.modulationType) {
                    Text("AM").tag("AM")
                    Text("FM").tag("FM")
                }
                
                // Pulse Duration & Interval
                HStack {
                    Text("Pulse Duration:")
                    Slider(value: $viewModel.pulseDuration)
                }
                
                HStack {
                    Text("Pulse Interval:")
                    Slider(value: $viewModel.pulseInterval)
                }
                
                // Phase Control
                HStack {
                    Text("Phase:")
                    Slider(value: $viewModel.phase)
                }
                
                // Bandwidth Control
                HStack {
                    Text("Bandwidth:")
                    Slider(value: $viewModel.bandwidth)
                }
                
                // Equalization Control
                HStack {
                    Text("Equalization:")
                    Slider(value: $viewModel.equalization)
                }
                
                // Start/Stop button
                Button("Start") {
                    viewModel.startPlaying()
                }
                
                Button("Stop") {
                    viewModel.stopPlaying()
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


