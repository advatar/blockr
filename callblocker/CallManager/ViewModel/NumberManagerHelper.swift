//
//  NumberManagerHelper.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/20/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import Foundation
import CallKit

class NumberManagerHelper {
    
    class func formatAndCheckPhoneNumber(phoneNumber: String) -> Int64? {
        let numString = phoneNumber.digits
        if let number = Int64(numString) {
            return number
        }
        return nil
    }
    
    class func reloadCallDirectoryExtension() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: Config.callDirectoryExtensionID) { (error) in
            if let error = error{
                print("error can't reload CallDirectoryExtension \(error.localizedDescription)")
            }
        }
    }
    
    class func isCallDirectoryExtensionActive(completion: @escaping (_ isActive: Bool) -> Void) {
        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: Config.callDirectoryExtensionID, completionHandler: {(status, error) -> Void
            in
            if let error = error {
                print( "error Occured \(error.localizedDescription)")
            }
            if status == .enabled {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
