//
//  MainTableViewController.swift
//  WebBookMarker
//
//  Created by 中嶋裕也 on 2018/04/16.
//  Copyright © 2018年 中嶋裕也. All rights reserved.
//

import UIKit
import RealmSwift

extension NSDate: Comparable {}

//比較
public func <(before: NSDate, after: NSDate) -> Bool {
    return before.compare(after as Date) == .orderedAscending
}
class MainTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var bookmarks: Results<Bookmark>! = nil
    var BookMarkArray: [Bookmark] = []
    var PrivateBookMarkArray: [Bookmark] = []
    var CategoryArray:[String] = []
    let CategorySaveData = UserDefaults.standard
    var SortedNum:Int = 0
    var PrivateMode:Bool = false
    let PasswordSaveData = UserDefaults.standard
    @IBOutlet var SortButton: UIButton!
    @IBOutlet var CangePrivateButton: UIButton!
    
    
    //    CustomWKWebDelegate
    //    func urlDidGet(customWebView: CustomWKWebView, arrURL: [URL]) {
    //        if arrURL.isEmpty == false{
    //            for temp in arrURL{
    //                download(url: temp)
    //            }
    //        }
    //    }
    
    
    //    var BookMarkArray: [Bookmark] = []
    //    let saveData = UserDefaults.standard
    
    //編集ボタンの追加
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        //        navigationItem.rightBarButtonItem = editButtonItem
        //        navigationItem.rightBarButtonItem?.title = "削除"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //    override func setEditing(_ editing: Bool, animated: Bool) {
    //        super.setEditing(editing, animated: animated)
    //
    //        tableView.setEditing(editing, animated: animated)
    //        navigationItem.rightBarButtonItem?.title = "削除"
    //    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        //        if saveData.array(forKey: "BOOKMARKS") != nil{
        //            BookMarkArray = saveData.array(forKey: "BOOKMARKS") as! [Bookmark]
        //        }
        
        if CategorySaveData.object(forKey: "CATEGORY") != nil {
            CategoryArray = CategorySaveData.array(forKey: "CATEGORY") as! [String]
        }
        
        //BOOKMARKS読み込み
        
        
        if PrivateMode == false {
            bookmarks = realm.objects(Bookmark.self).filter(" PrivateNum == 0")
            BookMarkArray = Array(bookmarks)
            self.sort(num: self.SortedNum)
            tableView.reloadData()
            CangePrivateButton.setImage(UIImage(named: "Lock"), for: .normal)
            
        }else {
            bookmarks = realm.objects(Bookmark.self)
            PrivateBookMarkArray = Array(bookmarks)
            self.sort(num: self.SortedNum)
            tableView.reloadData()
            self.CangePrivateButton.setImage(UIImage(named: "unLock"), for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if PrivateMode == false {
            return BookMarkArray.count
        } else {
            return PrivateBookMarkArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! MainTableViewCell
        
        // Cellの表示
        var nowIndexPath: Bookmark

        if PrivateMode == true {
            nowIndexPath = PrivateBookMarkArray[indexPath.row]
        }else{
            nowIndexPath = BookMarkArray[indexPath.row]
        }
        cell.BookMarkArray = self.BookMarkArray
        cell.PrivateBookMarkArray = self.PrivateBookMarkArray
        cell.NameLabel.text = nowIndexPath.name
        cell.URLLabel.text = nowIndexPath.URL
        if CategoryArray.count > nowIndexPath.CategoryNum {
            //out of range 防止
            cell.CategoryLabel.text = CategoryArray[nowIndexPath.CategoryNum]
        }
        
        //鍵表示
        if nowIndexPath.PrivateNum == 1{
            cell.PrivateImage.isHidden = false
            cell.PrivateImage.image = UIImage(named: "Lock")
        }else{
            cell.PrivateImage.isHidden = true
        }
        
        
        cell.row = indexPath.row
        cell.PrivateMode = self.PrivateMode
        cell.id = nowIndexPath.id
        //画像表示
        let checkImg = UIImage(named: "check")
        let nonCheckImg = UIImage(named: "Non-check")
        if nowIndexPath.Read == 0 {
            cell.Check.setImage(nonCheckImg, for: .normal)
        }else{
            cell.Check.setImage(checkImg, for: .normal)
        }
        
        //        var iconimage = UIImage(data: nowIndexPath.Image as Data)
        //        iconimage = UIImage(data: nowIndexPath.Image as Data)
        //        cell.PageImage = UIImageView(image: iconimage)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //削除機能
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            var id:Int!
            if self.PrivateMode == false {
                id = self.BookMarkArray[indexPath.row].id
                self.BookMarkArray.remove(at: indexPath.row)
            }else{
                id = self.PrivateBookMarkArray[indexPath.row].id
                self.PrivateBookMarkArray.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            let selectedBookMark = self.realm.objects(Bookmark.self).filter("id == %@", id)
            
            // さようなら・・・
            try! self.realm.write() {
                self.realm.delete(selectedBookMark[0])
            }
            
            self.reloadarray()
            self.sort(num: self.SortedNum)
            
            //            self.saveData.set(self.BookMarkArray, forKey: "BOOKMARKS")
            
            
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    //画面遷移
    override func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        // SubViewController へ遷移するために Segue を呼び出す
        
        
        var id:Int!
        if PrivateMode == false {
            id = self.BookMarkArray[indexPath.row].id
        }else{
            id = self.PrivateBookMarkArray[indexPath.row].id
        }
        print(BookMarkArray)
        print("############################")
        print(id)
        print("############################")
        let selectedBookMark = realm.objects(Bookmark.self).filter("id == %@", id)
        try! self.realm.write() {
            selectedBookMark[0].Read = 1
        }
        let selectedURL = selectedBookMark[0].URL
        reloadarray()
        self.sort(num: self.SortedNum)
        performSegue(withIdentifier: "toWebSegue", sender: selectedURL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewViewController
        webViewController.url = sender as! String
    }
    
    //Privatemode
    
    @IBAction func ChangePrivate() {
        
        if PrivateMode == false {
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
                        self.CangePrivateButton.setImage(UIImage(named: "unLock"), for: .normal)
                        self.PrivateMode = true
                        self.reloadarray()
                        self.sort(num: self.SortedNum)
                        
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
                text.placeholder = "Password"})
            
            present(alert, animated: true, completion: nil)
            
        }else {
            self.CangePrivateButton.setImage(UIImage(named: "Lock"), for: .normal)
            PrivateMode = false
            
        }
        
    }
    
    //Sort
    
    
    @IBAction func Sort(){
        let alert = UIAlertController(title: "並べ替え", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "日付　降順", style: .default, handler: { ACTION in
            self.SortedNum = 0
            self.sort(num: self.SortedNum)
        }))
        
        alert.addAction(UIAlertAction(title: "日付　昇順", style: .default, handler: { ACTION in
            self.SortedNum = 1
            self.sort(num: self.SortedNum)
        }))
        
        alert.addAction(UIAlertAction(title: "カテゴリ", style: .default, handler: { ACTION in
            self.SortedNum = 2
            self.sort(num: self.SortedNum)
        }))
        
        alert.addAction(UIAlertAction(title: "完了", style: .default, handler: { ACTION in
            self.SortedNum = 3
            self.sort(num: self.SortedNum)
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { ACTION in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func reloadarray(){
        if PrivateMode == false {
            bookmarks = realm.objects(Bookmark.self).filter(" PrivateNum == 0")
            BookMarkArray = Array(bookmarks)
        }else {
            bookmarks = realm.objects(Bookmark.self)
            PrivateBookMarkArray = Array(bookmarks)
        }
        
        self.sort(num: self.SortedNum)
        tableView.reloadData()
    }
    
    func sort(num:Int) -> Void{
        if num == 0 {
            //日付　降順
            self.SortButton.setTitle("日付順　降順", for: .normal)
            self.BookMarkArray.sort(by: { $0.time.compare($1.time as Date) == ComparisonResult.orderedDescending})
            self.PrivateBookMarkArray.sort(by: { $0.time.compare($1.time as Date) == ComparisonResult.orderedDescending})
            self.tableView.reloadData()
        }else if num == 1 {
            //日付　昇順
            self.SortButton.setTitle("日付　昇順", for: .normal)
            self.BookMarkArray.sort(by: { $0.time.compare($1.time as Date) == ComparisonResult.orderedDescending})
            self.PrivateBookMarkArray.sort(by: { $0.time.compare($1.time as Date) == ComparisonResult.orderedDescending})
            self.BookMarkArray.reverse()
            self.PrivateBookMarkArray.reverse()
            self.tableView.reloadData()
        }else if num == 2 {
            //カテゴリ順ソート
            self.SortButton.setTitle("カテゴリ順", for: .normal)
            self.BookMarkArray.sort(by: { $0.CategoryNum < $1.CategoryNum })
            self.PrivateBookMarkArray.sort(by: { $0.CategoryNum < $1.CategoryNum })
            self.tableView.reloadData()
            print(BookMarkArray)
        }else if num == 3 {
            //完了順ソート
            self.SortButton.setTitle("完了順", for: .normal)
            self.BookMarkArray.sort(by: { $0.Read < $1.Read })
            self.PrivateBookMarkArray.sort(by: { $0.Read < $1.Read })
            self.tableView.reloadData()
            print(BookMarkArray)
        }
    }
    
    
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: indexPath) ->UITableView{
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" ,for: indexPath) as! MainTableViewCell
    //
    //        cell.NameLabel()
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
