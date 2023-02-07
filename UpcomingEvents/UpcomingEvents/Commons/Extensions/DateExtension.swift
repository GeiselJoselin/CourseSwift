//
//  DateExtension.swift
//  UpcomingEvents
//
//  Created by Geisel Roque on 05/08/22.
//

import Foundation

extension Date {
    func splitHours(hours: Int, minutes: Int) -> Date
      {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

        var date_components = calendar.components(
          [NSCalendar.Unit.year,
           NSCalendar.Unit.month,
           NSCalendar.Unit.day],
          from: self)

        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0

        let newDate = calendar.date(from: date_components)!
        return newDate
      }
}
