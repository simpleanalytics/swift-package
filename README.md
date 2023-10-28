# SimpleAnalytics Swift
Swift package for SimpleAnalytics. Currently in development. This is an alpha version, everything might change.

## Installation
Use Xcode to add the package dependency.

## Usage
You'll need a SimpleAnalytics account to be able to use this package. Sign up for one via https://www.simpleanalytics.com/?referral=roel-van-der-kraan

Import the library:
```swift
import SwiftSimpleAnalytics
```

You will need to get the hostname of your SimpleAnalytics website to start an instance of SimpleAnalytics. Use an existing one or create a new one specificly for your app. It doesn't have to be an existing website. Make sure the hostname matches the domain name in SimpleAnalytics (without http:// or https://)
```swift
let simpleAnalytics = SimpleAnalytics(hostname: "yourapp.com")
```

You can create an instance where you need it, or you can make an extension and add a static instance.
```swift
import SwiftSimpleAnalytics

extension SimpleAnalytics {
    static let shared: SimpleAnalytics = SimpleAnalytics(hostname: "yourapp.com")
}
```

## Tracking
You can call the tracking functions from anywhere in your app. In SwiftUI, a good place to put the tracking code is in your views `.onAppear{}` modifier.
### Tracking Pageviews
Use pageviews to track screens in your app. Create your own path structure. 
```swift
SimpleAnalytics.shared.track(path: "/seatlist")
```

### Tracking Events
```swift
SimpleAnalytics.shared.track(event: "seatList/parse")
```
