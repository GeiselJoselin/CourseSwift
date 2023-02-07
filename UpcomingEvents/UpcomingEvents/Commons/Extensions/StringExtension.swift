//
//  StringExtension.swift
//  UpcomingEvents
//
//  Created by Geisel Roque on 04/08/22.
//

import Foundation

extension String {

    func convertStringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        let date = dateFormatter.date(from: self)
        return date ?? Date()
    }

    func getDay() -> String {
        let date = convertStringToDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }

    func changeFormat() -> String {
        let date = convertStringToDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        let stringFromDate = dateFormatter.string(from: date)
        return stringFromDate
    }

    func getHoursMinutes() -> (hour: Int, minutes: Int) {
        let date = convertStringToDate()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)

        return (hour, minutes)
    }
}
