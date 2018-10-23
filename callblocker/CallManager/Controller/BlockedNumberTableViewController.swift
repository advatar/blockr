//
//  BlockedNumberTableViewController.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/19/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import UIKit
import CallKit

class BlockedNumberTableViewController: UITableViewController {
    
    @IBOutlet weak var addNewNumberButtonItem: UIBarButtonItem!
    @IBOutlet weak var callBlockerStatusLabel: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    private let ctx = CoreDataStorage.mainQueueContext()
    private var infoViewController: InfoViewController!
    
    private var normalNumbers = [NumberViewModel]()
    private var blockedNumbers = [NumberViewModel]()
    private var suspiciousNumbers = [NumberViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(BlockedNumberTableViewController.checkCallDirectoryExtensionStatus), name: Notification.Name(kNotificationAppWillEnterForeground), object: nil)
        self.title = "Call Blocker"
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.01))
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        let moreInfoAttributedText = NSAttributedString(string: "More Info:", attributes:[.underlineStyle: NSUnderlineStyle.single.rawValue])
        moreInfoButton.setAttributedTitle(moreInfoAttributedText, for: .normal)
        checkCallDirectoryExtensionStatus()
        reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kNotificationAppWillEnterForeground), object: nil)
    }
    
    
    @IBAction func addNewNumberPressed(_ sender: Any) {
        let numberActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addNormalNumberAction = UIAlertAction(title: "Add Regular Number", style: .default) { (action) in
            self.addNewNumber(type: .normal)
        }
        let addBlockedNumberAction = UIAlertAction(title: "Add Number to Block", style: .default) { (action) in
            self.addNewNumber(type: .blocked)
        }
        let addSuspiciousNumberAction = UIAlertAction(title: "Add Suspicious Number", style: .default) { (action) in
            self.addNewNumber(type: .suspicious)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in}
        
        numberActionSheet.addAction(addNormalNumberAction)
        numberActionSheet.addAction(addBlockedNumberAction)
        numberActionSheet.addAction(addSuspiciousNumberAction)
        numberActionSheet.addAction(cancelAction)
        numberActionSheet.popoverPresentationController?.barButtonItem = addNewNumberButtonItem
        present(numberActionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func moreInfoPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        infoViewController = (storyboard.instantiateViewController(withIdentifier :"infoViewControllerId") as! InfoViewController)
        infoViewController.modalTransitionStyle = .crossDissolve
        infoViewController.modalPresentationStyle = .overFullScreen
        present(infoViewController, animated: true, completion: nil)
    }
    
    
    // MARK: private func
    
    private func reloadData(){
        if let normalNumber = PhoneNumber.fetchAll(type: .normal, context: ctx){
            self.normalNumbers = normalNumber
        }
        if let blockedNumbers = PhoneNumber.fetchAll(type: .blocked, context: ctx){
            self.blockedNumbers = blockedNumbers
        }
        if let suspiciousNumbers = PhoneNumber.fetchAll(type: .suspicious, context: ctx){
            self.suspiciousNumbers = suspiciousNumbers
        }
        self.tableView.reloadData()
        NumberManagerHelper.reloadCallDirectoryExtension()
    }
    
    @objc private func checkCallDirectoryExtensionStatus(){
        NumberManagerHelper.isCallDirectoryExtensionActive { (isActive) in
            DispatchQueue.main.async {
                self.callBlockerStatusLabel.text = isActive ? "Call Blocker is Active" : "Call Blocker is Not Active"
                self.moreInfoButton.isHidden = isActive
            }
        }
    }
    
    private func addNewNumber(type: NumberType){
        let alertController = UIAlertController(title: "New Number", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "1 111 111 1111"
            textField.keyboardType = .phonePad
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Description"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let number = alertController.textFields?[0].text, let intNumber = NumberManagerHelper.formatAndCheckPhoneNumber(phoneNumber: number) {
                var desc = alertController.textFields?[1].text
                desc = desc?.trimmingCharacters(in: .whitespaces)
                if desc?.count == 0 {
                    desc = nil
                }
                let ctx = CoreDataStorage.privateQueueContext()
                ctx.performAndWait {
                    _ = PhoneNumber.createOrUpdate(number: intNumber, desc: desc, type: type, ctx: ctx)
                    CoreDataStorage.saveContext(ctx)
                }
                DispatchQueue.main.async {
                    self.reloadData()
                }
            } else{
                self.displayError(error: "Please enter a valid phone number")
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
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return normalNumbers.count
        }
        if section == 1 {
            return blockedNumbers.count
        }
        if section == 2 {
            return suspiciousNumbers.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0  {
            if normalNumbers.count == 0 {
                return 0
            }
            return 30
        }
        if section == 1 {
            if blockedNumbers.count == 0 {
                return 0
            }
            return 30
        }
        if section == 2 {
            if suspiciousNumbers.count == 0 {
                return 0
            }
            return 0
        }
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0  {
            if normalNumbers.count == 0 {
                return nil
            }
            return "Regular Numbers"
        }
        if section == 1  {
            if blockedNumbers.count == 0 {
                return nil
            }
            return "Blocked Numbers"
        }
        if section == 2 {
            if suspiciousNumbers.count == 0 {
                return nil
            }
            return "Suspicious Numbers"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                let normalNumber = normalNumbers[indexPath.row]
                PhoneNumber.deleteNumber(number: normalNumber.phNumber, ctx: ctx)
                normalNumbers.remove(at: indexPath.row)
            } else if indexPath.section == 1 {
                let blockedNumber = blockedNumbers[indexPath.row]
                PhoneNumber.deleteNumber(number: blockedNumber.phNumber, ctx: ctx)
                blockedNumbers.remove(at: indexPath.row)
            } else if indexPath.section == 2{
                let suspiciousNumber = suspiciousNumbers[indexPath.row]
                PhoneNumber.deleteNumber(number: suspiciousNumber.phNumber, ctx: ctx)
                suspiciousNumbers.remove(at: indexPath.row)
            }
            self.tableView.reloadSections([indexPath.section], with: .automatic)
            NumberManagerHelper.reloadCallDirectoryExtension()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "numberTableViewCellID", for: indexPath) as! NumbersTableViewCell
        if indexPath.section == 0 {
            cell.numberViewModel = normalNumbers[indexPath.row]
        }
        else if indexPath.section == 1 {
            cell.numberViewModel = blockedNumbers[indexPath.row]
        } else {
            cell.numberViewModel = suspiciousNumbers[indexPath.row]
        }
        return cell
    }

}
