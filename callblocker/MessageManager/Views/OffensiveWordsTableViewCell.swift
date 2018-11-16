//
//  OffensiveWordsTableViewCell.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/23/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import UIKit

class OffensiveWordsTableViewCell: UITableViewCell {
    private let kIsOnState = "kIsOnState"
    private let ctx = CoreDataStorage.mainQueueContext()
    
    @IBOutlet weak var offensiveWordsSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSwitch()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: kIsOnState)
        for offensiveWord in offensiveWords{
            if sender.isOn {
                _ = BlockedWord.createOrUpdate(content: offensiveWord, type: .offensive, ctx: ctx)
            }
            else {
                BlockedWord.deleteWord(content: offensiveWord, ctx: ctx)
                
            }
        }
        CoreDataStorage.saveContext(ctx)
    }
    
    
    private func setupSwitch(){
        if (UserDefaults.standard.object(forKey: kIsOnState) != nil) {
            self.offensiveWordsSwitch.isOn = UserDefaults.standard.bool(forKey: kIsOnState)
        }
    }
}
