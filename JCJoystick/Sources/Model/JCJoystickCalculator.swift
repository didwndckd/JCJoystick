//
//  JCJoystickCalculator.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/22.
//

import Foundation

/// 조이스틱의 각도·거리·위치 조정(clamping) 계산을 담당하는 순수 계산기.
public struct JCJoystickCalculator {
    public let boundary: JCJoystickBoundary
    public let thumbLimitStyle: JCThumbLimitStyle
    public let thumbSize: CGSize
    
    public init(boundary: JCJoystickBoundary, thumbSize: CGSize, thumbLimitStyle: JCThumbLimitStyle) {
        self.boundary = boundary
        self.thumbLimitStyle = thumbLimitStyle
        self.thumbSize = thumbSize
    }
}

extension JCJoystickCalculator {
    /// 계산 기준이 되는 중심점 (boundarySize 기준)
    private var center: CGPoint { boundary.center }
    /// 조이스틱 사이즈
    private var thumbRadius: CGFloat { min(thumbSize.width, thumbSize.height) / 2 }
    /// 최대 이동 반경
    private var maximumRadius: CGFloat? { thumbLimitStyle.maximumRadius(boundaryRadius: boundary.radius, thumbRadius: thumbRadius) }
    /// distanceRatio 분모 기준 반경. 무제한이면 boundaryRadius 로 fallback.
    private var referenceRadius: CGFloat {
        maximumRadius ?? boundary.radius
    }

    /// 주어진 반경/각도로 경계원 위의 좌표를 계산 (clamping 지점)
    private func location(radius: CGFloat, radian: CGFloat) -> CGPoint {
        let x = self.center.x + (radius * cos(radian))
        let y = self.center.y + (radius * sin(radian))
        return CGPoint(x: x, y: y)
    }
}

extension JCJoystickCalculator {
    /// 터치 위치를 받아 조정된 위치와 조이스틱 값을 계산한다.
    public func calculate(location: CGPoint) -> JCJoystickState {
        let delta = JCJoystickDelta(origin: center, destination: location)
        let distance = delta.distance
        let radian = delta.radian
        
        // clamp는 maximumRadius가 있을 때만 (nil = 무제한 → 보정 안 함)
        let clampedLocation: CGPoint
        let clampedDistance: CGFloat
        if let maximumRadius, maximumRadius < distance {
            clampedLocation = self.location(radius: maximumRadius, radian: radian)
            clampedDistance = maximumRadius
        } else {
            clampedLocation = location
            clampedDistance = distance
        }

        return JCJoystickState(location: clampedLocation, radius: referenceRadius, radian: radian, distance: clampedDistance)
    }
}
