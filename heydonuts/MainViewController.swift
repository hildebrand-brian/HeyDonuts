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
    
    @IBOutlet weak var refreshSubscriptionsBtn: UIButton!
    @IBAction func refreshSubscriptionsButton(_ sender: Any) {
        
        getChannelsSubscribedTo()
        
    }
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
        
        let urlString : String = Config.sendMessageURL
        let url: URL = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Config.dasKey, forHTTPHeaderField: "DasKey")
        
        let bodyData: [String:Any] = ["UserName": "\(self.username!)", "Channel": "\(recipients)"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: .prettyPrinted)
        
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
        refreshSubscriptionsBtn.showsTouchWhenHighlighted = true
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
            
            if error != nil {
                self.DisplayErrorWhenCantGetChannels()
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            if let entries = json as? [String:Any] {
                for (channelName,_) in entries {
                    self.channels.append(channelName)
                }
            }
            
            DispatchQueue.global(qos: .userInitiated).async{
                DispatchQueue.main.async{
                    self.channelPicker.reloadAllComponents()
                }
            }
            
        })
        task.resume()
    }
    
    func DisplayErrorWhenCantGetChannels(){
        let alert = UIAlertController(title: "Error Getting Channels", message: "There was an error getting the channels...please try again!", preferredStyle: .alert)
        let firstAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
            NSLog("Ok pressed for error getting channels")
        }
        
        alert.addAction(firstAction)
        present(alert, animated: true, completion:nil)
    }
    
    
}
