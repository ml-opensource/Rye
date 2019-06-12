# Rye

[![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Plaforms](https://img.shields.io/badge/platforms-iOS%20-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Rye/blob/master/LICENSE)
[![CircleCI](https://circleci.com/gh/nodes-ios/Rye.svg?style=shield)](https://circleci.com/gh/nodes-ios/Rye)

## Intro


## 📝 Requirements
iOS 12
Swift 5

## 📦 Installation

### Carthage
~~~bash
github "nodes-ios/Rye"
~~~

## 💻 Usage

```swift 
import Rye
```

### Display Default Rye

```swift 

let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Message for the user"]

DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
let rye = RyeViewController.init(type: .`default`(configuration: ryeConfiguration), timeAlive: 2)
    rye.show()
}

```

### Display Default Rye with Custom Configuration

```swift 

let ryeConfiguration: RyeConfiguration = [
    Rye.Configuration.Key.text: "Error message for the user",
    Rye.Configuration.Key.backgroundColor: UIColor.red.withAlphaComponent(0.4)
]

DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    let rye = RyeViewController.init(type: .`default`(configuration: ryeConfiguration), timeAlive: 2)
    rye.show()
}

```

### Display Rye with a Custom `UIView`

```swift 

let customRyeView = RyeView()

DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    let rye = RyeViewController.init(type: .custom(customRyeView), timeAlive: 2)
    rye.show()
}

```

### Time Used 

When creating an instance of  `RyeViewController` you can choose to provide a value for  the `timeAlive` parameter during initialisation. The value provided will be the time in seconds the Rye view will be presented on screen to the user. 

If you decide to not provide a value for this parameter, you will be in charge of dismissing the Rye when you think it is appropriate.

### Possible Rye Configurations

The following keys can be used in the configuration dictionary when preseting a default type Rye:

    .backgroundColor (must be a UIColor)
    .textColor (must be a UIColor)
    .textFont (must be a UIFont)
    .text (must be a String)
    .cornerRadius (must be a CGFloat)

If configuration is set to nil, default configuration will be used. Any options set, will override the default state.

## Example Project
To learn more, please refer to the example project contained in this repository.

## 👥 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Rye** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/Rye/blob/master/LICENSE) file for more info.
