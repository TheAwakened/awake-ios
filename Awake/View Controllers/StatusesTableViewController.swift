//
//  StatusesTableViewController.swift
//  Awake
//
//  Created by admin on 13/11/2017.
//  Copyright © 2017 Dreamer. All rights reserved.
//

import UIKit

class StatusesTableViewController: UITableViewController {
    var statusAPI = Constants.apiUrl + "/api/today"
    var statuses: [Status] = []
    @objc func refreshing(_ sender:AnyObject)
    {
        // Updating your data here...
        loadData()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        loadData()
        tableView.reloadData()
    }
    func finishedLoadingData(result: String, data: [Status]){
        statuses = data
        refresh(self)
    }
    func loadData(){

        ApiController.sharedController.getAwakeStatuses(sender: self)
    }
}
