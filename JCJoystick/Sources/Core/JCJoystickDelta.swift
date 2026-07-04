//
//  JCJoystickDelta.swift
//  JCJoystick
//
//  Created by yjc on 7/3/26.
//

import Foundation

public struct JCJoystickDelta: Sendable {
    public let x: Double
    public let y: Double
    
    /// 직선거리^2
    public var squaredDistance: Double {
        return x * x + y * y
    }

    /// 직선 거리
    public var distance: Double {
        return sqrt(squaredDistance)
    }
    
    /// 각도
    public var radian: Double {
        return atan2(y, x)
    }
    
    public init(origin: CGPoint, destination: CGPoint) {
        self.x = destination.x - origin.x
        self.y = destination.y - origin.y
    }
}
