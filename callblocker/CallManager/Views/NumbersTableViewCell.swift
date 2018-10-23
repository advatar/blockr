//
//  NumbersTableViewCell.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/19/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import UIKit

class NumbersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var numberViewModel: NumberViewModel!{
        didSet {
            nameLabel.text = numberViewModel.numberFormatted
            detailLabel.text = numberViewModel.descStr
            statusImageView.image = UIImage.init(named: numberViewModel.imageStr)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        statusImageView.image = nil
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
