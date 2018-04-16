//
//  MainTableViewCell.swift
//  WebBookMarker
//
//  Created by 中嶋裕也 on 2018/04/16.
//  Copyright © 2018年 中嶋裕也. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var URLLabel: UILabel!
    @IBOutlet var PageImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
