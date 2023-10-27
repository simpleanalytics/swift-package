// The Swift Programming Language
// https://docs.swift.org/swift-book
import OpenAPIRuntime
import OpenAPIURLSession

public struct testAPI {
    public func testAPIConnection() {
        let client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport()
        )
    }
}

