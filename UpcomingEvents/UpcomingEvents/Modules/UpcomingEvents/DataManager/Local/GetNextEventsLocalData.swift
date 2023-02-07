//
//  GetNextEventsLocalData.swift
//  UpcomingEvents
//
//  Created by Geisel Roque on 04/08/22.
//

import Foundation

class GetNextEventsLocalData {
    /// Transform Json file to swift model
    /// - Parameter completion: the json transformed into the new model
    func fetchLocalData(completion: @escaping ([EventConflict]?) -> Void) {
        guard let path: String = Bundle.main.path(forResource: "Events", ofType: "json"),
              let data: Data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let model: [Event] = try? JSONDecoder().decode([Event].self, from: data) else {
            return
        }
        let returnModel: [EventConflict] = model.compactMap({
            EventConflict(event: Event(title: $0.title,
                                       start: $0.start,
                                       end: $0.end))
        })
        completion(returnModel)
    }
}
