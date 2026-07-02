//
//  JCThumbLimitStyleTests.swift
//  JCJoystickTests
//

import Testing
import CoreGraphics
@testable import JCJoystick

struct JCThumbLimitStyleTests {

    // boundaryRadius 100, thumbRadius 20 기준의 스타일별 기대 maximumRadius (unlimited = nil)
    private static let cases: [(JCThumbLimitStyle, CGFloat?)] = [
        (.inside, 80),                                 // 100 - 20
        (.outside, 120),                               // 100 + 20
        (.center, 100),                                // 100
        (.customWithConstant(constant: 50), 150),      // 100 + 50
        (.customWithConstant(constant: -30), 70),      // 100 - 30
        (.customWithMultiplier(multiplier: 1.5), 150), // 100 * 1.5
        (.customWithMultiplier(multiplier: 0.5), 50),  // 100 * 0.5
        (.unlimited, nil),
    ]

    @Test("스타일별 maximumRadius 를 계산한다 (unlimited = nil)",
          arguments: JCThumbLimitStyleTests.cases)
    func maximumRadius_perStyle(style: JCThumbLimitStyle, expected: CGFloat?) {
        let maximumRadius = style.maximumRadius(boundaryRadius: 100, thumbRadius: 20)
        if let expected {
            #expect(maximumRadius != nil)
            #expect(abs((maximumRadius ?? 0) - expected) < 1e-9)
        } else {
            #expect(maximumRadius == nil)
        }
    }
}
