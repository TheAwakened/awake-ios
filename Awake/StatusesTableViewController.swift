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
//    var statuses: [(id:Int,username:String,awake_time:String)] = [
//        (id:1, username:"qihao", awake_time:"10:00pm"),
//        (id:2, username:"qihao1", awake_time:"10:00pm"),
//        (id:3, username:"qihao2", awake_time:"10:00pm")
//    ]
    var statuses: [[String:Any]] = []
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
        let data = statuses[indexPath.row]
        cell?.textLabel?.text = data["username"] as? String
        cell?.detailTextLabel?.text = data["awaken_time"] as? String ?? "Sleeping"
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
    }
    
    func loadData(){
        let url = URL(string: statusAPI)
        var urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            guard data != nil else {
                self.showAlert(
                    with: "Error",
                    detail: "Unable to receive data from server",
                    style: .alert
                )
                return
            }
            do{
                guard let responseData = try JSONSerialization.jsonObject(with: data!) as? [String:Any] else {
                    return
                }
                if error != nil {
                    self.showAlert(
                        with: "Error",
                        detail: responseData["message"] as? String ?? "Unknown error",
                        style: .alert
                    )
                }else{
                    self.statuses = responseData["users"] as! [[String:Any]]
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                }
                
            }catch{
                self.showAlert(
                    with: "Error",
                    detail: "Error in processing data, please enter the data again.",
                    style: .alert
                )
            }
            
        }
        urlRequest.addValue(UserDefaults.standard.object(forKey: "token") as! String,forHTTPHeaderField:"Authorization")
        task.resume()
    }
}
