# JCJoystick

[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

UIKit `JCJoystickView` 와 SwiftUI `JCJoystick` 을 함께 제공합니다.
두 구현은 동일한 계산 코어(`JCJoystickCalculator`)를 공유합니다.

## Example

To run the example project, clone the repo and open `Example/JCJoystick.xcodeproj`.

## Requirements

- iOS 15.0+
- Swift 5.9+

## Installation

### Swift Package Manager

Add JCJoystick to the `dependencies` in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/didwndckd/JCJoystick.git", from: "1.1.0")
]
```

Or in Xcode, go to **File > Add Packages...** and enter the repository URL:

```
https://github.com/didwndckd/JCJoystick.git
```

## Usage

### JCJoystickState

드래그 결과는 `JCJoystickState` 로 전달됩니다.

```swift
public struct JCJoystickState {
    public let location: CGPoint    // thumb 위치
    public let radius: CGFloat      // 이동 한계 반경 (unlimited 이면 boundary 반경)
    public let radian: CGFloat      // 각도(radian)
    public let distance: CGFloat    // 중심에서 location 까지의 거리

    public var degree: CGFloat        // 각도(degree)
    public var distanceRatio: CGFloat // 거리 비율 (0...1)
}
```

> 이전 버전의 `angleValueType` 설정은 사라졌습니다. `degree` 와 `radian` 을 `JCJoystickState` 에서 모두 바로 얻을 수 있습니다.

---

## UIKit

### Basic

``` swift
let joystickView = JCJoystickView()
joystickView.delegate = self
```

### Delegate

``` swift
public protocol JCJoystickViewDelegate: AnyObject {
    func joystickView(joystickView: JCJoystickView, shouldDrag state: JCJoystickState) -> Bool
    func joystickView(joystickView: JCJoystickView, beganDrag state: JCJoystickState)
    func joystickView(joystickView: JCJoystickView, didDrag state: JCJoystickState)
    func joystickView(joystickView: JCJoystickView, didEndDrag state: JCJoystickState)
}
```

> `shouldDrag` 는 기본 구현(`true`)이 제공되어 필요할 때만 오버라이드하면 됩니다.

### Options

- image

  ``` swift
  let joystickView = JCJoystickView()
  joystickView.boundaryImage = <yourImage>
  joystickView.thumbImage = <yourImage>
  ```

- thumbLimitStyle

  ``` swift
  let joystickView = JCJoystickView()
  joystickView.thumbLimitStyle = .inside
  //or
  joystickView.thumbLimitStyle = .center
  //or
  joystickView.thumbLimitStyle = .outside
  //or
  joystickView.thumbLimitStyle = .unlimited
  //or
  joystickView.thumbLimitStyle = .customWithConstant(constant: 20)
  //or
  joystickView.thumbLimitStyle = .customWithMultiplier(multiplier: 1.5)
  ```

- thumbDiameter

  thumb 의 지름(pt)을 직접 지정합니다. (이전의 `thumbSizeMultiplier` 를 대체합니다.)

  ``` swift
  let joystickView = JCJoystickView()
  joystickView.thumbDiameter = 50
  ```

---

## SwiftUI

`JCJoystick` 은 boundary/thumb 외형을 `@ViewBuilder` 로 자유롭게 구성할 수 있습니다.

``` swift
import SwiftUI
import JCJoystick

struct ContentView: View {
    var body: some View {
        JCJoystick(
            thumbLimitStyle: .inside,
            thumbDiameter: 50,
            boundary: { Circle().strokeBorder(Color(.darkGray), lineWidth: 8) },
            thumb: { Circle().strokeBorder(Color.gray, lineWidth: 8) },
            onChanged: { state in
                print(state.degree, state.distanceRatio)
            },
            onEnd: { state in
                print(state.degree, state.distanceRatio)
            }
        )
        .frame(width: 250, height: 250)
    }
}
```

- `thumbLimitStyle`: UIKit 과 동일한 `JCThumbLimitStyle`.
- `thumbDiameter`: thumb 의 지름(pt).
- `boundary` / `thumb`: 외형을 그리는 `@ViewBuilder`.
- `onChanged` / `onEnd`: 드래그 중 / 종료 시 `JCJoystickState` 콜백.

## Author

JoongChangYang, didwndckd@gmail.com

## License

JCJoystick is available under the MIT license. See the LICENSE file for more info.
