# Rye

[![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Plaforms](https://img.shields.io/badge/platforms-iOS%20-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Rye/blob/master/LICENSE)
[![CircleCI](https://circleci.com/gh/nodes-ios/Rye.svg?style=shield)](https://circleci.com/gh/nodes-ios/Rye)

## Intro

Rye allows you to present non intrusive alerts to your users of both "Toast" and "Snack Bar" types.
You can choose to display the default Rye alert type or go fully custom and display your own `UIView`.

### Examples


| ![](ExampleImages/example1.png) | ![](ExampleImages/example2.png)  | ![](ExampleImages/example3.png)  |
|----------------|---|---|
|      <center>Custom Rye with Image</center>      |  <center>Custom Rye with Button</center>  |  <center>Default Rye</center> |

## 📝 Requirements

iOS 11.4
Swift 5

## 📦 Installation

### Carthage
~~~bash
github "nodes-ios/Rye"
~~~

### Cocoapods
~~~bash
pod 'nodes-ios/Rye'
~~~

## 💻 Usage

```swift
import Rye
```

### Display Default Rye

```swift

let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Message for the user"]

let rye = RyeViewController.init(alertType: .toast,
                                viewType: .standard(configuration: ryeConfiguration),
                                at: .bottom(inset: 16),
                                timeAlive: 2)
rye.show()

```

### Display Default Rye with Custom Configuration

```swift

let ryeConfiguration: RyeConfiguration = [
    Rye.Configuration.Key.text: "Error message for the user",
    Rye.Configuration.Key.backgroundColor: UIColor.red.withAlphaComponent(0.4),
    Rye.Configuration.Key.animationType: Rye.AnimationType.fadeInOut]
]

let rye = RyeViewController.init(alertType: .toast,
                                viewType: .standard(configuration: ryeConfiguration),
                                at: .bottom(inset: 16),
                                timeAlive: 2)
rye.show()

```

### Display Rye with a Custom `UIView`

```swift

let customRyeView = RyeView()

let rye = RyeViewController.init(alertType: .toast,
                                viewType: .custom(customRyeView),
                                at: .bottom(inset: 16),
                                timeAlive: 2)
rye.show()

```

### Alert Type

Rye allows you to define the alert type you want to display to your user. Possible alert types are:

- snackBar which is displayed at applications UIWindow level and allows interaction with the presented UIView
- toast which is displayed at applications alert UIWindow level and doesn't allows interaction with the presented UIView

###  Position

With Rye you can specify the position where the Rye view will be displayed on screen via the `position` parameter, which takes an associated value that allows you to specify the inset.
By default Rye will calculate the safe area insets for you, so be sure to specify only the extra desired inset.

If you decide to not provide a value for this parameter, you will be in charge of dismissing the Rye when you think it is appropriate.

### Time Used

When creating an instance of  `RyeViewController` you can choose to provide a value for  the `timeAlive` parameter during initialisation. The value provided will be the time in seconds the Rye view will be presented on screen to the user.

### Possible Rye Configurations

The following keys can be used in the configuration dictionary when presenting a default type Rye:

    .backgroundColor (must be a UIColor)
    .textColor (must be a UIColor)
    .textFont (must be a UIFont)
    .text (must be a String)
    .cornerRadius (must be a CGFloat)
    .animationType (must be a Rye.AnimationType)
    .animationDuration (must be a TimeInterval)

If configuration is set to nil, a default configuration will be used. Any options set, will override the default state.

## Example Project
To learn more, please refer to the example project contained in this repository.

## 👥 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Rye** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/Rye/blob/master/LICENSE) file for more info.
