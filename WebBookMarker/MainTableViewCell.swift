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
    

    
    
    let checkImg = UIImage(named: "check")
    let nonCheckImg = UIImage(named: "Non-check")
    @IBAction func ChageCheck(){
        var BookMarks = realm.objects(Bookmark.self)
        if PrivateMode == false {
            BookMarks = realm.objects(Bookmark.self).filter(" PrivateNum == 0")
        }else{
            BookMarks = realm.objects(Bookmark.self)
        }
        if BookMarks[row].Read == 0 {
            try! self.realm.write() {
                BookMarks[row].Read = 1
            }
            Check.setImage(checkImg, for: .normal)
        }else{
            try! self.realm.write() {
                BookMarks[row].Read = 0
            }
            Check.setImage(nonCheckImg, for: .normal)
            
        }
        print(BookMarks)
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
