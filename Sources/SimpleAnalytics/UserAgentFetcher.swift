//
//  UserAgent.swift
//  
//
//  Created by Max Humber on 2025-01-02.

import WebKit

enum UserAgentFetcher {
    @MainActor
    static func fetch() async throws -> String {
        let webView = WKWebView(frame: .zero)
        let result = try await webView.evaluateJavaScript("navigator.userAgent")
        guard let userAgent = result as? String else { throw UserAgentError.unableToFetchUserAgent }
        return userAgent
    }
}

enum UserAgentError: Error {
    case unableToFetchUserAgent
}
