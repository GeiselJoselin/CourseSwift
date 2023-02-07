//
//  UpcomingEventsPresenterTest.swift
//  UpcomingEventsTests
//
//  Created by Geisel Roque on 05/08/22.
//

import XCTest
@testable import UpcomingEvents

class UpcomingEventsPresenterTest: XCTestCase {
    
    var presenter: UpcomingEventsPresenter?
    var viewDelegateMock: UpcomingEventsViewMock = UpcomingEventsViewMock()
    var localDataMock: UpcomingEventsLocalDataMock = UpcomingEventsLocalDataMock()
    //    lazy var view =
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        presenter = UpcomingEventsPresenter(getNextEventsLocalData: localDataMock)
        presenter?.setViewDelegate(upcomingEventsViewDelegate: viewDelegateMock)
    }
    
    override func tearDown() {
        super.tearDown()
        presenter = nil
    }
    
    func testGetSections() {
        // Given
        let expectedResult = 1
        presenter?.sections = [SectionsEvents(rows: [],
                                              title: "",
                                              tag: 0)]
        
        // When
        let sections = presenter?.getSections()
        
        // Then
        XCTAssertEqual(sections, expectedResult)
    }

    func testGetRowsInSection() {
        // Given
        let expectedResult = 2
        presenter?.sections = [SectionsEvents(rows: [EventConflict(), EventConflict()],
                                              title: "",
                                              tag: 0)]
        
        // When
        let sections = presenter?.getNumbersOfRowsInSection(section: 0)
        
        // Then
        XCTAssertEqual(sections, expectedResult)
    }

    func testGetHeaderTitle() {
        // Given
        let expectedResult = "Test Title"
        presenter?.sections = [SectionsEvents(rows: [],
                                              title: expectedResult,
                                              tag: 0)]
        
        // When
        let header = presenter?.getHeaderTitle(section: 0)
        
        // Then
        XCTAssertEqual(header, expectedResult)
    }

    func testGetTagSection() {
        // Given
        let expectedResult = 2
        presenter?.sections = [SectionsEvents(rows: [],
                                              title: "Test Title",
                                              tag: expectedResult)]
        
        // When
        let tag = presenter?.getHeaderTag(section: 0)
        
        // Then
        XCTAssertEqual(tag, expectedResult)
    }

    func testGetEvent() {
        // Given
        let expectedResult = "Test Event"
        presenter?.sections = [SectionsEvents(rows: [EventConflict(event: Event(title: expectedResult))],
                                              title: "",
                                              tag: 0)]
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        let event = presenter?.getEvent(indexPath: indexPath)
        
        // Then
        XCTAssertEqual(event?.event.title, expectedResult)
    }

    func testExpandSection() {
        // Given
        presenter?.sections = [SectionsEvents(rows: [],
                                              title: "",
                                              expanded: false,
                                              tag: 0)]
        
        // When
        presenter?.expandSection(section: 0)
        
        // Then
        XCTAssertTrue(presenter?.sections[0].expanded ?? false)
    }

    func testGetHoursAndMEnd() {
        // Given
        let end = "November 1, 2018 10:00 AM"
        let event = EventConflict(event: Event(end: end))
        
        // When
        let date = presenter?.getHoursAndDateEnd(event: event)
        
        // Then
        XCTAssertEqual(date, end.convertStringToDate())
    }

    func testGetHoursAndMin() {
        // Given
        let end = "November 1, 2018 10:00 AM"
        let event = EventConflict(event: Event(end: end))
        
        // When
        let date = presenter?.getHoursAndDateEnd(event: event)
        
        // Then
        XCTAssertEqual(date, end.convertStringToDate())
    }

    func testCheckInTime() {
        // Given
        let start = "November 1, 2018 10:00 AM"
        let event = EventConflict(event: Event(start: start))
        
        // When
        let inTime = presenter?.checkInTime(startDate: start.convertStringToDate(), eventToCompare: event)
        
        // Then
        XCTAssertTrue(inTime ?? false)
    }
    
}
