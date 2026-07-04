//
//  JoystickSampleView.swift
//  JCJoystick
//
//  Created by yjc on 7/4/26.
//

import SwiftUI
import JCJoystick

/// 라이브러리의 SwiftUI 네이티브 `JCJoystick` 을 사용하는 샘플 화면.
/// 기존 UIKit 샘플(`ViewController`)과 동일한 구성을 SwiftUI 로 재현한다.
struct JoystickSampleView: View {

    private enum LimitStyleOption: String, CaseIterable, Identifiable {
        case inside
        case center
        case outside
        case unlimited

        var id: String { rawValue }

        var style: JCThumbLimitStyle {
            switch self {
            case .inside:    return .inside
            case .center:    return .center
            case .outside:   return .outside
            case .unlimited: return .unlimited
            }
        }
    }

    private let joystickSize: CGFloat = 250

    @State private var limitOption: LimitStyleOption = .inside
    @State private var thumbDiameter: CGFloat = 50
    @State private var degree: CGFloat = 0
    @State private var radian: CGFloat = 0
    @State private var range: CGFloat = 0

    var body: some View {
        VStack(spacing: 16) {
            log

            Divider()

            joystick

            Divider()

            controls

            Spacer()
        }
        .padding()
    }

    // MARK: - Log

    private var log: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("degree: \(degree)")
            Text("radian: \(radian)")
            Text("range: \(range)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Joystick

    private var joystick: some View {
        let markingOffset: CGFloat = 24

        return JCJoystick(
            thumbLimitStyle: limitOption.style,
            thumbDiameter: thumbDiameter,
            boundary: { Circle().strokeBorder(Color(.darkGray), lineWidth: 8) },
            thumb: { Circle().strokeBorder(Color.gray, lineWidth: 8) },
            onChanged: onChanged(state:),
            onEnd: onEnd(state:)
        )
        .frame(width: joystickSize, height: joystickSize)
        .overlay(alignment: .top) { marking(isVertical: true).offset(y: -markingOffset) }
        .overlay(alignment: .bottom) { marking(isVertical: true).offset(y: markingOffset) }
        .overlay(alignment: .leading) { marking(isVertical: false).offset(x: -markingOffset) }
        .overlay(alignment: .trailing) { marking(isVertical: false).offset(x: markingOffset) }
        .padding(.vertical, markingOffset)
    }

    private func marking(isVertical: Bool) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.black)
            .frame(width: isVertical ? 6 : 16, height: isVertical ? 16 : 6)
    }

    // MARK: - Controls

    private var controls: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("thumbLimitStyle")
                Picker("thumbLimitStyle", selection: $limitOption) {
                    ForEach(LimitStyleOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("thumbDiameter: \(thumbDiameter)")
                Slider(value: $thumbDiameter, in: 1...250)
            }
        }
    }

    private func onChanged(state: JCJoystickState) {
        print("\(#function) -> \(state)")
        apply(state: state)
    }

    private func onEnd(state: JCJoystickState) {
        print("\(#function) -> \(state)")
        apply(state: state)
    }

    private func apply(state: JCJoystickState) {
        degree = state.degree
        radian = state.radian
        range = state.distanceRatio
    }
}

#if DEBUG
struct JoystickSampleView_Previews: PreviewProvider {
    static var previews: some View {
        JoystickSampleView()
    }
}
#endif
