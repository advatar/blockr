//
//  MessageFilterManager.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/23/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import Foundation

class MessageFilterManager{
    
    var userBlockedWords: [String] {
        get {
            return userSavedBlockedWords()
        }
    }
    
    func manageOffensiveWords(addToList:Bool){
        var blockedWords = savedBlockedWords()
        if addToList {
            blockedWords.append(contentsOf: offensiveWords)
        } else {
            blockedWords = blockedWords.filter{ !offensiveWords.contains($0) }
        }
        saveBlockedWords(blockedWords: blockedWords)
    }
    
    func manageBlockedWord(addToList:Bool, word:String) throws{
        var blockedWords = savedBlockedWords()
        var userBlockewords = userSavedBlockedWords()
        if addToList {
            if userBlockewords.contains(word){
                let error = NSError(domain: "Duplicate word", code: 999, userInfo: [NSLocalizedDescriptionKey:"\(word) is already in your list"]) as Error
                throw error
            }
            blockedWords.append(word)
            userBlockewords.append(word)
        }
        else {
            blockedWords = blockedWords.filter{$0 != word}
            userBlockewords = userBlockewords.filter{$0 != word}
        }
        saveBlockedWords(blockedWords: blockedWords)
        saveUserBlockedWords(blockedWords: userBlockewords)
    }
    
    private func savedBlockedWords() -> [String]{
        let userDefaults = UserDefaults.init(suiteName: Config.sharedGroupName)
        var blockedWords = [String]()
        if let words = userDefaults?.array(forKey: Config.kBlockedWords) as? [String]{
            blockedWords.append(contentsOf: words)
        }
        return blockedWords
    }
    
    private func userSavedBlockedWords() -> [String]{
        let userDefaults = UserDefaults.standard
        var blockedWords = [String]()
        if let words = userDefaults.array(forKey: Config.kUserBlockedWords) as? [String]{
            blockedWords.append(contentsOf: words)
        }
        return blockedWords
    }
    
    private func saveBlockedWords(blockedWords:[String]){
        let userDefaults = UserDefaults.init(suiteName: Config.sharedGroupName)
        userDefaults?.set(blockedWords, forKey: Config.kBlockedWords)
        print("\nBlocked words: \(blockedWords)")
    }
    
    private func saveUserBlockedWords(blockedWords:[String]){
        let userDefaults = UserDefaults.standard
        userDefaults.set(blockedWords, forKey: Config.kUserBlockedWords)
    }
}
