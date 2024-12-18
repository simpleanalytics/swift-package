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
    static internal func sendEventRequest(event: Event) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("https://queue.simpleanalyticscdn.com/events",
                       method: .post,
                       parameters: event,
                       encoder: JSONParameterEncoder.default).responseData { response in
                
                switch(response.result) {
                    case .success(_):
                        continuation.resume()
                    case let .failure(error):
                        continuation.resume(throwing: self.handleError(error: error))
                    }
            }
        }
    }
    
    static private func handleError(error: AFError) -> Error {
            if let underlyingError = error.underlyingError {
                let nserror = underlyingError as NSError
                let code = nserror.code
                if code == NSURLErrorNotConnectedToInternet ||
                    code == NSURLErrorTimedOut ||
                    code == NSURLErrorInternationalRoamingOff ||
                    code == NSURLErrorDataNotAllowed ||
                    code == NSURLErrorCannotFindHost ||
                    code == NSURLErrorCannotConnectToHost ||
                    code == NSURLErrorNetworkConnectionLost
                {
                    var userInfo = nserror.userInfo
                    userInfo[NSLocalizedDescriptionKey] = "Unable to connect to the server"
                    let currentError = NSError(
                        domain: nserror.domain,
                        code: code,
                        userInfo: userInfo
                    )
                    return currentError
                }
            }
            return error
        }
}
