//
//  JCThumbLimitStyle.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/27.
//

import Foundation

public enum JCThumbLimitStyle: Sendable {
    case inside
    case outside
    case center
    case customWithConstant(constant: CGFloat)
    case customWithMultiplier(multiplier: CGFloat)
    case unlimited

    /// thumb 이 이동할 수 있는 최대 반경. `nil` 이면 제한 없음(unlimited).
    func maximumRadius(boundaryRadius: CGFloat, thumbRadius: CGFloat) -> CGFloat? {
        switch self {
        case .inside:
            return boundaryRadius - thumbRadius
        case .outside:
            return boundaryRadius + thumbRadius
        case .center:
            return boundaryRadius
        case .customWithConstant(let constant):
            return boundaryRadius + constant
        case .customWithMultiplier(let multiplier):
            return boundaryRadius * multiplier
        case .unlimited:
            return nil
        }
    }
}
