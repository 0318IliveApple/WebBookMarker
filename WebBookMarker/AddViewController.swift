//
//  AddViewController.swift
//  WebBookMarker
//
//  Created by 中嶋裕也 on 2018/04/17.
//  Copyright © 2018年 中嶋裕也. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var URLTextField: UITextField!
    @IBOutlet var SiteImageVies: UIImageView!
    
    
    var BookMarkArray: [Dictionary<String,String>] = []
    let saveData = UserDefaults.standard
    
//    class BookMarks {
//        var Name: String = "name"
//        var URL: String = "https://"
//        var SiteImage: UIImage!
//
//    }
    
    
    
    
    
    @IBAction func addbookmarkes(){
        
        let BookMarkDictionaly = ["Name":NameTextField.text!,"URL":URLTextField.text!]
        BookMarkArray.append(BookMarkDictionaly)
        saveData.set(BookMarkArray, forKey: "BOOKMARKS")
        
        
        NameTextField.text = ""
        URLTextField.text = ""
        NameTextField.endEditing(true)
        URLTextField.endEditing(true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if saveData.array(forKey: "BOOKMARKS") != nil{
            BookMarkArray = saveData.array(forKey: "BOOKMARKS") as! [Dictionary<String,String>]
        // Do any additional setup after loading the view.
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        if saveData.array(forKey: "BOOKMARKS") != nil{
            BookMarkArray = saveData.array(forKey: "BOOKMARKS") as! [Dictionary<String,String>]
            // Do any additional setup after loading the view.
        }
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
