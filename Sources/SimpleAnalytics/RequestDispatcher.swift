//
//  File.swift
//  
//
//  Created by Roel van der Kraan on 03/11/2023.
//

import Foundation
import Alamofire

internal struct RequestDispatcher {
    /// Sends the event to Simple Analytics
    /// - Parameter event: the event to dispatch
    static internal func sendEventRequest(event: Event) {
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
}
