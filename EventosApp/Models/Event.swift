//
//  Event.swift
//  EventosApp
//
//  Created by Lucas Santiago on 24/04/21.
//

import Foundation

struct Event: Codable, Equatable {
    
    let date: Int
    let description: String
    let image: String
    let longitude: Double
    let latitude: Double
    let price: Double
    let title: String
    let id: String
    
    var url: URL? {
        return URL(string: self.image)
    }
}
