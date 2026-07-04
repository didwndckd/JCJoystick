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
    
    open var maximumRadius: CGFloat? {
        switch self.thumbLimitStyle {
        case .inside:
            return self.boundaryView.radius - self.thumbView.radius
        case .outside:
            return self.boundaryView.radius + self.thumbView.radius
        case .center:
            return self.boundaryView.radius
        case .customWithConstant(constant: let constant):
            return self.boundaryView.radius + constant
        case .customWithMultiplier(multiplier: let multiplier):
            return self.boundaryView.radius * multiplier
        case .unlimited:
            return nil
        }
    }
    
    public var thumbSizeMultiplier: CGFloat = 0.25 {
        didSet {
            self.updateThumbViewSizeConstraint()
        }
    }

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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateThumbViewSizeConstraint()
    }
    
    private func createCalculator() -> JCJoystickCalculator {
        JCJoystickCalculator(
            boundary: .init(size: boundaryView.bounds.size),
            thumbSize: thumbView.bounds.size,
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
        
        guard self.delegate?.joystickView(joystickView: self, shouldDrag: state) ?? true else { return }
        
        self.thumbView.center = state.location
        self.delegate?.joystickView(joystickView: self, didDrag: state)
        self.delegate?.joystickView(joystickView: self, didEndDrag: state)
    }
    
}

extension JCJoystickView {
    
    private var defaultBoundaryImage: UIImage {
        return self.createDefaultImage(borderColor: .darkGray, borderWidth: 8)
    }
    
    private var defaultThumbImage: UIImage {
        return self.createDefaultImage(borderColor: .gray, borderWidth: 20)
    }
    
    private func createDefaultImage(borderColor: UIColor, borderWidth: CGFloat) -> UIImage {
        let imageSize = CGSize(width: 200, height: 200)
        let view = UIView(frame: .init(origin: .zero, size: imageSize))
        view.backgroundColor = .white
        view.layer.cornerRadius = imageSize.height / 2
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }
    
    private func setupAttribute() {
        self._boundaryView.image = self.defaultBoundaryImage
        self._thumbView.image = self.defaultThumbImage
        self._boundaryView.delegate = self
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
    
    private func updateThumbViewSizeConstraint() {
        let multiplier = self.thumbSizeMultiplier <= 1 ? self.thumbSizeMultiplier: 1
        let constant = self.boundaryView.bounds.width * multiplier
        self.thumbViewDiameterConstraint.constant = constant
        self.layoutIfNeeded()
    }
}

extension JCJoystickView {
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
