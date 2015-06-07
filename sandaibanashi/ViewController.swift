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

class ViewController: UIViewController,NSXMLParserDelegate {
    
    @IBOutlet var firstLabel : UILabel?
    @IBOutlet var secondLabel : UILabel?
    @IBOutlet var thirdLabel : UILabel?
    
    var strArray : [String] = []
    
    var myComposeView : SLComposeViewController!
    
    var accountStore = ACAccountStore()
    var twAccount : ACAccount?
    
    var item = [Dictionary<String, String>]()
    
    var parseKey = ""
    var titleStr = ""
    var index = -1
    
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
        
        
        var parser : NSXMLParser? = NSXMLParser(data: data)
        if parser != nil {
            // NSXMLParserDelegateをセット
            parser!.delegate = self;
            parser!.parse()
            
        } else {
            // パースに失敗した時
            println("failed to parse XML")
        }
        
    }
    
    func parserDidStartDocument(parser: NSXMLParser)
    {
        index = -1
        item = [Dictionary<String, String>]()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject])
    {
        parseKey = ""
        
        if elementName == "item" {
            // Itemオブジェクトを保存するItems配列を初期化
            titleStr = ""
            item.append([
                "title": ""
                ])
            index = item.count - 1
            NSLog("item一致したお")
            
        }else{
            parseKey = elementName
            NSLog("item一致してないお")
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?)
    {
        if index >= 0 {
            if parseKey == "title" {
                item[index]["title"] = item[index]["title"]! + string!
                NSLog("title一致したお")
                
            }
            NSLog("title一致してないお")
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
         parseKey = ""
    }
    
    func parserDidEndDocument(parser: NSXMLParser)
    {
        println("item = \(item.count)")
        println("\(item)")
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

