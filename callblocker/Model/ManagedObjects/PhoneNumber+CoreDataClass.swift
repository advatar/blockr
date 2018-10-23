//
//  PhoneNumber+CoreDataClass.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/22/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//
//

import Foundation
import CoreData

@objc public enum NumberType: Int16
{
    case normal         = 0
    case blocked        = 1
    case suspicious     = 2
}

@objc(PhoneNumber)
public class PhoneNumber: NSManagedObject {
    
    public class func fetchAll(context ctx: NSManagedObjectContext) -> [PhoneNumber]?{
        let fetchReq = NSFetchRequest<PhoneNumber>(entityName: "PhoneNumber")
        let numberSort = NSSortDescriptor(key: "number", ascending: true)
        fetchReq.sortDescriptors = [numberSort]
        
        do{
            if let numbers = try ctx.fetch(fetchReq) as [PhoneNumber]? {
                if numbers.count > 0 {
                    return numbers
                } else {
                    return nil
                }
            }
        } catch {
            print("Unable fetch objects for numbers \(error)")
        }
        return nil
    }
    
    public class func fetchAll(type: NumberType, context ctx: NSManagedObjectContext) -> [PhoneNumber]?{
        let fetchReq = NSFetchRequest<PhoneNumber>(entityName: "PhoneNumber")
        let predicate = NSPredicate(format: "type = %@", NSNumber.init(value: type.rawValue))
        fetchReq.predicate = predicate
        let numberSort = NSSortDescriptor(key: "number", ascending: true)
        fetchReq.sortDescriptors = [numberSort]
        
        do{
            if let numbers = try ctx.fetch(fetchReq) as [PhoneNumber]? {
                if numbers.count > 0 {
                    return numbers
                } else {
                    return nil
                }
            }
        } catch {
            print("Unable fetch objects for numbers \(error)")
        }
        return nil
    }
    
    public class func findBy(number: Int64, context ctx: NSManagedObjectContext) -> PhoneNumber?  {
        let fetchReq = NSFetchRequest<PhoneNumber>(entityName: "PhoneNumber")
        let predicate = NSPredicate.init(format: "number = %@", NSNumber.init(value:number))
        fetchReq.predicate = predicate
        
        do {
            if let result = try ctx.fetch(fetchReq) as [PhoneNumber]? {
                if result.count > 0 {
                    return result.first
                } else {
                    return nil
                }
            }
        } catch {
            print(error);
        }
        return nil
    }
    
    public class func deleteNumber(number: Int64, ctx: NSManagedObjectContext) -> Void {
        if let number = self.findBy(number: number, context: ctx) {
            ctx.performAndWait {
                ctx.delete(number)
                do {
                    try ctx.save()
                } catch {
                    print("Ctx save exception: \(error)")
                }
            }
        }
    }
    
    public class func createOrUpdate(number: Int64, desc: String?, type: NumberType, ctx: NSManagedObjectContext) -> PhoneNumber {
        if let phoneNumber = self.findBy(number: number, context: ctx){
            phoneNumber.importNumber(number: number, desc: desc, type: type)
            return phoneNumber
        }
        else {
            let phoneNumber = PhoneNumber.init(entity: PhoneNumber.entity(), insertInto: ctx)
            phoneNumber.importNumber(number: number, desc: desc, type: type)
            return phoneNumber
        }
    }
    
    
    private func importNumber(number: Int64, desc: String?, type: NumberType){
        self.number = number
        self.desc = desc
        self.type = type
        switch type {
        case .suspicious:
            self.identification = "\u{26A0} \(self.desc ?? "Suspicious Number")"
        default:
            self.identification = ""
        }
    }
}
