//
//  EditChannelsViewController.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 2/13/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import UIKit

class EditChannelsViewController: UIViewController {

    
    @IBOutlet weak var subscribeNavButton: UIButton!
    @IBOutlet weak var unsubscribeNavButton: UIButton!
    @IBOutlet weak var createChannelNavButton: UIButton!


    
    override func viewDidLoad() {
        self.subscribeNavButton.layer.cornerRadius = 8
        self.subscribeNavButton.layer.masksToBounds = true
        
        self.unsubscribeNavButton.layer.cornerRadius = 8
        self.unsubscribeNavButton.layer.masksToBounds = true
        
        self.createChannelNavButton.layer.cornerRadius = 8
        self.createChannelNavButton.layer.masksToBounds = true
    }
}
