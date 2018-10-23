//
//  CallDirectoryHandler.swift
//  CallDirectoryExtension
//
//  Created by Ivo Valcic on 10/18/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {
    
    private let ctx = CoreDataStorage.mainQueueContext()

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        
        if let numbers = PhoneNumber.fetchAll(context: ctx){
            for number in numbers {
                if number.type == .blocked {
                    context.addBlockingEntry(withNextSequentialPhoneNumber: number.number)
                }
                if number.type == .suspicious {
                    context.addIdentificationEntry(withNextSequentialPhoneNumber: number.number, label:number.identification)
                }
            }
        }

        context.completeRequest()
    }

}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occured while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
    }

}
