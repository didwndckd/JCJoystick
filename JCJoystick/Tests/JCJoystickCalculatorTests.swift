//
//  JCJoystickCalculatorTests.swift
//  JCJoystickTests
//

import Testing
import CoreGraphics
@testable import JCJoystick

struct JCJoystickCalculatorTests {

    // 고정 조건:
    //   boundary 200x200 → center (100,100), boundaryRadius 100
    //   thumb 지름 40     → thumbRadius 20
    private func calculator(_ style: JCThumbLimitStyle) -> JCJoystickCalculator {
        JCJoystickCalculator(
            boundary: JCJoystickBoundary(width: 200, height: 200),
            thumbDiameter: 40,
            thumbLimitStyle: style
        )
    }

    /// 유한한 maximumRadius 를 갖는 스타일과 그 기대 반경.
    /// boundaryRadius 100, thumbRadius 20 기준.
    private static let finiteCases: [(JCThumbLimitStyle, CGFloat)] = [
        (.inside, 80),                                 // 100 - 20
        (.outside, 120),                               // 100 + 20
        (.center, 100),                                // 100
        (.customWithConstant(constant: 50), 150),      // 100 + 50
        (.customWithConstant(constant: -30), 70),      // 100 - 30
        (.customWithMultiplier(multiplier: 1.5), 150), // 100 * 1.5
        (.customWithMultiplier(multiplier: 0.5), 50),  // 100 * 0.5
    ]

    // MARK: - clamping (유한 스타일)

    @Test("한계 밖으로 드래그하면 maximumRadius 로 clamp 되고 distanceRatio 는 1 이다",
          arguments: JCJoystickCalculatorTests.finiteCases)
    func beyondLimit_clampsToMaximumRadius(style: JCThumbLimitStyle, maximumRadius: CGFloat) {
        // 터치 거리 1000 (+x 방향) → 모든 유한 한계보다 멀다
        let state = calculator(style).calculate(location: CGPoint(x: 1100, y: 100))
        #expect(abs(state.location.x - (100 + maximumRadius)) < 1e-9)  // center.x + 한계반경
        #expect(abs(state.location.y - 100) < 1e-9)
        #expect(abs(state.distance - maximumRadius) < 1e-9)            // 보정된 거리
        #expect(abs(state.radius - maximumRadius) < 1e-9)             // referenceRadius
        #expect(abs(state.distanceRatio - 1) < 1e-9)
    }

    @Test("한계 안에서는 보정 없이 원본 위치를 유지하고 ratio 는 distance / maximumRadius 이다",
          arguments: JCJoystickCalculatorTests.finiteCases)
    func withinLimit_notClamped(style: JCThumbLimitStyle, maximumRadius: CGFloat) {
        // 터치 거리 10 (+x 방향) → 모든 유한 한계(최소 50)보다 안쪽
        let state = calculator(style).calculate(location: CGPoint(x: 110, y: 100))
        #expect(abs(state.location.x - 110) < 1e-9)                   // 원본 유지
        #expect(abs(state.location.y - 100) < 1e-9)
        #expect(abs(state.distance - 10) < 1e-9)
        #expect(abs(state.radius - maximumRadius) < 1e-9)
        #expect(abs(state.distanceRatio - 10 / maximumRadius) < 1e-9)
    }

    // MARK: - unlimited (회귀 방지)

    @Test(".unlimited 은 clamp 되지 않고 ratio 는 1 을 넘을 수 있다")
    func unlimited_neverClamps() {
        // 터치 거리 1000
        let state = calculator(.unlimited).calculate(location: CGPoint(x: 1100, y: 100))
        #expect(abs(state.location.x - 1100) < 1e-9)                  // 원본 위치 유지
        #expect(abs(state.location.y - 100) < 1e-9)
        #expect(abs(state.distance - 1000) < 1e-9)
        #expect(abs(state.radius - 100) < 1e-9)                       // boundaryRadius fallback
        #expect(abs(state.distanceRatio - 10) < 1e-9)                 // 1000 / 100
    }

    // MARK: - 각도

    @Test("radian 은 clamp 여부와 무관하게 방향을 그대로 반영한다",
          arguments: [
            (CGPoint(x: 200, y: 100), CGFloat(0)),          // +x
            (CGPoint(x: 100, y: 200), .pi / 2),             // +y
            (CGPoint(x: 0, y: 100), .pi),                   // -x
            (CGPoint(x: 100, y: 0), -.pi / 2),              // -y
          ])
    func radian_matchesDirection(location: CGPoint, expected: CGFloat) {
        let state = calculator(.unlimited).calculate(location: location)
        #expect(abs(state.radian - expected) < 1e-9)
    }

    @Test("radian 을 degree 로 변환한다")
    func degree_convertsFromRadian() {
        // +y → π/2 → 90°
        let state = calculator(.unlimited).calculate(location: CGPoint(x: 100, y: 200))
        #expect(abs(state.degree - 90) < 1e-9)
    }

    // MARK: - 경계 케이스

    @Test("중심에서는 distance 와 distanceRatio 가 0 이고 NaN 이 없다")
    func atCenter_producesZeroDistanceAndRatioWithoutNaN() {
        let state = calculator(.inside).calculate(location: CGPoint(x: 100, y: 100))
        #expect(abs(state.distance) < 1e-9)
        #expect(abs(state.distanceRatio) < 1e-9)
        #expect(abs(state.radian) < 1e-9)
    }
}
