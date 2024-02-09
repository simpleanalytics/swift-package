//
//  SimpleAnalytics.swift
//  
//
//  Created by Roel van der Kraan on 27/10/2023.
//

import Foundation

/// SimpleAnalytics allows you to send events and pageviews from Swift  to Simple Analytics
///
/// - Important: Make sure the hostname matches the website domain name in Simple Analytics (without `http://` or `https://`).
///
/// ````
/// let simpleAnalytics = SimpleAnalytics(hostname: "mobileapp.yourdomain.com")
/// ````
/// You can create an instance where you need it, or you can make an extension and use it as a static class.
/// ````
/// import SimpleAnalytics
///
/// extension SimpleAnalytics {
///    static let shared: SimpleAnalytics = SimpleAnalytics(hostname: "mobileapp.yourdomain.com")
/// }
/// ````
final public class SimpleAnalytics: NSObject {
    /// The hostname of the website in Simple Analytics the tracking should be send to. Without `https://`
    private let hostname: String
    private let userAgent: String
    private let userLanguage: String
    private let userTimezone: String
    /// The last date a unique visit was tracked.
    private var visitDate: Date?
    
    /// Defines if the user is opted out. When set to `true`, all tracking will be skipped. This is persisted between sessions.
    public var isOptedOut: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.optedOutKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.optedOutKey)
        }
    }
    
    /// Create the SimpleAnalytics instance that can be used to trigger events and pageviews.
    /// - Parameter hostname: The hostname as found in SimpleAnalytics, without `https://`
    public init(hostname: String) {
        self.hostname = hostname
        self.userAgent = UserAgent.userAgentString()
        self.userLanguage = Locale.current.identifier
        self.userTimezone = TimeZone.current.identifier
        self.visitDate = UserDefaults.standard.object(forKey: Keys.visitDateKey) as? Date
    }
    
    /// Track a pageview
    /// - Parameter path: The path of the page as string array, for example: `["list", "detailview", "edit"]`
    public func track(path: [String]) {
        self.trackPageView(path: pathToString(path: path))
    }
    
    /// Track an event
    /// - Parameter event: The event name
    /// - Parameter path: optional path array where the event took place, for example: `["list", "detailview", "edit"]`
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
        
        RequestDispatcher.sendEventRequest(event: event)
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
        RequestDispatcher.sendEventRequest(event: event)
    }
    
    /// Converts an array of strings to a slug structure
    /// - Parameter path: The array of paths, for example `["list", "detailview"]`.
    /// - Returns: a slug of the path, for the example `"/list/detailview"`
    internal func pathToString(path: [String]) -> String {
        var safePath: [String] = []
        for pathItem in path {
            if let slug = pathItem.convertedToSlug() {
                safePath.append(slug)
            }
        }
        return "/\(safePath.joined(separator: "/"))"
    }
    
    /// Simple Analytics uses the `isUnique` flag to determine visitors from pageviews. The first event/pageview for the day
    /// should get this `isUnique` flag.
    /// - Returns: if this is a unique first visit for today
    internal func isUnique() -> Bool {
        if let visitDate = self.visitDate {
            if Calendar.current.isDateInToday(visitDate) {
                // Last visit tracked is in today, so not unique
                return false
            } else {
                // Last visit is not in today, so unique.
                self.visitDate = Date()
                UserDefaults.standard.set(self.visitDate, forKey: Keys.visitDateKey)
                return true
            }
        } else {
            // No visit date yet, initialize it
            visitDate = Date()
            UserDefaults.standard.set(visitDate, forKey: Keys.visitDateKey)
            return true
        }
    }
    
    /// Keys used to store things in UserDefaults
    internal struct Keys {
        static let visitDateKey = "simpleanalytics.visitdate"
        static let optedOutKey = "simpleanalytics.isoptedout"
    }
}
