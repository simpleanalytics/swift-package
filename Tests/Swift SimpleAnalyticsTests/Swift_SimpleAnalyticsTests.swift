import XCTest
@testable import SwiftSimpleAnalytics

final class Swift_SimpleAnalyticsTests: XCTestCase {
    func testPageview() async throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        await tracker.track(path: "/test")
    }
    
    func testEvent() async throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        await tracker.track(event: "test")
    }
    
    func testInvalidHostname() async throws {
        let tracker = SimpleAnalytics(hostname: "piet.henkklaas")
        await tracker.track(event: "test")
    }
}
