//
//  JCJoystick.swift
//  JCJoystick
//
//  Created by yjc on 7/4/26.
//

import SwiftUI

/// SwiftUI 네이티브 조이스틱 뷰.
///
/// 계산 로직은 UIKit `JCJoystickView` 와 동일한 Core(`JCJoystickCalculator`)를 재사용한다.
/// boundary/thumb 외형은 `@ViewBuilder` 로 자유롭게 커스터마이즈할 수 있고,
/// 기본 외형만 필요하면 파라미터 없이 생성할 수 있다.
///
/// ```swift
/// JCJoystick(thumbLimitStyle: .inside) { state in
///     print(state.degree, state.distanceRatio)
/// }
/// ```
public struct JCJoystick<Boundary: View, Thumb: View>: View {

    private let thumbLimitStyle: JCThumbLimitStyle
    private let boundary: Boundary
    private let thumb: Thumb
    private let thumbDiameter: CGFloat
    private let onChanged: ((JCJoystickState) -> Void)?
    private let onEnd: ((JCJoystickState) -> Void)?

    /// thumb 의 현재 중심. `nil` 이면 boundary 중앙(드래그 안 하는 기본 상태).
    @State private var thumbCenter: CGPoint?

    /// 완전 커스텀 외형 이니셜라이저.
    public init(
        thumbLimitStyle: JCThumbLimitStyle = .inside,
        thumbDiameter: CGFloat,
        @ViewBuilder boundary: () -> Boundary,
        @ViewBuilder thumb: () -> Thumb,
        onChanged: ((JCJoystickState) -> Void)? = nil,
        onEnd: ((JCJoystickState) -> Void)? = nil
    ) {
        self.thumbLimitStyle = thumbLimitStyle
        self.thumbDiameter = thumbDiameter
        self.boundary = boundary()
        self.thumb = thumb()
        self.onChanged = onChanged
        self.onEnd = onEnd
    }

    public var body: some View {
        GeometryReader { geometry in
            let side = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: side / 2, y: side / 2)

            ZStack {
                boundary
                    .frame(width: side, height: side)

                thumb
                    .frame(width: thumbDiameter, height: thumbDiameter)
                    .position(thumbCenter ?? center)
            }
            .frame(width: side, height: side)
            .contentShape(Rectangle())
            .gesture(dragGesture(side: side, center: center))
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func dragGesture(side: CGFloat, center: CGPoint) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let state = calculate(location: value.location, side: side, thumbDiameter: thumbDiameter)
                thumbCenter = state.location
                onChanged?(state)
                
            }
            .onEnded { _ in
                let state = calculate(location: center, side: side, thumbDiameter: thumbDiameter)
                thumbCenter = nil
                onEnd?(state)
            }
    }

    private func calculate(location: CGPoint, side: CGFloat, thumbDiameter: CGFloat) -> JCJoystickState {
        JCJoystickCalculator(
            boundary: .init(width: side, height: side),
            thumbDiameter: thumbDiameter,
            thumbLimitStyle: thumbLimitStyle
        ).calculate(location: location)
    }
}


#if DEBUG
struct JCJoystick_Previews: PreviewProvider {
    static var previews: some View {
        JCJoystick(
            thumbDiameter: 40,
            boundary: { Circle().stroke(lineWidth: 8) },
            thumb: { Circle().stroke(lineWidth: 8) }
        )
        .frame(width: 240, height: 240)
        .padding()
    }
}
#endif
