//
//  UnsubscribeViewController.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 2/13/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging

class UnsubscribeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var channels: [String] = []
    
    @IBOutlet weak var channelsPicker: UIPickerView!
    
    @IBAction func unsubscribeButton(_ sender: Any) {
        let newTopic = channels[channelsPicker.selectedRow(inComponent: 0)]
        FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/\(newTopic)")
        
        // show modal
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let token = FIRInstanceID.instanceID().token()
        
        if let unwrappedToken = token{
            getChannels(token: unwrappedToken)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return channels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return channels.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func getChannels(token: String) {
        let urlString : String = Config.getSubscribedChannelsURL
        let url: URL = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(Config.dasKey)", forHTTPHeaderField: "DasKey")
        
        let tokenBase64 = Data(token.utf8).base64EncodedString()
        request.addValue("\(tokenBase64)", forHTTPHeaderField: "Token")
        
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            self.channels = []
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            if let entries = json as? [String:Any] {
                for (channelName,_) in entries {
                    self.channels.append(channelName)
                }
            }
            
            DispatchQueue.global(qos: .userInitiated).async{
                DispatchQueue.main.async{
                    self.channelsPicker.reloadAllComponents()
                }
            }
        })
        
        task.resume()
    }
}
