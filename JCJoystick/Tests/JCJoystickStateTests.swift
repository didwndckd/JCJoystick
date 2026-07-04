//
//  JCJoystickStateTests.swift
//  JCJoystickTests
//

import Testing
import CoreGraphics
@testable import JCJoystick

struct JCJoystickStateTests {

    private func state(radian: CGFloat = 0,
                       distance: CGFloat = 0,
                       radius: CGFloat = 1) -> JCJoystickState {
        JCJoystickState(location: .zero, radius: radius, radian: radian, distance: distance)
    }

    // MARK: - degree

    @Test("radian 을 degree 로 변환한다",
          arguments: [
            (CGFloat(0), CGFloat(0)),
            (CGFloat.pi / 4, 45),
            (CGFloat.pi / 2, 90),
            (CGFloat.pi, 180),
            (-CGFloat.pi / 2, -90),
          ])
    func degree_convertsFromRadian(radian: CGFloat, expected: CGFloat) {
        #expect(abs(state(radian: radian).degree - expected) < 1e-9)
    }

    // MARK: - distanceRatio

    @Test("distanceRatio 는 distance / radius 이다",
          arguments: [
            (CGFloat(0), CGFloat(100), CGFloat(0)),     // 중심
            (50, 100, 0.5),                             // 절반
            (100, 100, 1),                              // 한계
            (150, 100, 1.5),                            // 한계 초과(unlimited)
          ])
    func distanceRatio_isDistanceOverRadius(distance: CGFloat, radius: CGFloat, expected: CGFloat) {
        #expect(abs(state(distance: distance, radius: radius).distanceRatio - expected) < 1e-9)
    }

    @Test("radius 가 0 이면 distanceRatio 는 0 이다 (0 나눗셈 방지)")
    func distanceRatio_whenRadiusIsZero_returnsZero() {
        #expect(state(distance: 50, radius: 0).distanceRatio == 0)
    }
}
