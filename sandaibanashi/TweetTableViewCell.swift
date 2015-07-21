//
//  TweetTableViewCell.swift
//  sandaibanashi
//
//  Created by ryota-ko on 2015/07/21.
//  Copyright (c) 2015年 ryota-ko. All rights reserved.
//

import Foundation
import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet var usernameLabel: UILabel! = UILabel()
    @IBOutlet var timestampLabel: UILabel! = UILabel()
    @IBOutlet var tweetTextView: UITextView! = UITextView()
    @IBOutlet var firstLabel: UILabel! = UILabel()
    @IBOutlet var secondLabel: UILabel! = UILabel()
    @IBOutlet var thirdLabel: UILabel! = UILabel()
    
    required override convenience init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
