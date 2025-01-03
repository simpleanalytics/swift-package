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
    let hostname: String
    private var userAgent: String?
    private let userLanguage: String
    private let userTimezone: String
    /// The last date a unique visit was tracked.
    private var visitDate: Date?
    private var sharedDefaultsSuiteName: String?
    
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
        self.userLanguage = Locale.current.identifier
        self.userTimezone = TimeZone.current.identifier
        self.visitDate = UserDefaults.standard.object(forKey: Keys.visitDateKey) as? Date
    }
    
    /// Create the SimpleAnalytics instance that can be used to trigger events and pageviews.
    /// - Parameter hostname: The hostname as found in SimpleAnalytics, without `https://`
    /// - Parameter: sharedDefaultsSuiteName: When extensions (such as a main app and widget) have a set of sharedDefaults (using an App Group) that unique user can be counted once using this (instead of two or more times when using app and widget, etc.)
    public init(hostname: String, sharedDefaultsSuiteName: String) {
        self.hostname = hostname
        self.userLanguage = Locale.current.identifier
        self.userTimezone = TimeZone.current.identifier
        self.sharedDefaultsSuiteName = sharedDefaultsSuiteName
        self.visitDate = UserDefaults(suiteName: sharedDefaultsSuiteName)?.object(forKey: Keys.visitDateKey) as? Date
    }
    
    /// Track a pageview
    /// - Parameter path: The path of the page as string array, for example: `["list", "detailview", "edit"]`
    /// - Parameter metadata: An optional dictionary of metadata to be sent with the pageview. `["plan": "premium", "referrer": "landing_page"]`
    public func track(path: [String], metadata: [String: Any]? = nil) {
        Task {
            do {
                try await self.trackPageView(path: pathToString(path: path), metadata: metadataToJsonString(metadata: metadata))
            } catch {
                debugPrint("SimpleAnalytics: Error tracking pageview: \(error.localizedDescription)")
            }
        }
    }
    
    /// Track an event
    /// - Parameter event: The event name
    /// - Parameter path: optional path array where the event took place, for example: `["list", "detailview", "edit"]`
    /// - Parameter metadata: An optional dictionary of metadata to be sent with the pageview. `["plan": "premium", "referrer": "landing_page"]`
    public func track(event: String, path: [String] = [], metadata: [String: Any]? = nil) {
        Task {
            do {
                try await self.trackEvent(event: event, path: pathToString(path: path), metadata: metadataToJsonString(metadata: metadata))
            } catch {
                debugPrint("SimpleAnalytics: Error tracking event: \(error.localizedDescription)")
            }
        }
    }
    
    internal func trackPageView(path: String, metadata: String? = nil) async throws {
        guard !isOptedOut else {
            return
        }
        let userAgent = try await getUserAgent()
        let event = Event(
            type: .pageview,
            hostname: hostname,
            event: "pageview",
            ua: userAgent,
            path: path,
            language: userLanguage,
            timezone: userTimezone,
            unique: isUnique(),
            metadata: metadata
        )
        
        try await RequestDispatcher.sendEventRequest(event: event)
    }
    
    internal func trackEvent(event: String, path: String = "", metadata: String? = nil) async throws {
        guard !isOptedOut else {
            return
        }
        let userAgent = try await getUserAgent()
        let event = Event(
            type: .event,
            hostname: hostname,
            event: event,
            ua: userAgent,
            path: path,
            language: userLanguage,
            timezone: userTimezone,
            unique: isUnique(),
            metadata: metadata
        )
        
        try await RequestDispatcher.sendEventRequest(event: event)
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
    
    /// Serializes metadata dictionary into a JSON string.
    /// - Parameter metadata: The metadata dictionary, which is optional.
    /// - Returns: A JSON string representation of the metadata or nil if serialization fails or metadata is nil/empty.
    internal func metadataToJsonString(metadata: [String: Any]?) -> String? {
        guard let metadata = metadata, !metadata.isEmpty else { return nil }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: metadata, options: [])
            return String(data: data, encoding: .utf8)
        } catch {
            print("Error serializing metadata to JSON string: \(error)")
            return nil
        }
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
                if let sharedDefaults = UserDefaults(suiteName: self.sharedDefaultsSuiteName) {
                    sharedDefaults.set(self.visitDate, forKey: Keys.visitDateKey)
                } else {
                    UserDefaults.standard.set(self.visitDate, forKey: Keys.visitDateKey)
                }
                return true
            }
        } else {
            // No visit date yet, initialize it
            visitDate = Date()
            if let sharedDefaults = UserDefaults(suiteName: self.sharedDefaultsSuiteName) {
                sharedDefaults.set(visitDate, forKey: Keys.visitDateKey)
            } else {
                UserDefaults.standard.set(visitDate, forKey: Keys.visitDateKey)
            }                
            return true
        }
    }
    
    /// Get the cached userAgent or fetch a new one
    internal func getUserAgent() async throws -> String {
        if let userAgent { return userAgent }
        let newUserAgent = try await UserAgentFetcher.fetch()
        userAgent = newUserAgent
        return newUserAgent
    }
    
    /// Keys used to store things in UserDefaults
    internal struct Keys {
        static let visitDateKey = "simpleanalytics.visitdate"
        static let optedOutKey = "simpleanalytics.isoptedout"
    }
}
