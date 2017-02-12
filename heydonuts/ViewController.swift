//
//  ViewController.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 1/16/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet var SignInButton: GIDSignInButton!
    
    func refreshInterface() {
        if (GIDSignIn.sharedInstance().currentUser) != nil {
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
            print("Succeeded in getting a current user during refreshInterface call")
        }
        print("Failed to retriever currentUser during a refreshInterface call")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().signInSilently()
        SignInButton.style = .wide
        
        (UIApplication.shared.delegate as! AppDelegate).signInCallback = refreshInterface
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
