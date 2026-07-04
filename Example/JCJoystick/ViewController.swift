//
//  ViewController.swift
//  JCJoystick
//
//  Created by JoongChangYang on 04/14/2022.
//  Copyright (c) 2022 JoongChangYang. All rights reserved.
//

import UIKit
import JCJoystick

final class ViewController: UIViewController {

    private enum AngleType {
        case degree
        case radian
    }

    @IBOutlet private weak var angleLabel: UILabel!
    @IBOutlet private weak var rangeLabel: UILabel!
    @IBOutlet private weak var joystickView: JCJoystickView!
    @IBOutlet private weak var thumbDiameterMultiplierLabel: UILabel!

    private var angleType: AngleType = .degree

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    private func setupUI() {
        self.joystickView.delegate = self
        self.resetLog()
        
        let boundaryView = self.joystickView.boundaryView
        let topMarkingView = createMarkingView(isVertical: true)
        let bottomMarkingView = createMarkingView(isVertical: true)
        let leadingMarkingView = createMarkingView(isVertical: false)
        let trailingMarkingView = createMarkingView(isVertical: false)
        [topMarkingView, bottomMarkingView, leadingMarkingView, trailingMarkingView].forEach { boundaryView.insertSubview($0, at: 0) }
        
        [topMarkingView.centerXAnchor.constraint(equalTo: boundaryView.centerXAnchor),
         topMarkingView.bottomAnchor.constraint(equalTo: boundaryView.topAnchor, constant: -4),
         bottomMarkingView.centerXAnchor.constraint(equalTo: boundaryView.centerXAnchor),
         bottomMarkingView.topAnchor.constraint(equalTo: boundaryView.bottomAnchor, constant: 4),
         leadingMarkingView.centerYAnchor.constraint(equalTo: boundaryView.centerYAnchor),
         leadingMarkingView.trailingAnchor.constraint(equalTo: boundaryView.leadingAnchor, constant: -4),
         trailingMarkingView.centerYAnchor.constraint(equalTo: boundaryView.centerYAnchor),
         trailingMarkingView.leadingAnchor.constraint(equalTo: boundaryView.trailingAnchor, constant: 4)].forEach { $0.isActive = true }
    }
    
    private func createMarkingView(isVertical: Bool) -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 3
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if isVertical {
            view.widthAnchor.constraint(equalToConstant: 6).isActive = true
            view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        } else {
            view.widthAnchor.constraint(equalToConstant: 16).isActive = true
            view.heightAnchor.constraint(equalToConstant: 6).isActive = true
        }
        
        return view
    }

    private func log(state: JCJoystickState) {
        switch self.angleType {
        case .degree:
            self.angleLabel.text = "degree: \(state.degree)"
        case .radian:
            self.angleLabel.text = "radian: \(state.radian)"
        }

        self.rangeLabel.text = "range: \(state.distanceRatio)"
    }

    private func resetLog() {
        switch self.angleType {
        case .degree:
            self.angleLabel.text = "degree: 0.0"
        case .radian:
            self.angleLabel.text = "radian: 0.0"
        }

        self.rangeLabel.text = "range: 0.0"
    }

    @IBAction private func selectedAngleType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.angleType = .degree
        case 1:
            self.angleType = .radian
        default:
            break
        }
        self.resetLog()
    }
    
    
    @IBAction private func selectedThumbLimitStyle(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.joystickView.thumbLimitStyle = .inside
        case 1:
            self.joystickView.thumbLimitStyle = .center
        case 2:
            self.joystickView.thumbLimitStyle = .outside
        case 3:
            self.joystickView.thumbLimitStyle = .unlimited
        default:
            break
        }
    }
    
    @IBAction private func changeValueThumbSizeMultiplier(_ sender: UISlider) {
        let value = sender.value
        self.thumbDiameterMultiplierLabel.text = "thumbSizeMultiplier: \(value)"
        self.joystickView.thumbSizeMultiplier = CGFloat(value)
    }
    
}

extension ViewController: JCJoystickViewDelegate {
    func joystickView(joystickView: JCJoystickView, shouldDrag state: JCJoystickState) -> Bool {
        print("\(#function) -> \(state)")
        return true
    }

    func joystickView(joystickView: JCJoystickView, beganDrag state: JCJoystickState) {
        print("\(#function) -> \(state)")
    }

    func joystickView(joystickView: JCJoystickView, didDrag state: JCJoystickState) {
        print("\(#function) -> \(state)")
        self.log(state: state)
    }

    func joystickView(joystickView: JCJoystickView, didEndDrag state: JCJoystickState) {
        print("\(#function) -> \(state)")
    }

}
