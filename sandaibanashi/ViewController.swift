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
    
    @IBOutlet var firstLabel : SpringLabel!
    @IBOutlet var secondLabel : SpringLabel!
    @IBOutlet var thirdLabel : SpringLabel!
    
    var strArray : [String] = []
    
    var myComposeView : SLComposeViewController!
    
    var item = [Dictionary<String, String>]()
    
    var parseKey = ""
    var titleStr = ""
    var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        randomWord()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        let req = NSURLRequest(URL: kizashiUrl!)
        let connection: NSURLConnection = NSURLConnection(request: req, delegate: self, startImmediately: false)!
        
        //NSURLConnectionを使いAPIを取得する
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: response)
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
        }else{
            parseKey = elementName
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?)
    {
        if index >= 0 {
            if parseKey == "title" {
                item[index]["title"] = item[index]["title"]! + string!
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
         parseKey = ""
    }
    
    func parserDidEndDocument(parser: NSXMLParser)
    {
        var x : Int
        var y : Int
        var z : Int
        
        do {
        x = Int(arc4random_uniform(30))
        y = Int(arc4random_uniform(30))
        z = Int(arc4random_uniform(30))
        } while x == y || y == z || z == x
        
        firstLabel.text = item[x]["title"]
        secondLabel.text = item[y]["title"]
        thirdLabel.text = item[z]["title"]
    }
    
    
    
    
    @IBAction func tweetButton(){
        
        // SLComposeViewControllerのインスタンス化.
        // ServiceTypeをTwitterに指定.
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        // 投稿するテキストを指定.
        myComposeView.setInitialText("Twitter Test from Swift #三題噺 #\(firstLabel.text!) #\(secondLabel.text!) #\(thirdLabel.text!)")
        
        // myComposeViewの画面遷移.
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }
    
}

