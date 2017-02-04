//
//  MainViewController.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 1/29/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import UIKit
import FirebaseMessaging

class MainViewController: UIViewController {

    var channels: [String] = []
    var userName: String? = ""
    
    @IBAction func HeyDonutsOnClick(_ sender: Any) {
        let urlString : String = "https://dasnetwork.herokuapp.com/?Key=4duIyZ4lYE5448rAueRVB3Y92uWidl5V&UserName=\(userName)&DeviceId=12345&Channel=ATNA"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
