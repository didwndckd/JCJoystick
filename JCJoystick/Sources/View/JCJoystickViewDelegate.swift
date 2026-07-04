//
//  JCJoystickViewDelegate.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/28.
//

import Foundation

public protocol JCJoystickViewDelegate: AnyObject {
    func joystickView(joystickView: JCJoystickView, shouldDrag state: JCJoystickState) -> Bool
    func joystickView(joystickView: JCJoystickView, beganDrag state: JCJoystickState)
    func joystickView(joystickView: JCJoystickView, didDrag state: JCJoystickState)
    func joystickView(joystickView: JCJoystickView, didEndDrag state: JCJoystickState)
}

public extension JCJoystickViewDelegate {
    func joystickView(joystickView: JCJoystickView, shouldDrag state: JCJoystickState) -> Bool { true }
    func joystickView(joystickView: JCJoystickView, beganDrag state: JCJoystickState) {}
    func joystickView(joystickView: JCJoystickView, didDrag state: JCJoystickState) {}
    func joystickView(joystickView: JCJoystickView, didEndDrag state: JCJoystickState) {}
}
