//
//  WebViewViewController.swift
//  WebBookMarker
//
//  Created by 中嶋裕也 on 2018/04/27.
//  Copyright © 2018年 中嶋裕也. All rights reserved.
//

import UIKit
import WebKit


class WebViewViewController: UIViewController {
    
    @IBOutlet var WebView:UIWebView!
    
    
    
    var url:String!
    @IBOutlet var tes: UILabel!
    
    func loadURL() {
        
        guard let requestURL = URL(string: url)else{
            tes.text = "有効なURLではありません"
            return
        }
        
        if UIApplication.shared.canOpenURL(requestURL) {
            tes.text = ""
            let request = NSURLRequest(url: requestURL)
            WebView.loadRequest(request as URLRequest)
        }else {
            tes.text = "有効なURLではありません"
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadURL()
        // Do any additional setup after loading the view.
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
