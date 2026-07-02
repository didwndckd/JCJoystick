//
//  JCJoystickDeltaTests.swift
//  JCJoystickTests
//

import Testing
import CoreGraphics
@testable import JCJoystick

struct JCJoystickDeltaTests {

    @Test("origin → destination 벡터로 x, y 를 계산한다")
    func delta_computesXY() {
        let delta = JCJoystickDelta(origin: CGPoint(x: 10, y: 10),
                                    destination: CGPoint(x: 13, y: 14))
        #expect(abs(delta.x - 3) < 1e-9)
        #expect(abs(delta.y - 4) < 1e-9)
    }

    @Test("제곱 거리와 직선 거리를 계산한다")
    func delta_squaredDistanceAndDistance() {
        let delta = JCJoystickDelta(origin: .zero, destination: CGPoint(x: 3, y: 4))
        #expect(abs(delta.squaredDistance - 25) < 1e-9)
        #expect(abs(delta.distance - 5) < 1e-9)
    }

    @Test("radian 은 atan2(y, x) 순서로 계산한다")
    func delta_radianUsesAtan2InYXOrder() {
        // +x 축 → 0
        #expect(abs(JCJoystickDelta(origin: .zero, destination: CGPoint(x: 1, y: 0)).radian - 0) < 1e-9)
        // +y 축 → π/2
        #expect(abs(JCJoystickDelta(origin: .zero, destination: CGPoint(x: 0, y: 1)).radian - .pi / 2) < 1e-9)
        // -x 축 → π
        #expect(abs(JCJoystickDelta(origin: .zero, destination: CGPoint(x: -1, y: 0)).radian - .pi) < 1e-9)
    }

    @Test("영벡터는 거리와 radian 이 0 이다")
    func delta_zeroDeltaProducesZeroDistanceAndRadian() {
        let delta = JCJoystickDelta(origin: CGPoint(x: 5, y: 5), destination: CGPoint(x: 5, y: 5))
        #expect(abs(delta.distance) < 1e-9)
        #expect(abs(delta.radian) < 1e-9)
    }
}
