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
            (.pi / 4, 45),
            (.pi / 2, 90),
            (.pi, 180),
            (-.pi / 2, -90),
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
}
