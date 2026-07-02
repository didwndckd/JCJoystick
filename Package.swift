// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "JCJoystick",
    platforms: [
        .iOS(.v12)
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
        )
    ]
)
