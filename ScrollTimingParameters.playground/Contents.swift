import UIKit
import PlaygroundSupport

extension UIView {

    func scroll(initialVelocity: CGPoint, decelerationRate: CGFloat) -> TimerAnimation {
        let threshold = CGFloat(0.01)
        
        let timingParameters = ScrollTimingParameters(
            initialValue: frame.origin,
            initialVelocity: initialVelocity,
            decelerationRate: decelerationRate,
            threshold: threshold)
        
        return TimerAnimation(duration: timingParameters.duration,
            animations: { [weak self] progress in
                self?.frame.origin = timingParameters.value(at: progress * timingParameters.duration)
            })
    }

}

// Make canvas
let canvasSize = CGSize(width: 600, height: 400)
let canvasView = UIView(frame: CGRect(origin: .zero, size: canvasSize))
canvasView.backgroundColor = .white

// Make circles
let circleSize = CGSize(width: 64, height: 64)

func makeCircle(color: UIColor, center: CGPoint) -> UIView {
    let circle = UIView(frame: CGRect(origin: .zero, size: circleSize))
    circle.center = center
    circle.backgroundColor = color
    circle.layer.masksToBounds = true
    circle.layer.cornerRadius = circleSize.width / 2
    canvasView.addSubview(circle)
    return circle
}

let normalCircle = makeCircle(
    color: UIColor(red: 0.98, green: 0.5, blue: 0.45, alpha: 1),
    center: CGPoint(x: 0.0, y: 0.33 * canvasSize.height))

let fastCircle = makeCircle(
    color: UIColor(red: 0.5, green: 0, blue: 1, alpha: 1),
    center: CGPoint(x: 0.0, y: 0.66 * canvasSize.height))


// Run animation
let initialVelocity = CGPoint(x: 1000, y: 0)

let normalAnimation = normalCircle.scroll(initialVelocity: initialVelocity,
    decelerationRate: UIScrollView.DecelerationRate.normal.rawValue)

let fastAnimation = fastCircle.scroll(initialVelocity: initialVelocity,
    decelerationRate: UIScrollView.DecelerationRate.fast.rawValue)

// Draw canvas
PlaygroundPage.current.liveView = canvasView

