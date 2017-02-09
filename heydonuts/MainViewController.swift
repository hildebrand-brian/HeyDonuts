//
//  MainViewController.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 1/29/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var channels: [String] = []
    static var userName: String = "UnknownUser"
    let DASKey : String = "4duIyZ4lYE5448rAueRVB3Y92uWidl5V"
    
    @IBOutlet weak var channelPicker: UIPickerView!
    
    @IBAction func HeyDonutsOnClick(_ sender: Any) {
        
        let row = self.channelPicker.selectedRow(inComponent: 0)
        let recipients = self.channels[row]
        
        let urlString : String = "https://dasnetwork.herokuapp.com/?Key=\(self.DASKey)&UserName=\(MainViewController.userName)&DeviceId=12345&Channel=\(recipients)"
        let url: URL = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")})
        
        task.resume()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getChannelsSubscribedTo()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getChannelsSubscribedTo(){
        self.channels = []
        
        let token = FIRInstanceID.instanceID().token()!
        let urlString : String = "https://dasnetwork.herokuapp.com/subscription/list/?Key=\(self.DASKey)&Token=\(token)"
        let url: URL = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            if let entries = json as? [String:Any] {
                for (channelName,_) in entries {
                    self.channels.append(channelName)
                }
            }
            self.channelPicker.reloadComponent(0)
            
        })
        
        task.resume()
    }
    

    
}
