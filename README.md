# Snapshooter

[![CI Status](http://img.shields.io/travis/Seiya Shimokawa/Snapshooter.svg?style=flat)](https://travis-ci.org/Seiya Shimokawa/Snapshooter)
[![Version](https://img.shields.io/cocoapods/v/Snapshooter.svg?style=flat)](http://cocoapods.org/pods/Snapshooter)
[![License](https://img.shields.io/cocoapods/l/Snapshooter.svg?style=flat)](http://cocoapods.org/pods/Snapshooter)
[![Platform](https://img.shields.io/cocoapods/p/Snapshooter.svg?style=flat)](http://cocoapods.org/pods/Snapshooter)

## Installation

Snapshooter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Snapshooter"
```

## Usage

Just invoke `[Snapshooter enableWithProperties:...]` from your AppDelegate’s `application:didFinishLaunchingWithOptions:` method. Also, implement `[Snapshooter supportedInterfaceOrientationsForWindow:...]` if your app allows landscape mode.

```obj-c
#import "Snapshooter.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Snapshooter enableWithProperties:@{}];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return [Snapshooter supportedInterfaceOrientationsForWindow:window];
}
```

## Author

Seiya Shimokawa, shimokawa.1987@gmail.com

## License

Snapshooter is available under the MIT license. See the LICENSE file for more info.
