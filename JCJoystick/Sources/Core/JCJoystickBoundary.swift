//
//  File.swift
//  JCJoystick
//
//  Created by yjc on 7/2/26.
//

import Foundation

public struct JCJoystickBoundary: Sendable {
    public let width: CGFloat
    public let height: CGFloat
    
    /// boundary 기준 반경
    public var radius: CGFloat {
        min(width, height) / 2
    }
    
    /// boundary 기준 센터
    public var center: CGPoint {
        let x = width / 2
        let y = height / 2
        return .init(x: x, y: y)
    }
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    public init(size: CGSize) {
        self.width = size.width
        self.height = size.height
    }
}
