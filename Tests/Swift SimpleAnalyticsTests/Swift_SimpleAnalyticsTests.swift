import XCTest
@testable import SwiftSimpleAnalytics

final class Swift_SimpleAnalyticsTests: XCTestCase {
    func testPageview() async throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        await tracker.trackPageView(path: "/test")
    }
    
    func testEvent() async throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        await tracker.trackEvent(event: "test")
    }
    
    func testInvalidHostname() throws {
        let tracker = SimpleAnalytics(hostname: "piet.henkklaas")
        tracker.track(event: "test")
    }
}
