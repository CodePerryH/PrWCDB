//
//  ListTableViewCell.swift
//  PrWCDB
//
//  Created by admin on 2022/2/9.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
