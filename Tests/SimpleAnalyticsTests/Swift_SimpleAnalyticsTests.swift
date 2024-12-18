import XCTest
@testable import SimpleAnalytics

/// Tests for Swift SimpleAnalytics
/// You can see logged pageviews with these tests on this SimpleAnalytics page: https://dashboard.simpleanalytics.com/simpleanalyticsswift.app
final class Swift_SimpleAnalyticsTests: XCTestCase {
    
    func testTrackerSetup() throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        XCTAssert(tracker.hostname == "simpleanalyticsswift.app")
    }
    
    func testPageview() throws {
        let expectation = XCTestExpectation(description: "Test pageview")
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        Task {
            do {
                try await tracker.trackPageView(path: "/test")
                expectation.fulfill()
            } catch {
                XCTFail("Failed to log a pageview: \(error)")
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testPageviewWithMetadata() throws {
        let expectation = XCTestExpectation(description: "Log a pageview")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
         
        let metadataDictionary = ["plan": "premium", "meta": "data", "date": "2024-01-24T11:29:35.123Z", "number": 834710, "bool": true] as [String : Any]
        do {
            let metadataData = try JSONSerialization.data(withJSONObject: metadataDictionary, options: [])
            let metadataJsonString = String(data: metadataData, encoding: .utf8)!
            
            Task {
                do {
                    try await tracker.trackPageView(path: "/testmetadata", metadata: metadataJsonString)

                    expectation.fulfill()
                } catch {
                    XCTFail("Failed to log pageview with metadata: \(error)")
                }
            }
            wait(for: [expectation], timeout: 10.0)
        } catch {
            XCTFail("Failed to serialize metadata: \(error)")
        }
    }
    
    func testEvent() throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        let expectation = XCTestExpectation(description: "Log an event")

        Task {
            do {
                try await tracker.trackEvent(event: "test event")
                expectation.fulfill()
            }  catch {
                XCTFail("Failed to log event: \(error)")
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func testEventWithMetadata() throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        let expectation = XCTestExpectation(description: "Log an event with metadata")
        
        let metadataDictionary = ["plan": "premium", "meta": "data", "date": "2024-01-24T11:29:35.123Z", "number": 834710, "bool": true] as [String : Any]
        do {
            let metadataData = try JSONSerialization.data(withJSONObject: metadataDictionary, options: [])
            let metadataJsonString = String(data: metadataData, encoding: .utf8)!
            Task {
                do {
                    try await tracker.trackEvent(event: "test event metadata", metadata:  metadataJsonString)
                    expectation.fulfill()
                }  catch {
                    XCTFail("Failed to log event with metadata: \(error)")
                }
            }
            wait(for: [expectation], timeout: 10.0)
        } catch {
            XCTFail("Failed to serialize metadata: \(error)")
        }
    }
    
    func testEventWithPath() throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        let expectation = XCTestExpectation(description: "Log an event with path")

        Task {
            do {
                try await tracker.trackEvent(event: "test event path", path: "/testpath1/testpath2")
                expectation.fulfill()
            }  catch {
                XCTFail("Failed to log event with path: \(error)")
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func testEventWithPathAndMetadata() throws {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        let expectation = XCTestExpectation(description: "Log an event with path and metadata")
        
        let metadataDictionary = ["plan": "premium", "meta": "data"]
        do {
            let metadataData = try JSONSerialization.data(withJSONObject: metadataDictionary, options: [])
            let metadataJsonString = String(data: metadataData, encoding: .utf8)!
            
            Task {
                do {
                    try await tracker.trackEvent(event: "test event path metadata", path: "/testpath1/testpathmetadata", metadata: metadataJsonString)
                    expectation.fulfill()
                }  catch {
                    XCTFail("Failed to log event with path and metadata: \(error)")
                }
            }
            wait(for: [expectation], timeout: 10.0)
        } catch {
            XCTFail("Failed to serialize metadata: \(error)")
        }
    }
    
    
    func testInvalidHostname() throws {
        let tracker = SimpleAnalytics(hostname: "piet.henkklaas")
        tracker.track(event: "test")
    }
    
    func testPageviewArray() {
        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app")
        tracker.track(path: ["testpath", "testarray"])
    }
    
    func testEventWithDefaultsGroup() throws {
        let expectation = XCTestExpectation(description: "Log an event with userdefaults")

        let tracker = SimpleAnalytics(hostname: "simpleanalyticsswift.app", sharedDefaultsSuiteName: "app.yourapp.com")
        Task {
            do {
                try await tracker.trackEvent(event: "test user defaults")
                expectation.fulfill()
            }  catch {
                XCTFail("Failed to log event with user defaults: \(error)")
            }
        }
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
