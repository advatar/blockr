//
//  BlockedWord+CoreDataClass.swift
//  callblocker
//
//  Created by Ivo Valcic on 11/16/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//
//

import Foundation
import CoreData

@objc public enum WordType: Int16
{
    case offensive         = 0
    case user              = 1
}

@objc(BlockedWord)
public class BlockedWord: NSManagedObject {
    
    public class func fetchAll(context ctx: NSManagedObjectContext) -> [BlockedWord]?{
        let fetchReq = NSFetchRequest<BlockedWord>(entityName: "BlockedWord")
        let contentSort = NSSortDescriptor(key: "content", ascending: true)
        fetchReq.sortDescriptors = [contentSort]
        
        do{
            if let words = try ctx.fetch(fetchReq) as [BlockedWord]? {
                if words.count > 0 {
                    return words
                } else {
                    return nil
                }
            }
        } catch {
            print("Unable fetch objects for blocked words \(error)")
        }
        return nil
    }
    
    public class func fetchBy(type: WordType, context ctx: NSManagedObjectContext) -> [BlockedWord]?{
        let fetchReq = NSFetchRequest<BlockedWord>(entityName: "BlockedWord")
        let predicate = NSPredicate(format: "type = %@", NSNumber.init(value: type.rawValue))
        fetchReq.predicate = predicate
        let wordsSort = NSSortDescriptor(key: "content", ascending: true)
        fetchReq.sortDescriptors = [wordsSort]
        
        do{
            if let words = try ctx.fetch(fetchReq) as [BlockedWord]? {
                if words.count > 0 {
                    return words
                } else {
                    return nil
                }
            }
        } catch {
            print("Unable fetch objects for words \(error)")
        }
        return nil
    }
    
    public class func findBy(content: String, context ctx: NSManagedObjectContext) -> BlockedWord?  {
        let fetchReq = NSFetchRequest<BlockedWord>(entityName: "BlockedWord")
        let predicate = NSPredicate.init(format: "content = %@", content)
        fetchReq.predicate = predicate
        
        do {
            if let result = try ctx.fetch(fetchReq) as [BlockedWord]? {
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
    
    public class func deleteWord(content: String?, ctx: NSManagedObjectContext) -> Void {
        guard let content = content else {return}
        if let word = self.findBy(content: content, context: ctx) {
            ctx.performAndWait {
                ctx.delete(word)
                do {
                    try ctx.save()
                } catch {
                    print("Ctx save exception: \(error)")
                }
            }
        }
    }
    
    public class func createOrUpdate(content: String, type: WordType, ctx: NSManagedObjectContext) -> BlockedWord {
        if let word = self.findBy(content: content, context: ctx){
            word.importWord(content: content, type: type)
            return word
        }
        else {
            let word = BlockedWord.init(entity: BlockedWord.entity(), insertInto: ctx)
            word.importWord(content: content, type: type)
            return word
        }
    }
    
    private func importWord(content: String, type: WordType){
        self.content = content
        self.type = type
    }
    
}
