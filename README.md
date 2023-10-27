# SimpleAnalytics Swift
Swift package for SimpleAnalytics. Currently in development. This is an alpha version, everything might change.

## Installation
Use Xcode to add the package dependency.

## Usage
Import the library:
```swift
import SwiftSimpleAnalytics
```

You will need to get the hostname of your SimpleAnalytics website to start an instance of SimpleAnalytics. Make sure it matches the website name.
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

## Tracking Pageviews
Use pageviews to track screens in your app. Create your own path structure. 
```swift
SimpleAnalytics.shared.track(path: "/seatlist")
```

## Tracking Events
```swift
SimpleAnalytics.shared.track(event: "seatList/parse")
```
