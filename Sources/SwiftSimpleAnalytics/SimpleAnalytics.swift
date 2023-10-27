//
//  SimpleAnalytics.swift
//  
//
//  Created by Roel van der Kraan on 27/10/2023.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

public class SimpleAnalytics: NSObject {
    var hostname: String
    let client: Client
    let userAgent: String
    
    // Defines if the user is opted out. When set to true, 
    public var isOptedOut: Bool = false
    
    /// Create the SimpleAnalytics instance that can be used to trigger events and pageviews.
    /// - Parameter hostname: The hostname as found in SimpleAnalytics
    public init(hostname: String) {
        self.hostname = hostname
        self.client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport()
        )
        userAgent = "Mozilla/5.0 (iPad; CPU OS 13_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
    }
    
    /// Track a pageview
    /// - Parameter view: The path of the page. Make sure it starts with a "/"
    public func track(path: String) {
        Task {
            await self.trackPageView(path: path)
        }
    }
    
    /// Track an event
    /// - Parameter event: The event name
    public func track(event: String) {
        Task {
            await self.trackEvent(event: event)
        }
    }
    
    private func trackPageView(path: String) async {
        guard !isOptedOut else {
            return
        }
        do {
            let response = try await client.event(
                body: .json(.init(
                    _type: .pageview, hostname: hostname, event: "pageview", ua: userAgent, path: path
                )))
            debugPrint(response)
            switch response {
            case .created(_):
                debugPrint("Track success")
            default:
                debugPrint("Error tracking pageview")
                
            }
        } catch {
            debugPrint("Error tracking pageview")
        }
    }
    
    private func trackEvent(event: String) async {
        guard !isOptedOut else {
            return
        }
        do {
            let response = try await client.event(
                body: .json(.init(
                    _type: .event, hostname: hostname, event: event, ua: userAgent
                )))
            debugPrint(response)
            switch response {
            case .created(_):
                debugPrint("Track success")
            default:
                debugPrint("Error tracking pageview")
                
            }
        } catch {
            debugPrint("Error tracking pageview")
        }
    }
}
