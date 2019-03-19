import UIKit
import PlaygroundSupport

extension CGPoint {
    
    var length: CGFloat {
        return sqrt(x * x + y * y)
    }
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func *(lhs: CGFloat, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    
    static func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
}


struct ScrollTimingParameters {
    var initialValue: CGPoint
    var initialVelocity: CGPoint
    var decelerationRate: CGFloat
    var threshold: CGFloat
}

extension ScrollTimingParameters {
    
    var destination: CGPoint {
        assert(decelerationRate < 1 && decelerationRate > 0)
        
        let dCoeff = 1000 * log(decelerationRate)
        return initialValue - initialVelocity / dCoeff
    }
    
    var duration: TimeInterval {
        assert(decelerationRate < 1 && decelerationRate > 0)
        
        if initialVelocity.length == 0 {
            return 0
        }
        
        let dCoeff = 1000 * log(decelerationRate)
        return TimeInterval(log(-dCoeff * threshold / initialVelocity.length) / dCoeff)
    }
    
    func value(at time: TimeInterval) -> CGPoint {
        assert(decelerationRate < 1 && decelerationRate > 0)
        
        let dCoeff = 1000 * log(decelerationRate)
        return initialValue + (pow(decelerationRate, CGFloat(1000 * time)) - 1) / dCoeff * initialVelocity
    }
    
}

extension CAShapeLayer {
    
    static func makeCurveLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.darkGray.cgColor
        layer.lineWidth = 4
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }
    
}

// Setup scroll timing parameters
let initialValue = CGPoint(x: 0, y: 0)
let initialVelocity = CGPoint(x: 0, y: 10)
let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
let threshold = CGFloat(0.01)

let timingParameters = ScrollTimingParameters(initialValue: initialValue,
    initialVelocity: initialVelocity, decelerationRate: decelerationRate, threshold: threshold)

let duration = timingParameters.duration
let destination = timingParameters.destination

// Make canvas
let canvasSize = CGSize(width: 600, height: 400)
let canvasView = UIView()
canvasView.frame = CGRect(origin: .zero, size: canvasSize)
canvasView.backgroundColor = .white
let curveLayer = CAShapeLayer.makeCurveLayer()
canvasView.layer.addSublayer(curveLayer)

// Make path
let path = UIBezierPath()
path.move(to: CGPoint(x: 0, y: canvasSize.height))
let sampleCount = 100
for i in 0..<sampleCount {
    let progress = CGFloat(i) / CGFloat(sampleCount)
    let time = TimeInterval(progress) * duration
    let valueProgress = (timingParameters.value(at: time) - initialValue).length
        / (destination - initialValue).length
    
    let x = CGFloat(time) * 200
    let y = canvasSize.height - valueProgress * canvasSize.height
    
    path.addLine(to: CGPoint(x: x, y: y))
}
curveLayer.path = path.cgPath

// Draw canvas
PlaygroundPage.current.liveView = canvasView

