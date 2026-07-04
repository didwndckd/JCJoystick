//
//  JCJoystickView.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/22.
//

import UIKit

open class JCJoystickView: UIView {
    public weak var delegate: JCJoystickViewDelegate?
    
    private let _boundaryView = JCJoystickBoundaryView()
    private let _thumbView = JCCircleView()
    private lazy var thumbViewDiameterConstraint = self.thumbView.widthAnchor.constraint(equalToConstant: 50)
    
    open var boundaryView: JCJoystickBoundaryView {
        self._boundaryView
    }
    
    open var thumbView: JCCircleView {
        self._thumbView
    }
    
    public var thumbLimitStyle: JCThumbLimitStyle = .inside
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupAttribute()
        self.setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupAttribute()
        self.setupLayout()
    }
    
    private func createCalculator() -> JCJoystickCalculator {
        JCJoystickCalculator(
            boundary: .init(size: boundaryView.bounds.size),
            thumbDiameter: thumbDiameter,
            thumbLimitStyle: thumbLimitStyle
        )
    }
    
    open func beganDrag(location: CGPoint) {
        let state = createCalculator().calculate(location: location)
        
        guard self.delegate?.joystickView(joystickView: self, shouldDrag: state) ?? true else { return }
        
        self.thumbView.center = state.location
        self.delegate?.joystickView(joystickView: self, beganDrag: state)
        self.delegate?.joystickView(joystickView: self, didDrag: state)
    }
    
    open func dragging(location: CGPoint) {
        let state = createCalculator().calculate(location: location)
        
        guard self.delegate?.joystickView(joystickView: self, shouldDrag: state) ?? true else { return }
        
        self.thumbView.center = state.location
        self.delegate?.joystickView(joystickView: self, didDrag: state)
    }
    
    open func endDrag() {
        let state = createCalculator().calculate(location: self.boundaryView.centerPoint)
        
        self.thumbView.center = state.location
        self.delegate?.joystickView(joystickView: self, didEndDrag: state)
    }
    
}

extension JCJoystickView {
    private func setupAttribute() {
        self._boundaryView.layer.borderColor = UIColor.darkGray.cgColor
        self._boundaryView.layer.borderWidth = 8
        self._boundaryView.delegate = self
        
        self._thumbView.layer.borderColor = UIColor.gray.cgColor
        self._thumbView.layer.borderWidth = 8
    }
    
    private func setupLayout() {
        self.addSubview(self.boundaryView)
        self.boundaryView.translatesAutoresizingMaskIntoConstraints = false
        
        [self.boundaryView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
         self.boundaryView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
         self.boundaryView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor),
         self.boundaryView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
         self.boundaryView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
         self.boundaryView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
         self.boundaryView.widthAnchor.constraint(equalTo: self.boundaryView.heightAnchor),
         self.boundaryView.heightAnchor.constraint(equalTo: self.boundaryView.widthAnchor)].forEach { $0.isActive = true }

        [self.boundaryView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
         self.boundaryView.topAnchor.constraint(equalTo: self.topAnchor),
         self.boundaryView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         self.boundaryView.bottomAnchor.constraint(equalTo: self.bottomAnchor)].forEach { constraint in
            constraint.priority = .init(999)
            constraint.isActive = true
        }
        
        self.boundaryView.addSubview(self.thumbView)
        self.thumbView.translatesAutoresizingMaskIntoConstraints = false
        
        [self.thumbView.centerXAnchor.constraint(equalTo: self.boundaryView.centerXAnchor),
         self.thumbView.centerYAnchor.constraint(equalTo: self.boundaryView.centerYAnchor),
         self.thumbViewDiameterConstraint,
         self.thumbView.heightAnchor.constraint(equalTo: self.thumbView.widthAnchor)].forEach { $0.isActive = true }
    }
}

extension JCJoystickView {
    public var thumbDiameter: CGFloat {
        get { min(thumbView.bounds.width, thumbView.bounds.height) }
        set {
            self.thumbViewDiameterConstraint.constant = newValue
            self.layoutIfNeeded()
        }
    }
    
    public var boundaryImage: UIImage? {
        get { self._boundaryView.image }
        set { self._boundaryView.image = newValue }
    }
    
    public var boundaryImageView: UIImageView {
        return self.boundaryView.imageView
    }
    
    public var thumbImage: UIImage? {
        get { self._thumbView.image }
        set { self._thumbView.image = newValue }
    }
    
    public var thumbImageView: UIImageView {
        return self.thumbView.imageView
    }
}

extension JCJoystickView: JCJoystickBoundaryViewDelegate {
    func boundaryView(boundaryView: JCJoystickBoundaryView, event: JCJoystickBoundaryView.Event) {
        switch event {
        case .began(let location):
            self.beganDrag(location: location)
        case .moved(let location):
            self.dragging(location: location)
        case .end:
            self.endDrag()
        }
    }
}
