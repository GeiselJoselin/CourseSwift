//
//  UpcomingEventsViewController.swift
//  UpcomingEvents
//
//  Created by Geisel Roque on 04/08/22.
//

import UIKit

class UpcomingEventsViewController: UIViewController, UpcomingEventsViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    private let presenter: UpcomingEventsPresenter = UpcomingEventsPresenter(getNextEventsLocalData: GetNextEventsLocalData())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(upcomingEventsViewDelegate: self)
        setUpTableView()
    }

    func setUpTableView() {
        let nib = UINib(nibName: "EventsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EventsCell")
        tableView.delegate = self
        tableView.dataSource = self
        presenter.getEvents()
    }

    func reloadTable() {
        self.tableView.reloadData()
    }
}

extension UpcomingEventsViewController: UITableViewDelegate, UITableViewDataSource, DelegateMessage {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumbersOfRowsInSection(section: section)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.getSections()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: EventsCell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as? EventsCell else {
            return UITableViewCell()
        }
        let event: EventConflict = presenter.getEvent(indexPath: indexPath)
        cell.delegate = self
        cell.model = event
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter.getRowHeight(indexPath: indexPath) ? UITableView.automaticDimension : .zero
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lblHeader: UILabel = UILabel()
        lblHeader.frame = CGRect(x: 0, y: 8, width: 320, height: 20)
        lblHeader.font = UIFont.boldSystemFont(ofSize: 20)
        lblHeader.textColor = UIColor.orange
        lblHeader.text = presenter.getHeaderTitle(section: section)
        
        let headerView = UIView()
        headerView.tag = presenter.getHeaderTag(section: section)
        headerView.backgroundColor = .white
        headerView.addSubview(lblHeader)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(tapGestureRecognizer:)))
        headerView.addGestureRecognizer(tap)
        
        return headerView
    }

    @objc func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let section = tapGestureRecognizer.view?.tag
        getExpandedEvents(section: section)
    }

    func getExpandedEvents(section: Int?) {
        presenter.expandedCells(section: section)
    }

    func sendMessage() {
        self.customAlert(title: "Conflict", message: "This events have conflicts with one or more events", completion: nil)
    }
}

