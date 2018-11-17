//
//  MessageFilterTableViewController.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/23/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import UIKit

class MessageFilterTableViewController: UITableViewController {
    
    private let ctx = CoreDataStorage.mainQueueContext()
    private var userBlockedWords = [BlockedWord]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Message Filter"
        reloadData()
    }
    
    private func reloadData(){

        if let words = BlockedWord.fetchBy(type: .user, context: ctx){
            self.userBlockedWords = words
        }
        self.tableView.reloadData()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        addNewWord()
    }
    
    private func addNewWord(){
        let alertController = UIAlertController(title: "New Word", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let word = alertController.textFields?[0].text{
                let ctx = CoreDataStorage.privateQueueContext()
                ctx.performAndWait {
                    _ = BlockedWord.createOrUpdate(content: word, type: .user, ctx: ctx)
                    CoreDataStorage.saveContext(ctx)
                }
                DispatchQueue.main.async {
                    self.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func displayError(error: String){
        let alertController = UIAlertController(title: error, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return userBlockedWords.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Blocked words"
        }
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "offensiveWordsCellId", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedWordsCellID", for: indexPath) as! BlockerWordsTableViewCell
        let word = userBlockedWords[indexPath.row]
        cell.wordLabel.text = word.content
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedWord = userBlockedWords[indexPath.row]
            userBlockedWords.remove(at: indexPath.row)
            BlockedWord.deleteWord(content: deletedWord.content, ctx: ctx)
            reloadData()
        }
    }
}
