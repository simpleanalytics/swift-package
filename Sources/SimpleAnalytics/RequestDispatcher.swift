//
//  File.swift
//  
//
//  Created by Roel van der Kraan on 03/11/2023.
//

import Foundation

internal struct RequestDispatcher {
    /// Sends the event to Simple Analytics
    /// - Parameter event: the event to dispatch
    static internal func sendEventRequest(event: Event) async throws {
        guard let url = URL(string: "https://queue.simpleanalyticscdn.com/events") else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(event)
        request.httpBody = jsonData
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard (200...299).contains(httpResponse.statusCode) else { throw URLError(URLError.Code(rawValue: httpResponse.statusCode)) }
    }
}
