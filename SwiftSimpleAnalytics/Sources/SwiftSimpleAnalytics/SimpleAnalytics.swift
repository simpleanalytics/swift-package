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
    
    public init(hostname: String) {
        self.hostname = hostname
        self.client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport()
        )
    }
    
    public func track(view: String) async {
        do {
            let response = try await client.event(
                body: .json(.init(
                    _type: .pageview, hostname: hostname, event: "pageview", ua: "SwiftSimpleAnalytics", path: "view"
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
                    _type: .event, hostname: hostname, event: event, ua: "SwiftSimpleAnalytics"
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
