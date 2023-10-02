class WaveformView: UIView {
    var data: [Int16] = [] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Set up graphics context
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.blue.cgColor)
        
        // Calculate scaling factors for rendering the waveform
        let xScale = bounds.width / CGFloat(data.count)
        let yScale = bounds.height / CGFloat(Int16.max)
        
        // Move to initial position
        context.move(to: CGPoint(x: 0, y: bounds.height / 2))
        
        // Draw waveform data
        for (index, sample) in data.enumerated() {
            let x = CGFloat(index) * xScale
            let y = CGFloat(sample) * yScale + bounds.height / 2
            context.addLine(to: CGPoint(x: x, y: y))
        }
        
        context.strokePath()
    }
}
