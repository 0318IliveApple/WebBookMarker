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
    var CategoryArray:[String] = []
    let CategorySaveData = UserDefaults.standard
    @IBOutlet var SortButton: UIButton!
    
    
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
        navigationItem.rightBarButtonItem = editButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: animated)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        //        if saveData.array(forKey: "BOOKMARKS") != nil{
        //            BookMarkArray = saveData.array(forKey: "BOOKMARKS") as! [Bookmark]
        //        }
        
        if CategorySaveData.object(forKey: "CATEGORY") != nil {
            CategoryArray = CategorySaveData.array(forKey: "CATEGORY") as! [String]
        }
        
        //BOOKMARKS読み込み
        bookmarks = realm.objects(Bookmark.self)
        BookMarkArray = Array(bookmarks)
        print(bookmarks)
        tableView.reloadData()
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
        return BookMarkArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! MainTableViewCell
        
        // Cellの表示
        let nowIndexPath = BookMarkArray[indexPath.row]
        cell.NameLabel.text = nowIndexPath.name
        cell.URLLabel.text = nowIndexPath.URL
        if CategoryArray.count > nowIndexPath.CategoryNum {
            //out of range 防止
            cell.CategoryLabel.text = CategoryArray[nowIndexPath.CategoryNum]
        }
        
        
        cell.row = indexPath.row
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
            self.BookMarkArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.bookmarks = self.realm.objects(Bookmark.self)
            let pre = self.bookmarks[indexPath.row]
            
            
            // さようなら・・・
            try! self.realm.write() {
                self.realm.delete(pre)
            }
            
            
            
            //            self.saveData.set(self.BookMarkArray, forKey: "BOOKMARKS")
            
            
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    //画面遷移
    override func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        // SubViewController へ遷移するために Segue を呼び出す
        
        let selectedDic = BookMarkArray[indexPath.row].URL
        
        try! self.realm.write() {
            bookmarks[indexPath.row].Read = 1
        }
        tableView.reloadData()
        
        performSegue(withIdentifier: "toWebSegue", sender: selectedDic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewViewController
        webViewController.url = sender as! String
    }
    
    //Sort
    
    @IBAction func Sort(){
        let alert = UIAlertController(title: "並べ替え", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "日付", style: .default, handler: { ACTION in
            //カテゴリ順ソート
            self.SortButton.setTitle("日付順", for: .normal)
            self.BookMarkArray.sort(by: { $0.time.compare($1.time as Date) == ComparisonResult.orderedDescending})
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "カテゴリ", style: .default, handler: { ACTION in
            //カテゴリ順ソート
            self.SortButton.setTitle("カテゴリ順", for: .normal)
            self.BookMarkArray.sort(by: { $0.CategoryNum < $1.CategoryNum })
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "完了", style: .default, handler: { ACTION in
            //カテゴリ順ソート
            self.SortButton.setTitle("完了順", for: .normal)
            self.BookMarkArray.sort(by: { $0.Read < $1.Read })
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { ACTION in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
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
