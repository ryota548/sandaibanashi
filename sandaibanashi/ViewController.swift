//
//  ViewController.swift
//  sandaibanashi
//
//  Created by ryota-ko on 2015/06/03.
//  Copyright (c) 2015年 ryota-ko. All rights reserved.
//

import UIKit
import Accounts
import Social

class ViewController: UIViewController {

    @IBOutlet var firstLabel : UILabel?
    @IBOutlet var secondLabel : UILabel?
    @IBOutlet var thirdLabel : UILabel?
    
    var strArray : [String] = []
    
    var myComposeView : SLComposeViewController!
    
    var accountStore = ACAccountStore()
    var twAccount : ACAccount?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapRandom(){
        randomWord()
    }
    
    //API取得の開始処理
    func randomWord(){
        
        let kizashiUrl = NSURL(string:"http://kizasi.jp/kizapi.py?type=rank")
        let req = NSURLRequest(URL: kizashiUrl!)
        let connection: NSURLConnection = NSURLConnection(request: req, delegate: self, startImmediately: false)!
        
        //NSURLConnectionを使いAPIを取得する
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: response)
        
        
        strArray.append("1")
        strArray.append("2")
        strArray.append("3")
        
        firstLabel!.text = strArray[0]
        secondLabel!.text = strArray[1]
        thirdLabel!.text = strArray[2]
        
        
        
        
        
    }
    
    //取得したAPIデータの処理
    func response(res: NSURLResponse!, data: NSData!, error: NSError!){
        
         var out:String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        
        //let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
        //let res:NSDictionary = json.objectForKey("item") as NSDictionary
        //let pref:NSArray = res.objectForKey("title") as NSArray
        
    
        //for var i=0 ; i<pref.count ; i++ {
            println(out)
        //}
    }
    
    @IBAction func tweetButton(){
        tweet()
    }
    
    func tweet(){
        
        // SLComposeViewControllerのインスタンス化.
        // ServiceTypeをTwitterに指定.
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        // 投稿するテキストを指定.
        myComposeView.setInitialText("Twitter Test from Swift #三題噺 #\(strArray[0]) #\(strArray[1]) #\(strArray[2])")
        
        // myComposeViewの画面遷移.
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }

}

