import XCTest
@testable import SimpleAnalytics

final class Swift_SimpleAnalyticsTests: XCTestCase {
    func testPageview() async throws {
        let expectation = XCTestExpectation(description: "Log a pageview")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        await tracker.trackPageView(path: "/test")
        print("Completed without throwing an error, assumed successful.")

    }
    
    func testEvent() async throws {
        let expectation = XCTestExpectation(description: "Log a pageview")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        await tracker.trackEvent(event: "test")
        print("Completed without throwing an error, assumed successful.")

    }
    
    func testEventWithPath() async throws {
        let expectation = XCTestExpectation(description: "Log an event")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        await tracker.trackEvent(event: "test", path: "/testpath1/testpath2")
        print("Completed without throwing an error, assumed successful.")

    }
    
    func testInvalidHostname() async throws {
        let expectation = XCTestExpectation(description: "Log a pageview")

        let tracker = SimpleAnalytics(hostname: "piet.henkklaas")
        await tracker.track(event: "test")
        print("Completed without throwing an error, assumed successful.")

    }
    
    func testPageviewArray() async {
        let expectation = XCTestExpectation(description: "Log an event")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        await tracker.track(path: ["test", "test2"])
        print("Completed without throwing an error, assumed successful.")

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
