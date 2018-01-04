//
//  StatusesTableViewController.swift
//  Awake
//
//  Created by admin on 13/11/2017.
//  Copyright © 2017 Dreamer. All rights reserved.
//

import UIKit

class StatusesTableViewController: UITableViewController {
    var statuses: [Status] = []
    
    @objc func refreshing(_ sender: AnyObject)
    {
        loadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refreshing), for: UIControlEvents.valueChanged)
        loadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statuses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell")
        let status = statuses[indexPath.row]
        cell?.textLabel?.text = status.username
        cell?.detailTextLabel?.text = status.awakeTime
        return cell!
    }
    
    func loadData(){
        ApiController.sharedController.getAwakeStatuses(){ (result, statuses) in
            guard result else {
                self.showAlert(with: "Error", detail: "Unable to update table", style: .alert)
                return
            }
            self.statuses = statuses!
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
}
