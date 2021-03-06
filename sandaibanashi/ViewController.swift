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
import SWXMLHash
import Parse

class ViewController: UIViewController,UITextViewDelegate{
    
    //表示させるための3つのラベルを宣言
    @IBOutlet var firstLabel : SpringLabel!
    @IBOutlet var secondLabel : SpringLabel!
    @IBOutlet var thirdLabel : SpringLabel!
    
    //xmlのテキストを一旦保存する用
    let saveItems = NSUserDefaults.standardUserDefaults()
    
    //Indicatorの宣言
    var myActivityIndicator: UIActivityIndicatorView!
    
    //投稿内容
    @IBOutlet var tweetTextView: UITextView! = UITextView()
    
    @IBOutlet var scrollView : UIScrollView? = UIScrollView()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //API取得の関数を呼ぶ
        randomWord()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    //ラベルにアニメーションをさせる、API取得の関数を呼ぶ
    @IBAction func tapRandom(){
        
        firstLabel.animation = "swing"
        secondLabel.animation = "swing"
        thirdLabel.animation = "swing"
        firstLabel.animate()
        secondLabel.animate()
        thirdLabel.animate()
        randomWord()
        
    }
    

    //API取得の開始処理
    func randomWord(){
        
        let kizashiUrl = NSURL(string:"http://kizasi.jp/kizapi.py?type=rank")
        let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        //NSURLConnectionを使いAPIを取得する
        let task = session.dataTaskWithURL(kizashiUrl!, completionHandler: {
            (data, res, error) in
            
            if error != nil{
                //通信に失敗した時の処理
                //保存していたxmlテキストを読み込み、ランダムに３つ取り出す
                if self.saveItems.objectForKey("itemTitle") != nil{
                    self.selectWord(self.readItem())
                }
                
            }else{
                //通信に成功した時
                let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                let xml = SWXMLHash.parse(str as! String)
                self.saveItem(str!)
                self.selectWord(xml)
            }
        })
        //UIActivityIndicaterを動作させる
        indicater()
        task.resume()
    }
    
    
    //xmlのテキストをNSUserDefaultsを使って保存
    func saveItem(str : NSString){
        
        saveItems.setObject(str, forKey: "itemTitle")
        saveItems.synchronize()
        
    }
    
    
    //保存したものの取り出し
    func readItem() -> XMLIndexer {
        
        //保存していたxmlテキストを読み込み、XMLIndexerの型に変換
        let names = saveItems.objectForKey("itemTitle") as? NSString
        let xml = SWXMLHash.parse(names! as String)
        
        return xml
    }
    
    
    //ラベルに表示させるものを選び、表示する
    func selectWord(xml : XMLIndexer){
        
        var x,y,z : Int
        
        // 同じ数が被らないように乱数を発生させる
        repeat {
            x = Int(arc4random_uniform(30))
            y = Int(arc4random_uniform(30))
            z = Int(arc4random_uniform(30))
        } while x == y || y == z || z == x
        
        
        dispatch_async(dispatch_get_main_queue(), {
            
            //XMLの要素を取得しラベルへつっこむ
            self.firstLabel.text = xml["rss"]["channel"]["item"][x]["title"].element!.text!
            self.secondLabel.text = xml["rss"]["channel"]["item"][y]["title"].element!.text!
            self.thirdLabel.text = xml["rss"]["channel"]["item"][z]["title"].element!.text!
            
            //Indicatorを止める
            self.myActivityIndicator.stopAnimating()
            })
    }
    
    
    //Indicatorの設定
    func indicater(){
        
        myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.frame = CGRectMake(0, 0, 100, 100)
        myActivityIndicator.center = self.view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        myActivityIndicator.color = UIColor.greenColor()
        
        //Indicatorのアニメーションスタート
        myActivityIndicator.startAnimating()
        
        self.view.addSubview(myActivityIndicator)
        
    }
    
    
    @IBAction func tweetButton(){
        
        // Tweetする内容を保存する用のクラス
        let tweet:PFObject = PFObject(className: "Tweets")
        
        // ユーザーとTweet内容、３つのラベル用のカラムを作成。
        tweet["content"] = tweetTextView.text
        tweet["tweeter"] = PFUser.currentUser()
        tweet["first"] = firstLabel.text
        tweet["second"] = secondLabel.text
        tweet["third"] = thirdLabel.text
        
        
        // Parseに送信
        tweet.saveInBackground()
        
        // Tweet一覧が表示されるTimelineTableViewControllerに戻る
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        tweetTextView = textView
        return true
    }
    
    
    //改行ボタンが押された際に呼ばれるデリゲートメソッド.
    func textViewShouldReturn(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        
        return true
    }
    
    //画面がタップされた際にキーボードを閉じる処理
    func tapGesture(sender: UITapGestureRecognizer) {
        tweetTextView.resignFirstResponder()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
    }

    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        //キーボードの大きさ取得
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        //画面の大きさ取得
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        //textViewまでの距離を計算
        let txtLimit = tweetTextView.frame.origin.y + tweetTextView.frame.height + 8
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        if txtLimit >= kbdLimit {
            scrollView!.contentOffset.y = txtLimit - kbdLimit
            
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        scrollView!.contentOffset.y = 0
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

}

