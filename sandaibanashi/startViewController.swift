//
//  ViewController.swift
//  sandaibanashi
//
//  Created by ryota-ko on 2015/06/03.
//  Copyright (c) 2015年 ryota-ko. All rights reserved.
//

import UIKit
import Parse

class startViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //概要
    @IBAction func setumei(sender: UIButton){
        let alertController = UIAlertController(title: "三題噺？", message: "落語の形態の一つで，観客に適当な言葉・題目を出させ，出された題目3つを折り込んで即興で演じる落語である．\n一つを「オチ」に使わないといけない．", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK!", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    
    }
    
    
    //オチのつけかた
    @IBAction func ochi(sender: UIButton){
        let alertController = UIAlertController(title: "オチの種類", message: "「どんでん返し」\n最後の最後でストーリーをひっくり返す.\n「タネ明かし」\n最後の最後でネタばらしをする.いかに意外性を持たせるか.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK!", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

}

