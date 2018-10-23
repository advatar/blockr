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
        let filterManager = MessageFilterManager()
        filterManager.manageOffensiveWords(addToList: sender.isOn)
    }
    
    
    private func setupSwitch(){
        if (UserDefaults.standard.object(forKey: kIsOnState) != nil) {
            self.offensiveWordsSwitch.isOn = UserDefaults.standard.bool(forKey: kIsOnState)
        }
    }
}
