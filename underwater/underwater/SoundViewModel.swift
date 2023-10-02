//sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
//    let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
//    for frame in 0..<Int(frameCount) {
//        let chirp = self.generateChirp(frame: frame, frameCount: frameCount)
//        for buffer in ablPointer {
//            let buf: UnsafeMutableBufferPointer<Int16> = UnsafeMutableBufferPointer(buffer)
//            buf[frame] = chirp
//        }
//    }
//    return noErr
//}
//
//
//
//@objc func togglePlay(_ sender: UIButton) {
//        if isPlaying {
//            audioEngine.stop()
//            sender.setTitle("Play", for: .normal)
//        } else {
//            let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
//            let mixer = audioEngine.mainMixerNode
//            audioEngine.attach(sourceNode)
//            audioEngine.connect(sourceNode, to: mixer, format: format)
//            try? audioEngine.start()
//            sender.setTitle("Stop", for: .normal)
//        }
//        isPlaying = !isPlaying
//    }
