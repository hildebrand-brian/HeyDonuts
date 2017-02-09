//
//  ViewController.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 1/16/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        self.loginButton.layer.cornerRadius = 8
        self.loginButton.layer.masksToBounds = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let text = self.usernameField.text{
            MainViewController.userName = text
        }
    }

    

}

