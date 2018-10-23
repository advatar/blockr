//
//  MessageFilterExtension.swift
//  MessageFilterExtension
//
//  Created by Ivo Valcic on 10/18/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import IdentityLookup

final class MessageFilterExtension: ILMessageFilterExtension {
    
}

extension MessageFilterExtension: ILMessageFilterQueryHandling {
    
    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        // First, check whether to filter using offline data (if possible).
        let offlineAction = self.offlineAction(for: queryRequest)
        
        switch offlineAction {
        case .allow, .filter:
            // Based on offline data, we know this message should either be Allowed or Filtered. Send response immediately.
            let response = ILMessageFilterQueryResponse()
            response.action = offlineAction
            
            completion(response)
            
        case .none:
            // Based on offline data, we do not know whether this message should be Allowed or Filtered. Defer to network.
            // Note: Deferring requests to network requires the extension target's Info.plist to contain a key with a URL to use. See documentation for details.
            context.deferQueryRequestToNetwork() { (networkResponse, error) in
                let response = ILMessageFilterQueryResponse()
                response.action = .none
                
                if let networkResponse = networkResponse {
                    // If we received a network response, parse it to determine an action to return in our response.
                    response.action = self.action(for: networkResponse)
                } else {
                    NSLog("Error deferring query request to network: \(String(describing: error))")
                }
                
                completion(response)
            }
        }
    }
    
    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> ILMessageFilterAction {
        // Replace with logic to perform offline check whether to filter first (if possible).
        guard let messageBody = queryRequest.messageBody?.lowercased(),
            let userDefaults = UserDefaults.init(suiteName: Config.sharedGroupName),
            let blockedWords = userDefaults.array(forKey: Config.kBlockedWords) as? [String] else {return .none}
        
        for blockedWord in blockedWords {
            NSLog("Blocked word: \(blockedWord)\n")
            if messageBody.contains(blockedWord.lowercased()) {
                return .filter
            }
        }
        
        return .allow
    }
    
    private func action(for networkResponse: ILNetworkResponse) -> ILMessageFilterAction {
        // Replace with logic to parse the HTTP response and data payload of `networkResponse` to return an action.
        return .none
    }
    
}
