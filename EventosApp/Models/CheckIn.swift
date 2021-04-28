//
//  File.swift
//  EventosApp
//
//  Created by Lucas Santiago on 26/04/21.
//

import Foundation

class CheckIn: Codable {
    var eventId: String
    var name: String
    var email: String
    
    init(eventId: String, name: String, email: String) {
        self.eventId = eventId
        self.name = name
        self.email = email
    }
}
