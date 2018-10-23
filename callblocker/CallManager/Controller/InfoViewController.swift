//
//  InfoViewController.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/20/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
    }
    
    @IBAction func okPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
