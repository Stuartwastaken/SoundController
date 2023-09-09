//
//  SoundViewModel.swift
//  underwater
//
//  Created by Stuart Ray on 9/9/23.
//

import SwiftUI
import Combine

class SoundViewModel: ObservableObject {
    
    @Published var amplitude: Double = 0.5 // Amplitude Control
    @Published var frequency: Double = 440.0 // Frequency Control
    @Published var modulationType: String = "AM" // Modulation Type
    @Published var pulseDuration: Double = 1.0 // Pulse Duration
    @Published var pulseInterval: Double = 2.0 // Pulse Interval
    @Published var phase: Double = 0.0 // Phase Control
    @Published var bandwidth: Double = 20.0 // Bandwidth Control
    @Published var equalization: Double = 1.0 // Equalization Control
    @Published var isPlaying: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    var soundController: SoundEngine?
    
    init() {
        soundController = SoundEngine() // Initialize your existing SoundController here
        
        // Observe changes to any of the @Published properties and update the SoundController
        Publishers.MergeMany([$amplitude, $frequency, $pulseDuration, $pulseInterval, $phase, $bandwidth, $equalization])
               .sink { [weak self] _ in
                   self?.updateSoundParameters()
               }
               .store(in: &cancellables)
               
           // Observe changes to String properties
           $modulationType
               .sink { [weak self] _ in
                   self?.updateSoundParameters()
               }
               .store(in: &cancellables)
    }
    
    // Function to update SoundController parameters
    func updateSoundParameters() {
        soundController?.amplitude = amplitude
        soundController?.frequency = frequency
        soundController?.modulationType = modulationType
        soundController?.pulseDuration = pulseDuration
        soundController?.pulseInterval = pulseInterval
        soundController?.phase = phase
        soundController?.bandwidth = bandwidth
        soundController?.equalization = equalization
    }

    func togglePlaying() {
        if isPlaying {
            soundController?.stopPlaying()
        } else {
            soundController?.startPlaying()
        }
        isPlaying.toggle()
    }
    // Add any other methods that deal with updating sound parameters or controlling playback
}

