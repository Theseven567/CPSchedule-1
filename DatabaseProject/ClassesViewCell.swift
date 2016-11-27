//
//  ClassesViewCell.swift
//  DatabaseProject
//
//  Created by Егор on 11/16/16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import UIKit

class ClassesViewCell: UITableViewCell {

    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
