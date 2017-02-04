//
//  ViewController.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 1/16/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainScreen = segue.destination as! MainViewController
        if let name = usernameField.text{
            mainScreen.userName = name
        }
        
    }

    

}

