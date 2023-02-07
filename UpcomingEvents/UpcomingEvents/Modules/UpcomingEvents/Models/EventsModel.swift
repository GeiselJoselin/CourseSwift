//
//  EventsModel.swift
//  UpcomingEvents
//
//  Created by Geisel Roque on 04/08/22.
//

import Foundation

// MARK: - Event
struct Event: Codable {
    let title: String
    let start: String
    let end: String

    init(title: String = "", start: String = "", end: String = "") {
        self.title = title
        self.start = start
        self.end = end
    }
}

struct EventConflict: Codable {
    let event: Event
    var conflict: Bool

    init(event: Event = Event(), conflict: Bool = false){
        self.event = event
        self.conflict = conflict
    }
}
