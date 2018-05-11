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
    let PrivateArray  = ["YES","NO"]
    let CategorySaveData = UserDefaults.standard
    var CategoryArray:[String] = []
    var CaregoryNum: Int = 0
    var PrivateNum: Int = 0
    
    
    //BookMark追加
    @IBAction func addbookmarkes(){
        
        let BookMark = Bookmark()
        BookMark.name = NameTextField.text!
        BookMark.URL = URLTextField.text!
        BookMark.time = NSDate()
        BookMark.PrivateNum = PrivateNum
        BookMark.CategoryNum = CaregoryNum
        
//        BookMarkArray.append(BookMark)
//        saveData.set(BookMarkArray, forKey: "BOOKMARKS")
        
        let realm = try! Realm()
        
        try! realm.write({
            realm.add(BookMark)
        })
        
        
        //リセット
        NameTextField.text = ""
        URLTextField.text = ""
        NameTextField.endEditing(true)
        URLTextField.endEditing(true)
        
        
//        //アイコン追加
//        
//        let webFrameY: CGFloat = 20
//        let webFrameWidth = self.view.frame.width
//        let webFrameHeight = self.view.frame.height - webFrameY
//        let webFrame = CGRect(x: 0, y: webFrameY, width: webFrameWidth, height: webFrameHeight)
//        testWeb = CustomWKWebView(frame: webFrame)
//        testWeb.delegate = self
//        testWeb.navigationDelegate = self
//        self.view.addSubview(testWeb)
//        
//        testWeb.loadURL(url: BookMark.URL)
//        
//        if iconImage != nil{
//            BookMark.Image = UIImagePNGRepresentation(iconImage)! as NSData
//        }
//        
        
        //Realm追加
        let  bookmarks = realm.objects(Bookmark.self)
        
        
        
//        if let bookmark = bookmarks.first {
//            print(bookmarks)
//            print(type(of: bookmarks))
//            print(bookmark)
//            print(type(of: bookmark))
//        }
        
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
