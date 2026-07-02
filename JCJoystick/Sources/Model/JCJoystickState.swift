//
//  JCJoystickState.swift
//  JCJoystick
//
//  Created by yjc on 7/3/26.
//

import Foundation

public struct JCJoystickState: Sendable {
    /// thumb 위치
    public let location: CGPoint
    /// 이동 한계 반경(unlimited의 경우 boundary)
    public let radius: CGFloat
    /// 각도
    public let radian: CGFloat
    /// 중심에서 location까지의 거리
    public let distance: CGFloat
    
    /// 각도(degree)
    public var degree: CGFloat { radian * (180 / .pi) }
    /// 중심에서 location까지의 거리 비율
    public var distanceRatio: CGFloat { distance / radius }
}
