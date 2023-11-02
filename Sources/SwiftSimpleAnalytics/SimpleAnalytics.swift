//
//  SimpleAnalytics.swift
//  
//
//  Created by Roel van der Kraan on 27/10/2023.
//

import Foundation
import Alamofire

public class SimpleAnalytics: NSObject {
    private let hostname: String
    private let userAgent: String
    private let userLanguage: String
    private let userTimezone: String
    private var visitDate: Date?
    private var visitDateKey = "simpleanalytics.visitdate"
    
    // Defines if the user is opted out. When set to true, all tracking will be skipped. This is not persisted between sessions.
    public var isOptedOut: Bool = false
    
    /// Create the SimpleAnalytics instance that can be used to trigger events and pageviews.
    /// - Parameter hostname: The hostname as found in SimpleAnalytics
    public init(hostname: String) {
        self.hostname = hostname
        self.userAgent = UserAgent.userAgentString()
        self.userLanguage = Locale.current.identifier
        self.userTimezone = TimeZone.current.identifier
        self.visitDate = UserDefaults.standard.object(forKey: visitDateKey) as? Date
        debugPrint(userAgent)
    }
    
    /// Track a pageview
    /// - Parameter path: The path of the page.
    public func track(path: [String]) {
        self.trackPageView(path: pathToString(path: path))
    }
    
    /// Track an event
    /// - Parameter event: The event name
    /// - Parameter path: optional path where the event took place
    public func track(event: String, path: [String] = []) {
        self.trackEvent(event: event, path: pathToString(path: path))
    }
    
    internal func trackPageView(path: String) {
        guard !isOptedOut else {
            return
        }
        let event = Event(
            type: .pageview,
            hostname: hostname,
            event: "pageview",
            ua: userAgent,
            path: path,
            language: userLanguage,
            timezone: userTimezone,
            unique: isUnique()
        )
        
        sendEventRequest(event: event)
    }
    
    internal func trackEvent(event: String, path: String = "") {
        guard !isOptedOut else {
            return
        }
        let event = Event(
            type: .event,
            hostname: hostname,
            event: event,
            ua: userAgent,
            path: path,
            language: userLanguage,
            timezone: userTimezone,
            unique: isUnique()
        )
        sendEventRequest(event: event)
    }
    
    internal func sendEventRequest(event: Event) {
        AF.request("https://queue.simpleanalyticscdn.com/events",
                   method: .post,
                   parameters: event,
                   encoder: JSONParameterEncoder.default).responseData { response in
            
            debugPrint(response)
            if let httpStatusCode = response.response?.statusCode {
                switch httpStatusCode {
                case 201:
                    debugPrint("Simple Analytics: Event tracked")
                default:
                    debugPrint("Simple Analytics: Error while tracking Event to SimpleAnalytics, response code: \(httpStatusCode)")
                }
            }
        }
    }
    
    internal func pathToString(path: [String]) -> String {
        var safePath: [String] = []
        for pathItem in path {
            if let slug = pathItem.convertedToSlug() {
                safePath.append(slug)
            }
        }
        return "/\(safePath.joined(separator: "/"))"
    }
    
    /// Simple Analytics uses the isUnique flag to determine visitors from pageviews. The first event/pageview for the day
    /// should get this isUnique flag.
    /// - Returns: if this is a unique first visit for today
    internal func isUnique() -> Bool {
        if let visitDate = self.visitDate {
            if Calendar.current.isDateInToday(visitDate) {
                // Last visit tracked is in today, so not unique
                return false
            } else {
                // Last visit is not in today, so unique.
                self.visitDate = Date()
                UserDefaults.standard.set(visitDate, forKey: visitDateKey)
                return true
            }
        } else {
            visitDate = Date()
            UserDefaults.standard.set(visitDate, forKey: visitDateKey)
            return true
        }
    }
}
