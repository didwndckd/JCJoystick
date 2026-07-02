//
//  JCJoystickBoundaryTests.swift
//  JCJoystickTests
//

import Testing
import CoreGraphics
@testable import JCJoystick

struct JCJoystickBoundaryTests {

    @Test("정사각형: radius 와 center 를 계산한다")
    func boundary_square_radiusAndCenter() {
        let boundary = JCJoystickBoundary(width: 200, height: 200)
        #expect(abs(boundary.radius - 100) < 1e-9)
        #expect(abs(boundary.center.x - 100) < 1e-9)
        #expect(abs(boundary.center.y - 100) < 1e-9)
    }

    @Test("직사각형: radius 는 짧은 변(min) 기준이다")
    func boundary_rect_radiusUsesShorterSide() {
        let boundary = JCJoystickBoundary(width: 200, height: 100)
        #expect(abs(boundary.radius - 50) < 1e-9)   // min(200, 100) / 2
        #expect(abs(boundary.center.x - 100) < 1e-9)
        #expect(abs(boundary.center.y - 50) < 1e-9)
    }
}
