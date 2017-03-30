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
    
    let userName: String = "iOSTestUser"
    
    @IBOutlet weak var channelNameField: UITextField!
    @IBAction func createAndSubscribeButton(_ sender: Any) {
        if let channelName = channelNameField.text{
            AddAndSubscribeToChannel(channelName: channelName)
            self.navigationController!.popToRootViewController(animated: true)
        }
    
    }
    
    func AddAndSubscribeToChannel(channelName: String) {
        
        let slightlyFixedChannelName = channelName.replacingOccurrences(of: " ", with: "-")
        
        let urlString : String = "https://dasnetwork.herokuapp.com/v1/channel/add?UserName=\(self.userName)&Channel=\(slightlyFixedChannelName)"
        let url: URL = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("4duIyZ4lYE5448rAueRVB3Y92uWidl5V", forHTTPHeaderField: "DasKey")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            FIRMessaging.messaging().subscribe(toTopic: "/topics/\(channelName)")
        })
        
        task.resume()
        
    }
}
