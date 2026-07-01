# JCJoystick

[![License](https://img.shields.io/cocoapods/l/JCJoystick.svg?style=flat)](https://cocoapods.org/pods/JCJoystick)
[![Platform](https://img.shields.io/cocoapods/p/JCJoystick.svg?style=flat)](https://cocoapods.org/pods/JCJoystick)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

### CocoaPods

JCJoystick is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JCJoystick'
```

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
