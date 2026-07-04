// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "JCJoystick",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "JCJoystick",
            targets: ["JCJoystick"]
        )
    ],
    targets: [
        .target(
            name: "JCJoystick",
            path: "JCJoystick/Sources"
        ),
        .testTarget(
            name: "JCJoystickTests",
            dependencies: ["JCJoystick"],
            path: "JCJoystick/Tests"
        )
    ]
)
