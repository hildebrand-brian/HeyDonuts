//
//  ChannelsViewController.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 2/2/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import UIKit

class ChannelsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var channels: [String] = []
    
    @IBOutlet weak var channelsTable: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        getChannels()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelsCell", for: indexPath)
        cell.textLabel?.text = channels[indexPath.row]
        print(channels[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func getChannels() {
        let urlString : String = "https://dasnetwork.herokuapp.com/channels/list"
        let url: URL = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            if let array = json as? [String] {
                for item in array {
                    self.channels.append(item)
                }
            }
            
            self.channelsTable.reloadData()
            
        })
        
        task.resume()
    }
}
