//
//  ViewController.swift
//  JCJoystick
//
//  Created by JoongChangYang on 04/14/2022.
//  Copyright (c) 2022 JoongChangYang. All rights reserved.
//

import UIKit
import JCJoystick

/// 라이브러리의 UIKit `JCJoystickView` 를 사용하는 샘플 화면.
/// SwiftUI 샘플(`JoystickSampleView`)과 동일한 구성을 코드로 재현한다.
final class JoystickSampleViewController: UIViewController {

    private enum LimitStyleOption: String, CaseIterable {
        case inside
        case center
        case outside
        case unlimited

        var style: JCThumbLimitStyle {
            switch self {
            case .inside:    return .inside
            case .center:    return .center
            case .outside:   return .outside
            case .unlimited: return .unlimited
            }
        }
    }

    // MARK: - Views

    private let degreeLabel = UILabel()
    private let radianLabel = UILabel()
    private let rangeLabel = UILabel()
    private let thumbSizeMultiplierLabel = UILabel()
    private let thumbSizeMultiplierSlider = UISlider()
    private let joystickView = JCJoystickView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.joystickView.delegate = self
        self.setupLayout()
        self.apply(state: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateThumbDiameter()
    }
    
    // MARK: - Layout

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [
            self.log,
            self.makeDivider(),
            self.joystick,
            self.makeDivider(),
            self.controls,
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(stack)

        let guide = self.view.safeAreaLayoutGuide
        // Spacer 효과: 하단은 고정하지 않아 콘텐츠가 위로 정렬된다.
        [stack.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
         stack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
         stack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
         stack.bottomAnchor.constraint(lessThanOrEqualTo: guide.bottomAnchor, constant: -16)].forEach { $0.isActive = true }
    }

    // MARK: - Log

    private var log: UIView {
        [self.degreeLabel, self.radianLabel, self.rangeLabel].forEach { $0.numberOfLines = 1 }

        let stack = UIStackView(arrangedSubviews: [self.degreeLabel, self.radianLabel, self.rangeLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }

    // MARK: - Joystick

    private var joystick: UIView {
        let container = UIView()

        self.joystickView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self.joystickView)

        // SwiftUI `.padding(60)` 재현: 모든 변으로 60 인셋 → container 는 정사각.
        [self.joystickView.topAnchor.constraint(equalTo: container.topAnchor, constant: 60),
         self.joystickView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -60),
         self.joystickView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 60),
         self.joystickView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -60),
         self.joystickView.widthAnchor.constraint(equalTo: self.joystickView.heightAnchor)].forEach { $0.isActive = true }

        let markingOffset: CGFloat = 24
        let top = self.makeMarking(isVertical: true)
        let bottom = self.makeMarking(isVertical: true)
        let leading = self.makeMarking(isVertical: false)
        let trailing = self.makeMarking(isVertical: false)
        [top, bottom, leading, trailing].forEach { container.addSubview($0) }

        [top.centerXAnchor.constraint(equalTo: self.joystickView.centerXAnchor),
         top.centerYAnchor.constraint(equalTo: self.joystickView.topAnchor, constant: -markingOffset),
         bottom.centerXAnchor.constraint(equalTo: self.joystickView.centerXAnchor),
         bottom.centerYAnchor.constraint(equalTo: self.joystickView.bottomAnchor, constant: markingOffset),
         leading.centerYAnchor.constraint(equalTo: self.joystickView.centerYAnchor),
         leading.centerXAnchor.constraint(equalTo: self.joystickView.leadingAnchor, constant: -markingOffset),
         trailing.centerYAnchor.constraint(equalTo: self.joystickView.centerYAnchor),
         trailing.centerXAnchor.constraint(equalTo: self.joystickView.trailingAnchor, constant: markingOffset)].forEach { $0.isActive = true }

        return container
    }

    private func makeMarking(isVertical: Bool) -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false

        [view.widthAnchor.constraint(equalToConstant: isVertical ? 6 : 16),
         view.heightAnchor.constraint(equalToConstant: isVertical ? 16 : 6)].forEach { $0.isActive = true }
        return view
    }

    // MARK: - Controls

    private var controls: UIView {
        let limitControl = UISegmentedControl(items: LimitStyleOption.allCases.map(\.rawValue))
        limitControl.selectedSegmentIndex = 0
        limitControl.addTarget(self, action: #selector(self.selectedThumbLimitStyle(_:)), for: .valueChanged)
        let limitSection = self.makeSection(title: "thumbLimitStyle", control: limitControl)

        self.thumbSizeMultiplierSlider.minimumValue = 0.1
        self.thumbSizeMultiplierSlider.maximumValue = 0.9
        self.thumbSizeMultiplierSlider.value = 0.25
        self.thumbSizeMultiplierSlider.addTarget(self, action: #selector(self.changeThumbSizeMultiplier(_:)), for: .valueChanged)
        self.updateThumbSizeMultiplierLabel()
        let sizeSection = self.makeSection(title: self.thumbSizeMultiplierLabel, control: self.thumbSizeMultiplierSlider)

        let stack = UIStackView(arrangedSubviews: [limitSection, sizeSection])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        return stack
    }

    private func makeSection(title: String, control: UIView) -> UIView {
        let label = UILabel()
        label.text = title
        return self.makeSection(title: label, control: control)
    }

    private func makeSection(title: UILabel, control: UIView) -> UIView {
        let stack = UIStackView(arrangedSubviews: [title, control])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        return stack
    }

    private func makeDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }

    // MARK: - Update

    private func updateThumbDiameter() {
        let side = min(self.joystickView.bounds.width, self.joystickView.bounds.height)
        self.joystickView.thumbDiameter = side * CGFloat(self.thumbSizeMultiplierSlider.value)
    }

    private func updateThumbSizeMultiplierLabel() {
        self.thumbSizeMultiplierLabel.text = "thumbSizeMultiplier: \(CGFloat(self.thumbSizeMultiplierSlider.value))"
    }

    private func apply(state: JCJoystickState?) {
        self.degreeLabel.text = "degree: \(state?.degree ?? 0)"
        self.radianLabel.text = "radian: \(state?.radian ?? 0)"
        self.rangeLabel.text = "range: \(state?.distanceRatio ?? 0)"
    }

    // MARK: - Actions

    @objc private func selectedThumbLimitStyle(_ sender: UISegmentedControl) {
        let option = LimitStyleOption.allCases[sender.selectedSegmentIndex]
        self.joystickView.thumbLimitStyle = option.style
    }

    @objc private func changeThumbSizeMultiplier(_ sender: UISlider) {
        self.updateThumbSizeMultiplierLabel()
        self.updateThumbDiameter()
    }
}

extension JoystickSampleViewController: JCJoystickViewDelegate {
    func joystickView(joystickView: JCJoystickView, shouldDrag state: JCJoystickState) -> Bool {
        print("\(#function) -> \(state)")
        return true
    }

    func joystickView(joystickView: JCJoystickView, beganDrag state: JCJoystickState) {
        print("\(#function) -> \(state)")
    }

    func joystickView(joystickView: JCJoystickView, didDrag state: JCJoystickState) {
        print("\(#function) -> \(state)")
        self.apply(state: state)
    }

    func joystickView(joystickView: JCJoystickView, didEndDrag state: JCJoystickState) {
        print("\(#function) -> \(state)")
        self.apply(state: state)
    }
}
