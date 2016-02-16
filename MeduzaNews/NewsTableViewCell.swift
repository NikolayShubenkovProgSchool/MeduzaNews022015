//
//  NewsTableViewCell.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 17/02/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var topRight: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
