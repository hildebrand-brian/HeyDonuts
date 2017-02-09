//
//  NewChannelViewController.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 2/9/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import UIKit
import FirebaseMessaging

class NewChannelViewController: UIViewController{

    let DASKey : String = "4duIyZ4lYE5448rAueRVB3Y92uWidl5V"
    
    @IBOutlet weak var channelNameField: UITextField!
    @IBAction func createAndSubscribeButton(_ sender: Any) {
        if let channelName = channelNameField.text{
            AddAndSubscribeToChannel(channelName: channelName)

        }
    
    }
    
    func AddAndSubscribeToChannel(channelName: String) {
        let urlString : String = "https://dasnetwork.herokuapp.com/channel/add?Key=\(self.DASKey)&UserName=\(MainViewController.userName)&Channel=\(channelName)"
        let url: URL = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            FIRMessaging.messaging().subscribe(toTopic: "/topics/\(channelName)")
        })
        
        task.resume()
        
    }
}
