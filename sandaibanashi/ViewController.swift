//
//  ViewController.swift
//  sandaibanashi
//
//  Created by ryota-ko on 2015/06/03.
//  Copyright (c) 2015年 ryota-ko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var firstLabel : UILabel?
    @IBOutlet var secondLabel : UILabel?
    @IBOutlet var thirdLabel : UILabel?
    

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
    
    func randomWord(){
        firstLabel!.text = "1"
        secondLabel!.text = "1"
        thirdLabel!.text = "1"
        
    }
    
    

}

