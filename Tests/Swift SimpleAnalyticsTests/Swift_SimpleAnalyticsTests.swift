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
    
    func testEventWithPath() async throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        await tracker.trackEvent(event: "test", path: "/testpath1/testpath2")
    }
    
    func testInvalidHostname() throws {
        let tracker = SimpleAnalytics(hostname: "piet.henkklaas")
        tracker.track(event: "test")
    }
    
    func testPageviewArray() {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        tracker.track(path: ["test", "test2"])
    }
    
    func testPath() {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")

        let path = tracker.pathToString(path: ["path1", "path2"])
        XCTAssert(path == "/path1/path2")
        
        let emptyPath = tracker.pathToString(path: [])
        XCTAssert(emptyPath == "/")
        
        let invalidPath = tracker.pathToString(path: ["árhùs#$@"])
        XCTAssert(invalidPath == "/arhus")
    }
}
