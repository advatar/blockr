//
//  BlockedWord+CoreDataProperties.swift
//  callblocker
//
//  Created by Ivo Valcic on 11/16/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//
//

import Foundation
import CoreData


extension BlockedWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlockedWord> {
        return NSFetchRequest<BlockedWord>(entityName: "BlockedWord")
    }

    @NSManaged public var content: String?
    @NSManaged public var type: WordType

}
