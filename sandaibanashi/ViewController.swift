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
    
    var myComposeView : SLComposeViewController!
    
    //　APIから取得したものを格納する用
    var item = [Dictionary<String, String>]()
    
    var parseKey = ""
    var titleStr = ""
    var index = -1
    
    //取ってきたものを一旦保存する用
    let saveItems = NSUserDefaults.standardUserDefaults()
    
    var myActivityIndicator: UIActivityIndicatorView!
    
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
        
        //UIActivityIndicaterを動作させる
        indicater()
        
    }
    
    //取得したAPIデータの処理
    func response(res: NSURLResponse!, data: NSData!, error: NSError!){
        
        if error != nil{
            
            //通信に失敗した時の処理
            readItem()
            //ランダムに３つ取り出す
            selectWord(readItem())
            
            
        }else{
            
            //通信に成功した時の処理
            var parser : NSXMLParser? = NSXMLParser(data: data)
            if parser != nil {
                // NSXMLParserDelegateをセット
                parser!.delegate = self;
                parser!.parse()
                
            }else{
                
                // パースに失敗した時
                readItem()
                //ランダムに３つ取り出す
                selectWord(readItem())
                
                
            }
        }
    }
    
    //パースを開始する時
    func parserDidStartDocument(parser: NSXMLParser)
    {
        
        index = -1
        item = [Dictionary<String, String>]()
        
    }
    
    //要素の開始タグを読み込んだ時
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject])
    {
        
        parseKey = ""
        
        if elementName == "item" {
            
            // Itemオブジェクトを保存するItems辞書を初期化
            titleStr = ""
            item.append([
                "title": ""
                ])
            index = item.count - 1
            
        }else{
            
            parseKey = elementName
            
        }
    }
    
    //タグの間の文字列を読み込んでいる時
    func parser(parser: NSXMLParser, foundCharacters string: String?)
    {
        
        if index >= 0 {
            
            //<title>の時だけ中身をitem辞書に入れていく
            if parseKey == "title" {
                
                item[index]["title"] = item[index]["title"]! + string!
                
            }
        }
    }
    
    //要素の閉じタグを読み込んだ時
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        
         parseKey = ""
        
    }
    
    //パースが終了した時
    func parserDidEndDocument(parser: NSXMLParser)
    {
        
        saveItem()
        selectWord(item)
        
    }
    
    //item辞書をNSUserDefaultsを使って保存
    func saveItem(){
        
        saveItems.setObject(item, forKey: "itemTitle")
        saveItems.synchronize()
        
    }
    
    //保存したものの取り出し
    func readItem() -> [Dictionary<String,String>]{
        
        let names = saveItems.objectForKey("itemTitle") as? [Dictionary<String,String>]
        
        return names!
    }
    
    //ラベルに表示させるものを選び、表示する
    func selectWord(dict : [Dictionary<String,String>]){
        
        var x : Int
        var y : Int
        var z : Int
        
        // 同じ数が被らないように乱数を発生させる
        do {
            x = Int(arc4random_uniform(30))
            y = Int(arc4random_uniform(30))
            z = Int(arc4random_uniform(30))
        } while x == y || y == z || z == x
        
        firstLabel.text = dict[x]["title"]
        secondLabel.text = dict[y]["title"]
        thirdLabel.text = dict[z]["title"]

        myActivityIndicator.stopAnimating()
    }
    
    //Indicatorの設定
    func indicater(){
        
        myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.frame = CGRectMake(0, 0, 100, 100)
        myActivityIndicator.center = self.view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        myActivityIndicator.color = UIColor.greenColor()
        
        myActivityIndicator.startAnimating()
        
        self.view.addSubview(myActivityIndicator)

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

