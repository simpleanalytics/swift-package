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
    private let hostname: String
    private let client: Client
    private let userAgent: String
    private let userLanguage: String
    private let userTimezone: String
    
    // Defines if the user is opted out. When set to true, all tracking will be skipped. This is not persisted between sessions.
    public var isOptedOut: Bool = false
    
    /// Create the SimpleAnalytics instance that can be used to trigger events and pageviews.
    /// - Parameter hostname: The hostname as found in SimpleAnalytics
    public init(hostname: String) {
        self.hostname = hostname
        self.client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport()
        )
        self.userAgent = UserAgent.userAgentString()
        self.userLanguage = Locale.current.identifier
        self.userTimezone = TimeZone.current.identifier
        debugPrint(userAgent)
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
    
    internal func trackPageView(path: String) async {
        guard !isOptedOut else {
            return
        }
        do {
            let response = try await client.event(
                body: .json(.init(
                    _type: .pageview, hostname: hostname, event: "pageview", ua: userAgent, path: path, language: userLanguage, timezone: userTimezone
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
    
    internal func trackEvent(event: String) async {
        guard !isOptedOut else {
            return
        }
        do {
            let response = try await client.event(
                body: .json(.init(
                    _type: .event, hostname: hostname, event: event, ua: userAgent, language: userLanguage, timezone: userTimezone
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
