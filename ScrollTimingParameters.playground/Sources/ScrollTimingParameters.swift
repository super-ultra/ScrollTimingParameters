import Foundation
import CoreGraphics

public struct ScrollTimingParameters {
    public var initialValue: CGPoint
    public var initialVelocity: CGPoint
    public var decelerationRate: CGFloat
    public var threshold: CGFloat
    
    public init(initialValue: CGPoint, initialVelocity: CGPoint, decelerationRate: CGFloat,
        threshold: CGFloat)
    {
        self.initialValue = initialValue
        self.initialVelocity = initialVelocity
        self.decelerationRate = decelerationRate
        self.threshold = threshold
    }
}

public extension ScrollTimingParameters {
    
    public var destination: CGPoint {
        assert(decelerationRate < 1 && decelerationRate > 0)
        
        let dCoeff = 1000 * log(decelerationRate)
        return initialValue - initialVelocity / dCoeff
    }
    
    public var duration: TimeInterval {
        assert(decelerationRate < 1 && decelerationRate > 0)
        
        if initialVelocity.length == 0 {
            return 0
        }
        
        let dCoeff = 1000 * log(decelerationRate)
        return TimeInterval(log(-dCoeff * threshold / initialVelocity.length) / dCoeff)
    }
    
    public func value(at time: TimeInterval) -> CGPoint {
        assert(decelerationRate < 1 && decelerationRate > 0)
        
        let dCoeff = 1000 * log(decelerationRate)
        return initialValue + (pow(decelerationRate, CGFloat(1000 * time)) - 1) / dCoeff * initialVelocity
    }
    
}
