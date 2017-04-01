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
        
        let body: [String: String] = ["UserName": "\(self.userName)", "Channel": "\(slightlyFixedChannelName)"]
        let jsonBody = try? JSONSerialization.data(withJSONObject: body)
        
        let urlString : String = Config.createNewChannelURL
        let url: URL = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Config.dasKey, forHTTPHeaderField: "DasKey")
        request.httpBody = jsonBody
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            FIRMessaging.messaging().subscribe(toTopic: "/topics/\(channelName)")
        })
        
        task.resume()
        
    }
}
