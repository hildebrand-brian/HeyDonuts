//
//  SubscriptionService.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 4/1/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import Foundation

class SubscriptionService {

    func getSubscriptionList(token: String, handler: ()) {
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

    
    }
}
