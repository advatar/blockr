//
//  PhoneNumber+CoreDataProperties.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/22/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//
//

import Foundation
import CoreData

extension PhoneNumber {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneNumber> {
        return NSFetchRequest<PhoneNumber>(entityName: "PhoneNumber")
    }

    @NSManaged public var desc: String?
    @NSManaged public var number: Int64
    @NSManaged public var type: NumberType
    @NSManaged public var identification: String

}
