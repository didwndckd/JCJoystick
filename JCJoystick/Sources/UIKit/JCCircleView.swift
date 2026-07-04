//
//  JCCircleView.swift
//  JCJoystick
//
//  Created by YJC on 2022/04/22.
//

import UIKit

open class JCCircleView: UIView {
    
    private let _imageView = UIImageView()
    
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
        self.setupCornerRadius()
    }
    
    private func setupAttribute() {
        self.imageView.contentMode = .scaleAspectFit
    }
    
    private func setupLayout() {
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        [self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
         self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
         self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)].forEach { $0.isActive = true }
    }
    
    private func setupCornerRadius() {
        let radius = min(self.bounds.width, self.bounds.height) / 2
        self.layer.cornerRadius = radius
    }
}

extension JCCircleView {
    public var radius: CGFloat {
        return min(self.bounds.width, self.bounds.height) / 2
    }
    
    public var centerPoint: CGPoint {
        return CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
    
    public var image: UIImage? {
        get { self.imageView.image }
        set { self.imageView.image = newValue }
    }
    
    public var imageView: UIImageView {
        return self._imageView
    }
}
