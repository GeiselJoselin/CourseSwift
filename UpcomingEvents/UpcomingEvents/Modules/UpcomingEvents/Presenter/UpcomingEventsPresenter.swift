//
//  UpcomingEventsPresenter.swift
//  UpcomingEvents
//
//  Created by Geisel Roque on 04/08/22.
//

import Foundation

protocol UpcomingEventsViewDelegate: NSObjectProtocol {
    func reloadTable()
}

class UpcomingEventsPresenter {
    var sections: [SectionsEvents] = []
    private let getNextEventsLocalData: GetNextEventsLocalData
    weak private var upcomingEventsViewDelegate: UpcomingEventsViewDelegate?
    
    init(getNextEventsLocalData: GetNextEventsLocalData) {
        self.getNextEventsLocalData = getNextEventsLocalData
    }
    
    func setViewDelegate(upcomingEventsViewDelegate: UpcomingEventsViewDelegate) {
        self.upcomingEventsViewDelegate = upcomingEventsViewDelegate
    }

    func getEvent(indexPath: IndexPath) -> EventConflict {
        sections[indexPath.section].rows[indexPath.row]
    }

    func getHeaderTag(section: Int) -> Int {
        sections[section].tag
    }

    func getHeaderTitle(section: Int) -> String {
        sections[section].title
    }

    func getNumbersOfRowsInSection(section: Int) -> Int {
        return sections[section].rows.count
    }

    func getSections() -> Int {
        return sections.count
    }
    
    /// fetch the events in local data 
    func getEvents() {
        getNextEventsLocalData.fetchLocalData(completion: { [weak self] events in
            guard let events: [EventConflict] = events,
                  let self = self else { return }
            self.sections = self.eventsSorted(events: events)
            self.upcomingEventsViewDelegate?.reloadTable()
            self.getConflictsWithEvents()
        })
    }
    
    
    /// arrange the dates in chronological order
    /// - Parameter events: the events in disorder
    /// - Returns: returns the new Array with correct order to show
    func eventsSorted(events: [EventConflict]) -> [SectionsEvents] {
        let sortedDates: [EventConflict] = events.sorted {
            $0.event.start.convertStringToDate() < $1.event.start.convertStringToDate()
        }
        return getSections(events: sortedDates)
    }
    
    func getSections(events: [EventConflict]) -> [SectionsEvents] {
        var sectionsEvents: [SectionsEvents] = []
        var tag = 0
        events.forEach({ event in
            let dateToCompare = event.event.start.getDay()
            if sectionsEvents.isEmpty {
                sectionsEvents.append(SectionsEvents(rows: [event],
                                                     title: event.event.start.getDay(),
                                                     tag: tag))
                tag += 1
            } else {
                guard let section = sectionsEvents.enumerated().first(where: { $0.element.title == dateToCompare }) else {
                    sectionsEvents.append(SectionsEvents(rows: [event],
                                                         title: event.event.start.getDay(),
                                                         tag: tag))
                    tag += 1
                    return
                }
                sectionsEvents[section.offset].rows.append(event)
            }
        })
        return sectionsEvents
    }
    
    /// function that will obtain the value of the day to show
    /// - Parameter section: the section of the array
    func expandedCells(section: Int?) {
        guard let section = section else { return }
        if let expandedSection = sections.enumerated().first(where: { $0.element.expanded }) {
            if section == expandedSection.offset {
                sections[expandedSection.offset].expanded = false
            } else {
                expandSection(section: section)
            }
        } else {
            expandSection(section: section)
        }
        upcomingEventsViewDelegate?.reloadTable()
    }

    func expandSection(section: Int) {
        sections.forEach({ $0.expanded = false })
        sections[section].expanded = true
    }

    func getRowHeight(indexPath: IndexPath) -> Bool {
        sections[indexPath.section].expanded
    }

    /// get the hour and minutes of the start event to compare
    /// - Parameter event: the event to compare
    /// - Returns: returns tupla to hour and minutes
    func getHoursAndDate(event: EventConflict) -> Date {
        let start = event.event.start.getHoursMinutes()
        return event.event.start.convertStringToDate().splitHours(hours: start.hour,
                                                                  minutes: start.minutes)
    }
    
    /// get the hour and minutes of the end event to compare
    /// - Parameter event: the event to compare
    /// - Returns: returns tupla to hour and minutes
    func getHoursAndDateEnd(event: EventConflict) -> Date {
        let end = event.event.end.getHoursMinutes()
        return event.event.end.convertStringToDate().splitHours(hours: end.hour,
                                                                  minutes: end.minutes)
    }
    
    /// Check if eventToCompare is between specific hours
    /// - Parameters:
    ///   - startDate: The specific hour to compare
    ///   - eventToCompare: event to compare
    ///   - isPrevious: if check with the next event or the previous
    /// - Returns: return Bool to know if the events will ocurr at the same time
    func checkInTime(startDate: Date, eventToCompare: EventConflict, isPrevious: Bool = false) -> Bool {
        let next = eventToCompare.event.start.convertStringToDate() >= startDate || eventToCompare.event.end.convertStringToDate() > startDate
        let previous = eventToCompare.event.start.convertStringToDate() < startDate || eventToCompare.event.end.convertStringToDate() <= startDate

        return isPrevious ? previous : next
    }
    
    /// Add the new sections Array with conflicts
    func getConflictsWithEvents() {
        sections.enumerated().forEach({ (index1, events) in
            var conflict = false
            events.rows.enumerated().forEach { (index2, event) in
                let nextIndex = index2 + 1
                let previousIndex = index2 - 1
                let rows = events.rows
                let correctIndex = nextIndex < rows.count
                if (correctIndex && !conflict) || conflict {
                    var startDate = Date()
                    var inTime = false
                    if conflict {
                        startDate = getHoursAndDateEnd(event: rows[previousIndex])
                        inTime = checkInTime(startDate: startDate, eventToCompare: event, isPrevious: true)
                        if !inTime && index2 - 2 >= 0 {
                            startDate = getHoursAndDateEnd(event: rows[index2 - 2])
                            inTime = checkInTime(startDate: startDate, eventToCompare: event, isPrevious:  true)
                        }
                    } else {
                        startDate = getHoursAndDate(event: rows[nextIndex])
                        inTime = checkInTime(startDate: startDate, eventToCompare: event)
                    }

                    conflict = inTime
                    
                    if inTime {
                        let newEvent = EventConflict(event: event.event,
                                                     conflict: true)
                        sections[index1].rows[index2] = newEvent
                    }
                }
            }
        })
    }
}
