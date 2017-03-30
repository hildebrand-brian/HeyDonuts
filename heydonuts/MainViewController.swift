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
import GoogleSignIn

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var channels: [String] = []
    var username: String?
    
    @IBOutlet weak var channelPicker: UIPickerView!
    
    @IBAction func HeyDonutsOnClick(_ sender: Any) {
        
        if (channels.count == 0){
            return
        }
        
        let row = self.channelPicker.selectedRow(inComponent: 0)
        let recipients = self.channels[row]
        
        
        if(self.username == nil){
            self.username = GIDSignIn.sharedInstance()?.currentUser?.profile?.givenName
        }
        
        if(self.username == nil){
            self.username = "Unknown User"
        }
        
        let urlString : String = "https://dasnetwork.herokuapp.com/v1/message/send?UserName=\(self.username!)&Channel=\(recipients)"
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

    }
    
    override func viewDidAppear(_ animated: Bool) {
        getChannelsSubscribedTo()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getChannelsSubscribedTo(){
        
        let token = FIRInstanceID.instanceID().token()
        
        if let unwrappedToken = token{
            callChannelsService(token: unwrappedToken)
        }
        
    }
    
    func callChannelsService(token: String){
        let urlString : String = "https://dasnetwork.herokuapp.com/subscription/list/?Key=4duIyZ4lYE5448rAueRVB3Y92uWidl5V&Token=\(token)"
        let url: URL = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("4duIyZ4lYE5448rAueRVB3Y92uWidl5V", forHTTPHeaderField: "DasKey")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            self.channels = []
            
            if error != nil {
                print("Error retrieving channels")
                // how do I pop this up?
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            if let entries = json as? [String:Any] {
                for (channelName,_) in entries {
                    self.channels.append(channelName)
                }
            }
            self.channelPicker.reloadAllComponents()
        })
        task.resume()
    }
    

    
}
