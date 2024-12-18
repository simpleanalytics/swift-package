//
//  UserAgent.swift
//  
//
//  Created by Roel van der Kraan on 27/10/2023.

import Foundation
import WebKit

internal class UserAgentProvider {
    /// Generates a useragent for the app that SimpleAnalytics is included in. Simple Analytics uses this user agent to determine
    /// the device type.
    /// - Returns: A useragent for the app.
    let userAgent: String = WKWebView().value(forKey: "userAgent") as! String
}

