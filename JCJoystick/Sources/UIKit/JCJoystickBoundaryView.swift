//
//  JCJoystickBoundaryView.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/23.
//

import UIKit

protocol JCJoystickBoundaryViewDelegate: AnyObject {
    func boundaryView(boundaryView: JCJoystickBoundaryView, event: JCJoystickBoundaryView.Event)
}

open class JCJoystickBoundaryView: JCCircleView {
    
    weak var delegate: JCJoystickBoundaryViewDelegate?
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let location = touches.first?.location(in: self) else { return }
        self.delegate?.boundaryView(boundaryView: self, event: .began(location))
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let location = touches.first?.location(in: self) else { return }
        self.delegate?.boundaryView(boundaryView: self, event: .moved(location))
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.delegate?.boundaryView(boundaryView: self, event: .end)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.delegate?.boundaryView(boundaryView: self, event: .end)
    }
}

extension JCJoystickBoundaryView {
    enum Event {
        case began(CGPoint)
        case moved(CGPoint)
        case end
    }
}
