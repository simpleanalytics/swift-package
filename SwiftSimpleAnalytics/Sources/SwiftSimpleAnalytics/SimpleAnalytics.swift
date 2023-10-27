//
//  SimpleAnalytics.swift
//  
//
//  Created by Roel van der Kraan on 27/10/2023.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import WebKit

public class SimpleAnalytics: NSObject {
    var hostname: String
    let client: Client
    let userAgent: String
    
    public init(hostname: String) {
        self.hostname = hostname
        self.client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport()
        )
        userAgent = "Mozilla/5.0 (iPad; CPU OS 13_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
    }
    
    public func track(view: String) async {
        do {
            let response = try await client.event(
                body: .json(.init(
                    _type: .pageview, hostname: hostname, event: "pageview", ua: userAgent, path: view
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
    
    public func track(event: String) async {
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
