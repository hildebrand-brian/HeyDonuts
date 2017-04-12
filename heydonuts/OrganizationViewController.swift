//
//  OrganizationViewController.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 4/3/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import UIKit

class OrganizationViewController: ViewController {

    @IBOutlet weak var OrganizationNameField: UITextField!
    @IBOutlet weak var OrganizationPasswordField: UITextField!
    
    
    @IBAction func JoinTeamButton(_ sender: Any) {
        
        let name = OrganizationNameField.text
        let passcode = OrganizationPasswordField.text
        let body: [String: String] = ["OrgName": "\(name)", "PassCode": "\(passcode)"]
        let jsonBody = try? JSONSerialization.data(withJSONObject: body)
        
        let urlString : String = Config.OrganizationSignInURL
        let url: URL = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let session = URLSession.shared
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonBody
        
        var channelKey: String = ""
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            if let entries = json as? [[String:Any]] {
                for entry in entries {
                    channelKey = (entry["key"] as! String)
                }
            }
            
            self.UpdateOrganizationKey(newKey: channelKey)
            
            DispatchQueue.global(qos: .userInitiated).async{
                DispatchQueue.main.async{
                    // redirect? Can I redirect from here? Do I need to redirect from here?
                    
                }
            }
        })
        
        task.resume()
        // spinner here
        
        
        // make a service call to get the key
        // if this succeeds, save the whole thing in the local database
        // if it fails, show a popup thing to alert the user that they entered an invalid username or password
        // set current key, which should be a static variable somewhere probably
        // return the user to the previous page
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // pre-fill the name field
        // pre-fill the password field
    }
    
    func UpdateOrganizationKey(newKey: String){
        OrganizationDataAccessObject.instance.updateKey(recordKey: newKey)
    }
}
