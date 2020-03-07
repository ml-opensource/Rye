# 🍞 Rye

[![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Plaforms](https://img.shields.io/badge/platforms-iOS%20-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Rye/blob/master/LICENSE)
[![CircleCI](https://circleci.com/gh/nodes-ios/Rye.svg?style=shield)](https://circleci.com/gh/nodes-ios/Rye)

## Intro

Rye allows you to present non intrusive alerts to your users.

You can choose to display the default Rye alert type or go fully custom and display your own `UIView`.

### Examples


| ![](ExampleImages/example1.png) | ![](ExampleImages/example2.png)  | ![](ExampleImages/example3.png)  |
|----------------|---|---|
|      <center>Custom Rye alert with Image</center>      |  <center>Custom Rye alert with Button</center>  |  <center>Default Rye alert</center> |

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

### Principles

To display a Rye alert you declare a new `RyeViewController` and then call:

- `show`: to show the alert
- `dismiss`: to dismiss the alert

**note:** Depending on which `dismissMode` you have selected, you may not need to dismiss the alert yourself, see the section about `displayModes` below for more information.

At the very minimum you need to consider:

- which text to show
- whether to show a standard alert or bring your own custom view to the party
- where to show the text (`top` or `bottom`)

#### Show Text

To show a text using a Rye alert you need to create a `RyeConfiguration`. This is a dictionary allowing you to configure various UI related aspects of your Rye alert. For more information on available keys, please refer to the section: [Possible Rye Configuration Values](#possible-rye-configuration-values) below.

One of the values you can add to a `RyeConfiguration` - in fact the only value you _need_ to add - is a text to show in your alert.

```swift
let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Message for the user"]
```

#### Alert Type

You can use the default Rye alert or you can create your own view and use that instead. To determine which to use, you use the `Rye.ViewType` enum defined like so:

```swift
public enum ViewType {
    case standard(configuration: RyeConfiguration?)
    case custom(UIView, animationType: AnimationType = .slideInOut)
}
```

As you can see, the `standard` type takes a `RyeConfiguration` as a parameter and the `custom` type takes the view you would like to use and an `Rye.AnimationType` (with a default value already provided). For more on the `AnimationType` please refer to the section [Animation Type](#animation-type) below.

#### Where To Show the Alert?

Where to show a Rye alert is determined by a `Rye.Position` enum which is defined like so:

```swift
public enum Position {
    case top(inset: CGFloat)
    case bottom(inset: CGFloat)
}
```

For more on the `Rye.Position` please refer to the section [Position](#position) below.

### Display Default Rye

Following these principles we are now ready to show our first Rye alert.

```swift
import Rye
...
let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Message for the user"]
let rye = RyeViewController.init(viewType: .standard(configuration: ryeConfiguration),
                                 at: .bottom(inset: 16))
rye.show()
```

### Control the Dismiss Type

If you would like the Rye alert to disappear in a different way, you can pass a `dismissMode` parameter when creating the `RyeViewController`

```swift
import Rye
...
let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Message for the user"]
let rye = RyeViewController.init(dismissMode: .gesture,
                                 viewType: .standard(configuration: ryeConfiguration),
                                 at: .bottom(inset: 16))
rye.show()
```

The alert will now stay on the screen until the user taps or swipes at it.

### Display Default Rye with Custom Configuration

If you want to have more control of the alert view you can add keys and values to the `RyeConfiguration` as shown here.

```swift
import Rye
...
let ryeConfiguration: RyeConfiguration = [
    Rye.Configuration.Key.text: "Error message for the user",
    Rye.Configuration.Key.backgroundColor: UIColor.red.withAlphaComponent(0.4),
    Rye.Configuration.Key.animationType: Rye.AnimationType.fadeInOut]
]

let rye = RyeViewController.init(viewType: .standard(configuration: ryeConfiguration),
                                 at: .bottom(inset: 16))
rye.show()

```

### Display Rye with a Custom `UIView`

For even more control you can create your own subclass of `UIView` and use `.custom` for the `viewType` parameter

```swift
import Rye
...
let customRyeView = RyeView()

let rye = RyeViewController.init(viewType: .custom(customRyeView),
                                 at: .bottom(inset: 16))
rye.show()

```

### Dismiss Completion
If you would like to execute some code when the Rye alert is dismissed you can pass a `dismissCompletion` code block when calling `show` like so:

```swift
import Rye
...
let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Message for the user"]
let rye = RyeViewController.init(viewType: .standard(configuration: ryeConfiguration),
                                 at: .bottom(inset: 16))
rye.show(withDismissCompletion: {
    print("Goodbye from Rye, time to dy..die")  
})
```

### Dismiss Rye Alerts Manually

Keep a reference to the `RyeViewController` and call `dismiss` when you are ready to let go.

```swift
import Rye
...
var rye: RyeViewController?

let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Message for the user"]
rye = RyeViewController.init(dismissMode: .nonDismissable,
                                 viewType: .standard(configuration: ryeConfiguration),
                                 at: .bottom(inset: 16))
rye?.show()

...at a later point in time
rye?.dismiss()
```

### Descriptions of Parameters

#### Display Modes

Rye supports three different `displayMode` values which can be passed when creating a new `RyeViewController`:

- `automatic`: The alert appears and disappears automatically after a specified interval.
- `gesture`: To dismiss the alert you can tap or swipe it.
- `nonDismissable`: The alert will stay permanently on screen until it is dismissed by calling `dismiss()` on your `RyeViewController` instance.

If you do not pass this value when creating a new `RyeViewController`, a default value of `automatic` with a default interval of 2.5 seconds is used (the default interval is defined in `Rye.defaultDismissInterval`)

#### Position

With Rye you can specify the position where the Rye alert will be displayed on screen via the `position` parameter, which takes an associated value that allows you to specify the inset.

By default Rye will calculate the safe area insets for you, so be sure to specify only the extra desired inset.


#### Animation Type

Rye provides two animation types:

- slideInOut: slides the view in from either top or bottom (depending on which `Position` you have selected). When dismissed the view is slid out in the same direction.
- fadeInOut: fades the view in and out again when dismissed.

To control how long the animation will take when using a `.standard` view, please use the `animationDuration` key of the `RyeConfiguration` and provide a `TimeInterval` value.

In case you are using a `.custom` view or you _do not_ provide a value for `animationDuration`, a standard value of 0.3 seconds is used.

#### Possible Rye Configuration Values

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
