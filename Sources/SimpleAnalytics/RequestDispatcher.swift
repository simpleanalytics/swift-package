//
//  File.swift
//  
//
//  Created by Roel van der Kraan on 03/11/2023.
//

import Alamofire
import Foundation

internal struct RequestDispatcher {
    /// Sends the event to Simple Analytics asynchronously
    /// - Parameter event: the event to dispatch
    static func sendEventRequest(event: Event) async {
        do {
            let response = try await AF.request("https://queue.simpleanalyticscdn.com/events",
                                                method: .post,
                                                parameters: event,
                                                encoder: JSONParameterEncoder.default)
                                        .serializingData()
                                        .response
            
            guard let httpStatusCode = response.response?.statusCode else { return }
            
            switch httpStatusCode {
            case 201:
                debugPrint("Simple Analytics: Event tracked")
            default:
                debugPrint("Simple Analytics: Error while tracking Event to SimpleAnalytics, response code: \(httpStatusCode)")
            }
        } catch {
            debugPrint("Simple Analytics: An error occurred while tracking Event - \(error.localizedDescription)")
        }
    }
}
