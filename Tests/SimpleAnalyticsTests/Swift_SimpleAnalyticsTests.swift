import XCTest
@testable import SimpleAnalytics

final class Swift_SimpleAnalyticsTests: XCTestCase {
    func testPageview() throws {
        let expectation = XCTestExpectation(description: "Log a pageview")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        tracker.trackPageView(path: "/test")
        wait(for: [expectation], timeout: 10.0)

    }
    
    func testEvent() throws {
        let expectation = XCTestExpectation(description: "Log a pageview")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        tracker.trackEvent(event: "test")
        wait(for: [expectation], timeout: 10.0)

    }
    
    func testEventWithPath() throws {
        let expectation = XCTestExpectation(description: "Log an event")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        tracker.trackEvent(event: "test", path: "/testpath1/testpath2")
        wait(for: [expectation], timeout: 10.0)
        

    }
    
    func testInvalidHostname() throws {
        let expectation = XCTestExpectation(description: "Log a pageview")

        let tracker = SimpleAnalytics(hostname: "piet.henkklaas")
        tracker.track(event: "test")
        wait(for: [expectation], timeout: 10.0)

    }
    
    func testPageviewArray() {
        let expectation = XCTestExpectation(description: "Log an event")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        tracker.track(path: ["test", "test2"])
        wait(for: [expectation], timeout: 10.0)

    }
    
    func testPageviewWithDefaultsGroup() throws {
        let expectation = XCTestExpectation(description: "Log a pageview")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app", sharedDefaultsSuiteName: "app.yourapp.com")
        tracker.trackPageView(path: "/test")
        wait(for: [expectation], timeout: 10.0)

    }
    
    func testEventWithDefaultsGroup() throws {
        let expectation = XCTestExpectation(description: "Log a pageview")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app", sharedDefaultsSuiteName: "app.yourapp.com")
        tracker.trackEvent(event: "test")
        wait(for: [expectation], timeout: 10.0)

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
