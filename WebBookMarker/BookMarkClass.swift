//
//  BookMarkClass.swift
//  WebBookMarker
//
//  Created by 中嶋裕也 on 2018/04/28.
//  Copyright © 2018年 中嶋裕也. All rights reserved.
//

import Foundation
import RealmSwift


class Bookmark: Object {
    @objc dynamic var num_private:Int = 0
    @objc dynamic var name:String = ""
    @objc dynamic var URL:String = ""
    @objc dynamic var time = NSDate()
    @objc dynamic var Image:String = ""
}

