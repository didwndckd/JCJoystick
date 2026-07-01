# JCJoystick

[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Example

To run the example project, clone the repo and open `Example/JCJoystick.xcodeproj`.

## Requirements

- iOS 12.0+
- Swift 5.0+

## Installation

### Swift Package Manager

Add JCJoystick to the `dependencies` in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/didwndckd/JCJoystick.git", from: "1.0.3")
]
```

Or in Xcode, go to **File > Add Packages...** and enter the repository URL:

```
https://github.com/didwndckd/JCJoystick.git
```

## Usage

### Basic

``` swift
let joystickView = JCJoystickView()
joystickView.delegate = self
```

![basic](./assets/JCJoystick_basic.gif)

### Delegate

``` swift
public protocol JCJoystickViewDelegate: AnyObject {
    func joystickView(joystickView: JCJoystickView, shouldDrag value: JCJoystickValue) -> Bool
    func joystickView(joystickView: JCJoystickView, beganDrag value: JCJoystickValue)
    func joystickView(joystickView: JCJoystickView, didDrag value: JCJoystickValue)
    func joystickView(joystickView: JCJoystickView, didEndDrag value: JCJoystickValue)
}
```

### Options

- image

  ``` swift
  let joystickView = JCJoystickView()
  joystickView.boundaryImage = <yourImage>
  joystickView.thumbImage = <yourImage>
  ```

- angleValueType

  ``` swift
  let joystickView = JCJoystickView()
  joystickView.angleValueType = .degree
  // or
  joystickView.angleValueType = .radian
  ```

  ![angleType](./assets/JCJoystick_angleType.gif)

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

  ![thumbLimitStyle](./assets/JCJoystick_thumbLimitStyle.gif)

- thumbSizeMultiplier

  ``` swift
  let joystickView = JCJoystickView()
  joystickView.thumbSizeMultiplier = 0.25
  ```
  
  ![thumbSizeMultiplier](./assets/JCJoystick_thumbSizeMultiplier.gif)

## Author

JoongChangYang, didwndckd@gmail.com

## License

JCJoystick is available under the MIT license. See the LICENSE file for more info.
