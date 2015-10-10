//
//  TimelineTableViewController.swift
//  sandaibanashi
//
//  Created by ryota-ko on 2015/07/21.
//  Copyright (c) 2015年 ryota-ko. All rights reserved.
//

import Foundation
import UIKit
import Parse

class TimelineTableViewController: UITableViewController {
    
    var timelineData:NSMutableArray = NSMutableArray()
    
    //Indicatorの宣言
    var myActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var currentUserName : UILabel!
    
    
    
    
    // Parseからデータの取得
    func loadData(){
        timelineData.removeAllObjects()
        
        //UIActivityIndicaterを動作させる
        indicater()
        
        // Tweetsテーブルを呼び出す
        let findTimelineData:PFQuery = PFQuery(className: "Tweets")
        
        
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?)->Void in
            
            if !(error != nil){
                for object in objects!{
                    self.timelineData.addObject(object)
                }
                
                self.tableView.reloadData()
                
                //Indicatorを止める
                self.myActivityIndicator.stopAnimating()
                
            }
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        
        //ログインされているかどうかを確かめる
        if ((PFUser.currentUser()) == nil) {
            self.currentUserName.text = "ログインできていません"
            let loginAlert:UIAlertController = UIAlertController(title: "Sign UP / Loign", message: "Plase sign up or login", preferredStyle: UIAlertControllerStyle.Alert)
            
            // ユーザーネームとパスワードの入力
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your username"
            })
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your Password"
                textfield.secureTextEntry = true
            })
            
            loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                
                let textFields:NSArray = loginAlert.textFields! as NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as! UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as! UITextField
                
                // ここでtweeterをユーザーの変数として作成
                let tweeter:PFUser = PFUser()
                
                // UITextFieldに入力された内容を代入
                tweeter.username = usernameTextfield.text
                tweeter.password = passwordTextfield.text
                
                //存在するユーザーかチェック
                let checkExist = PFUser.query()
                // usernameをキーにして検索
                checkExist!.whereKey("username", equalTo: tweeter.username!)
                checkExist!.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    if(objects!.count > 0){
                        
                        print("its username is already taken \(objects!.count)")
                        //すでにあるユーザーでログイン
                        self.signIn(tweeter.username!, password:tweeter.password!)
                        
                    } else {
                        
                        print("its username hasn't token yet. Let's register!")
                        //あらたにログイン
                        self.signUp(tweeter)
                        
                    }                       
                }
                self.currentUserName.text = "\(tweeter.username!)でログイン中"
                
            }))
            self.presentViewController(loginAlert, animated: true, completion: nil)
            
        }else{
            self.currentUserName.text = "\(PFUser.currentUser()!.username!)でログイン中"
            
        }
        
        // tweetのデータを取得
        self.loadData()
    }
    
    
    
    //サインイン
    func signIn(username:NSString, password:NSString) {
        
        PFUser.logInWithUsernameInBackground(username as String, password : password as String) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil{
                print("existed user")
                
            } else {
                print("not existed user")
                
            }
        }
    }
    
    
    
    //サインアップ
    func signUp(tweeter:PFUser) {
        
        tweeter.signUpInBackgroundWithBlock{
            
            (success:Bool, error:NSError?)->Void in
            
            if !(error != nil){
                print("Sign up succeeded.")
                
            }else{
                let errorString = error!.userInfo["error"] as? NSString
                print(errorString)
                
            }
        }
    }
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    //テーブルビューのセクションの数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    //tweetの数だけrowを返す
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineData.count
    }
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TweetTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TweetTableViewCell
        
        let tweet:PFObject = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        // 最初の透明度
        cell.tweetTextView.alpha = 0.3
        cell.timestampLabel.alpha = 0.3
        cell.usernameLabel.alpha = 0.3
        cell.firstLabel.alpha = 0.3
        cell.secondLabel.alpha = 0.3
        cell.thirdLabel.alpha = 0.3
        
        // Tweetの内容をParse.comから取得
        cell.tweetTextView.text = tweet.objectForKey("content") as! String
        cell.firstLabel.text = tweet.objectForKey("first") as? String
        cell.secondLabel.text = tweet.objectForKey("second") as? String
        cell.thirdLabel.text = tweet.objectForKey("third") as? String
        
        //投稿日時の取得フォーマットを指定して取得
        let dataFormatter:NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.timestampLabel.text = dataFormatter.stringFromDate(tweet.createdAt!)
        
        // objectIdをforeignKeyとして、user(tweeter)を取得
        let findTweeter:PFQuery = PFUser.query()!
        findTweeter.whereKey("objectId", equalTo: tweet.objectForKey("tweeter")!.objectId!!)
        
        findTweeter.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?)->Void in
            if !(error != nil){
                let user:PFUser = (objects! as NSArray).lastObject as! PFUser
                cell.usernameLabel.text = "@\(user.username!)"
                
                
                // CELLの表示にDurationをつけて、ほわっと表示する
                UIView.animateWithDuration(0.5, animations: {
                    cell.tweetTextView.alpha = 1
                    cell.timestampLabel.alpha = 1
                    cell.usernameLabel.alpha = 1
                    cell.firstLabel.alpha = 1
                    cell.secondLabel.alpha = 1
                    cell.thirdLabel.alpha = 1
                    
                })
            }
        }
        
        return cell
    }
    
    
    
    //Indicatorの設定
    func indicater(){
        
        myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.frame = CGRectMake(0, 0, 100, 100)
        myActivityIndicator.center = self.view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        myActivityIndicator.color = UIColor.yellowColor()
        
        myActivityIndicator.startAnimating()
        
        self.view.addSubview(myActivityIndicator)
    }

}
