//
//  MainTableViewCell.swift
//  WebBookMarker
//
//  Created by 中嶋裕也 on 2018/04/16.
//  Copyright © 2018年 中嶋裕也. All rights reserved.
//

import UIKit
import RealmSwift

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var URLLabel: UILabel!
    @IBOutlet var PageImage: UIImageView!
    @IBOutlet var CategoryLabel: UILabel!
    @IBOutlet var Check:UIButton!
    @IBOutlet var PrivateImage:UIImageView!
    
    var row: Int!
    let realm = try! Realm()
    var PrivateMode:Bool!
    var id: Int!

    
    
    let checkImg = UIImage(named: "check")
    let nonCheckImg = UIImage(named: "Non-check")
    @IBAction func ChageCheck(){
        let selectedBookMark = self.realm.objects(Bookmark.self).filter("id == %@", id)

        if selectedBookMark[0].Read == 0 {
            try! self.realm.write() {
                selectedBookMark[0].Read = 1
            }
            Check.setImage(checkImg, for: .normal)
        }else{
            try! self.realm.write() {
                selectedBookMark[0].Read = 0
            }
            Check.setImage(nonCheckImg, for: .normal)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //bookmarks = realm.objects(Bookmark.self)
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
