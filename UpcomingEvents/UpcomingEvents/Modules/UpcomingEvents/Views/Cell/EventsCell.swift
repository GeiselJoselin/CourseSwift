//
//  EventsCell.swift
//  UpcomingEvents
//
//  Created by Geisel Roque on 04/08/22.
//

import Foundation
import UIKit

protocol DelegateMessage {
    func sendMessage()
}

class EventsCell: UITableViewCell {

    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLable: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    var model: EventConflict = EventConflict() {
        didSet {
            fillCell()
        }
    }

    var delegate: DelegateMessage?

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func fillCell() {
        infoButton.isHidden = !model.conflict
        eventLabel.text = model.event.title
        startDateLabel.text = "Start: " + model.event.start.changeFormat()
        endDateLable.text = "End: " + model.event.end.changeFormat()
    }
    @IBAction func displayInfo(_ sender: Any) {
        delegate?.sendMessage()
    }
}
