import XCTest
@testable import SwiftSimpleAnalytics

final class Swift_SimpleAnalyticsTests: XCTestCase {
    func testPageview() throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        tracker.track(path: "/test")
    }
    
    func testEvent() throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        tracker.track(event: "test")
    }
    
    func testInvalidHostname() throws {
        let tracker = SimpleAnalytics(hostname: "piet.henkklaas")
        tracker.track(event: "test")
    }
}
