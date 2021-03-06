//
//  ChannelsViewController.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 2/2/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import UIKit
import FirebaseInstanceID
import FirebaseMessaging

class ChannelsViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var channels: [String] = []

    @IBOutlet weak var channelsPicker: UIPickerView!
    
    @IBAction func subscribeButton(_ sender: Any) {
        let newTopic = channels[channelsPicker.selectedRow(inComponent: 0)]
        FIRMessaging.messaging().subscribe(toTopic: "/topics/\(newTopic)")
        
        // show modal
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        getChannels()
        
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
    
    func getChannels() {
        let urlString : String = Config.getAllChannelsURL
        let url: URL = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(Config.dasKey)", forHTTPHeaderField: "DasKey")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            if let entries = json as? [[String:Any]] {
                self.channels = []
                for entry in entries {
                    self.channels.append(entry["key"] as! String)
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
