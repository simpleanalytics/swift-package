# Simple Analytics Swift Package
Swift package for [Simple Analytics](https://www.simpleanalytics.com/?referral=roel-van-der-kraan). Currently in development. This is an alpha version, everything might change.

## Installation
Use Xcode to add the package dependency.

## Usage
You'll need a Simple Analytics account to be able to use this package. See [Simple Analytics](https://www.simpleanalytics.com/?referral=roel-van-der-kraan) for more info.

Import the library:
```swift
import SwiftSimpleAnalytics
```

You will need the hostname of a Simple Analytics website to start an instance of `SimpleAnalytics` in your app. You can add a fake "website" to Simple Analytics specifically for your app. There is no need to point to a real server. You can use something like `mobileapp.yourdomain.com`. Skip the HTML validation by clicking "I installed the script". 
⚠️ Make sure the hostname you set in Swift matches the website domain name in Simple Analytics (without http:// or https://).
```swift
let simpleAnalytics = SimpleAnalytics(hostname: "mobileapp.yourdomain.com")
```

You can create an instance where you need it, or you can make an extension and use it as a static class.
```swift
import SwiftSimpleAnalytics

extension SimpleAnalytics {
    static let shared: SimpleAnalytics = SimpleAnalytics(hostname: "mobileapp.yourdomain.com")
}
```

## Tracking
You can call the tracking functions from anywhere in your app.
### Tracking Pageviews
Use pageviews to track screens in your app.
```swift
SimpleAnalytics.shared.track(path: ["list"])
```
To represent a hierarchy in your views, add every level as an entry in the path array:
```swift
SimpleAnalytics.shared.track(path: ["detailview", "item1", "edit"])
```
This will be converted to a pageview on `/detailview/item1/edit` on Simple Analytics.

### Tracking Events
Use events to track interactions or noticable events like errors or success on a page.
```swift
SimpleAnalytics.shared.track(event: "logged in")
```
You can provide an optional path to track alongside the event.
```swift
SimpleAnalytics.shared.track(event: "logged in", path: ["login", "social"])
```

### SwiftUI example
 In SwiftUI, a good place to put the Pageview tracking code is in your view `.onAppear{}` modifier. 
```swift
import SwiftUI
import SwiftSimpleAnalytics

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            SimpleAnalytics.shared.track(path: ["example"])
        }
    }
}
```

### UIKit example
When using UIKit, you can put Pageview tracking in `viewDidAppear()`
```swift
import UIKit
import SwiftSimpleAnalytics

class ExampleViewController: UITableViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SimpleAnalytics.shared.track(path: ["example"])
    }
}
```
