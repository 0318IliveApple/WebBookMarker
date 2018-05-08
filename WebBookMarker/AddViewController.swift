//
//  AddViewController.swift
//  WebBookMarker
//
//  Created by 中嶋裕也 on 2018/04/17.
//  Copyright © 2018年 中嶋裕也. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
    
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var URLTextField: UITextField!
    @IBOutlet var SiteImageVies: UIImageView!
    @IBOutlet var CategoryPicker: UIPickerView!
    @IBOutlet var PrivatePicker: UIPickerView!
    
    
    let saveData = UserDefaults.standard
    
//    var BookMarkArray:[Bookmark] = []
    
    
    @IBAction func addbookmarkes(){
        
        let BookMark = Bookmark()
        BookMark.num_private = 0
        BookMark.name = NameTextField.text!
        BookMark.URL = URLTextField.text!
        BookMark.time = NSDate()

//        BookMarkArray.append(BookMark)
//        saveData.set(BookMarkArray, forKey: "BOOKMARKS")
        
        let realm = try! Realm()
        
        try! realm.write({
            realm.add(BookMark)
        })
        
        
        NameTextField.text = ""
        URLTextField.text = ""
        NameTextField.endEditing(true)
        URLTextField.endEditing(true)
        
        let  bookmarks = realm.objects(Bookmark.self)
        if let bookmark = bookmarks.first {
            print("############################")
            print(bookmarks)
            print(type(of: bookmarks))
            print(bookmark)
            print(type(of: bookmark))
            print("############################")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if saveData.array(forKey: "BOOKMARKS") != nil{
//            BookMarkArray = saveData.array(forKey: "BOOKMARKS") as! [Bookmark]
//        // Do any additional setup after loading the view.
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
//        if saveData.array(forKey: "BOOKMARKS") != nil{
//            BookMarkArray = saveData.array(forKey: "BOOKMARKS") as! [Bookmark]
//            // Do any additional setup after loading the view.
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
