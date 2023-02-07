//
//  SectionsEvents.swift
//  UpcomingEvents
//
//  Created by Geisel Roque on 05/08/22.
//

import Foundation

class SectionsEvents {
    var rows: [EventConflict]
    var title: String
    var expanded: Bool
    var tag: Int

    init(rows: [EventConflict] = [], title: String = "", expanded: Bool = false, tag: Int = .zero) {
        self.rows = rows
        self.title = title
        self.expanded = expanded
        self.tag = tag
    }
}
