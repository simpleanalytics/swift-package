//
//  Event.swift
//
//
//  Created by Roel van der Kraan on 02/11/2023.
//

import Foundation

internal struct Event: Encodable {
    let type: EventType
    let hostname: String
    let event: String
    let ua: String?
    let path: String?
    let language: String?
    let timezone: String?
    let viewport_width: Int?
    let viewport_height: Int?
    let screen_width: Int?
    let screen_height: Int?
    let unique: Bool?
    
    init(type: EventType, hostname: String, event: String, ua: String? = nil, path: String? = nil, language: String? = nil, timezone: String? = nil, viewport_width: Int? = nil, viewport_height: Int? = nil, screen_width: Int? = nil, screen_height: Int? = nil, unique: Bool? = nil) {
        self.type = type
        self.hostname = hostname
        self.event = event
        self.ua = ua
        self.path = path
        self.language = language
        self.timezone = timezone
        self.viewport_width = viewport_width
        self.viewport_height = viewport_height
        self.screen_width = screen_width
        self.screen_height = screen_height
        self.unique = unique
    }
}

internal enum EventType: String, Encodable {
    case event = "event"
    case pageview = "pageview"
}
