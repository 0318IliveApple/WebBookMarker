//
//  AddViewController.swift
//  WebBookMarker
//
//  Created by 中嶋裕也 on 2018/04/17.
//  Copyright © 2018年 中嶋裕也. All rights reserved.
//

import UIKit
import RealmSwift
import WebKit

class AddViewController: UIViewController, CustomWKWebDelegate, WKNavigationDelegate, URLSessionDownloadDelegate ,UIPickerViewDataSource ,UIPickerViewDelegate{
    
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var URLTextField: UITextField!
    @IBOutlet var SiteImageVies: UIImageView!
    @IBOutlet var CategoryPicker: UIPickerView!
    @IBOutlet var PrivatePicker: UIPickerView!
    
    var testWeb: CustomWKWebView!
    var iconImage: UIImage!
    let PrivateArray  = ["Non-Private","Private"]
    let CategorySaveData = UserDefaults.standard
    var CategoryArray:[String] = []
    var CaregoryNum: Int = 0
    var PrivateNum: Int = 0
    
    let realm = try! Realm()
    
    let PasswordSaveData = UserDefaults.standard
    
    
    
    @IBAction func changePassWord(){
        if PasswordSaveData != nil{
            let alert = UIAlertController(title: "パスワードを入力してください", message: "", preferredStyle: .alert)
            
            let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
                //キャンセルアクション
                (action:UIAlertAction!) -> Void in
            })
            let DoneAction:UIAlertAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: {
                (action:UIAlertAction!) -> Void in
                //OKアクション
                if alert.textFields != nil {
                    if self.PasswordSaveData.string(forKey: "PASSWORD") == alert.textFields![0].text! {
                        //パスワート正解
                        self.PasswordSaveData.set(alert.textFields![1].text, forKey: "PASSWORD")
                        
                    }else {
                        //パスワード不正解
                        let alertPass = UIAlertController(title: "パスワートが違います", message: "", preferredStyle: .alert)
                        alertPass.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertPass, animated: true, completion: nil)
                    }
                }
                
            })
            alert.addAction(CancelAction)
            alert.addAction(DoneAction)
            
            alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
                text.placeholder = "Old-Password"})
            alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
                text.placeholder = "New-Password"})
            
            present(alert, animated: true, completion: nil)
        }else{
            //パスワートを入力してください
            let alert_password = UIAlertController(title: "パスワードが設定されていません", message: "", preferredStyle: .alert)
            alert_password.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert_password, animated: true, completion: nil)
        }
    }
    //BookMark追加
    @IBAction func addbookmarkes(){
        var lastBookMarkID: Int = 0
        if realm.objects(Bookmark.self).last != nil{
            lastBookMarkID = realm.objects(Bookmark.self).last!.id
        }
        
        let BookMark = Bookmark()
        BookMark.name = NameTextField.text!
        BookMark.URL = URLTextField.text!
        BookMark.time = NSDate()
        BookMark.PrivateNum = PrivateNum
        BookMark.CategoryNum = CaregoryNum
        BookMark.Read = 0
        BookMark.id = lastBookMarkID + 1
        
//        BookMarkArray.append(BookMark)
//        saveData.set(BookMarkArray, forKey: "BOOKMARKS")
        if BookMark.URL == "" {
            let alert = UIAlertController(title: "URLを入力してください", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            if PasswordSaveData.object(forKey: "PASSWORD") == nil && BookMark.PrivateNum == 1{
                let alert = UIAlertController(title: "パスワードを設定してください", message: "パスワードを入力", preferredStyle: .alert)
        
                let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
                    //キャンセルアクション
                    (action:UIAlertAction!) -> Void in
                })
                let DoneAction:UIAlertAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: {
                    (action:UIAlertAction!) -> Void in
                    //OKアクション
                    if alert.textFields != nil {
                        self.PasswordSaveData.set(alert.textFields![0].text, forKey: "PASSWORD")
                    }
                    
                })
                alert.addAction(CancelAction)
                alert.addAction(DoneAction)
                
                alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
                    text.placeholder = "Password"})
                
                present(alert, animated: true, completion: nil)
            }else{
                let realm = try! Realm()
                
                try! realm.write({
                    realm.add(BookMark)
                })
                
                
                NameTextField.text = ""
                URLTextField.text = ""
                NameTextField.endEditing(true)
                URLTextField.endEditing(true)
            }
            
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
        if CategorySaveData.object(forKey: "CATEGORY") != nil {
            CategoryArray = CategorySaveData.array(forKey: "CATEGORY") as! [String]
        }
        
        CategoryPicker.delegate = self
        CategoryPicker.dataSource = self
        CategoryPicker.tag = 1
        
        PrivatePicker.delegate = self
        PrivatePicker.dataSource = self
        
//        if saveData.array(forKey: "BOOKMARKS") != nil{
//            BookMarkArray = saveData.array(forKey: "BOOKMARKS") as! [Bookmark]
//            // Do any additional setup after loading the view.
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //////////////////
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1{
            return 1
        }else{
            return 1
        }
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return CategoryArray.count
        }else {
            return PrivateArray.count
        }
        
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return CategoryArray[row]
        }else{
            return PrivateArray[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            CaregoryNum = row
        }else{
            PrivateNum = row
        }
    }
    
    //////////////
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
//アイコン取得用
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        testWeb.getIconImage()
    }
    
    func urlDidGet(customWebView: CustomWKWebView, arrURL: [URL]) {
        if arrURL.isEmpty == false{
            for temp in arrURL{
                download(url: temp)
            }
        }
    }
    
    func download(url: URL?){
        guard let url = url else{print("canceled"); return}
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        let task = defaultSession.downloadTask(with: url)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Downloaded: \(location)")
        var image: UIImage?
        do{
            let data = try Data(contentsOf: location)
            image = UIImage(data: data)
            iconImage = image
        }catch let error as NSError{
            print(error)
        }
    }

}
