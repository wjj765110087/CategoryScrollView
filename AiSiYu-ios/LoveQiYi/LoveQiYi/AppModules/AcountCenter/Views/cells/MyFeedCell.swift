//
//  MyFeedCell.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class MyFeedCell: UITableViewCell {

    static let cellId = "MyFeedCell"
    
    
    @IBOutlet weak var shodowView: UIView!
    
    @IBOutlet weak var titlelab: UILabel!
    @IBOutlet weak var timelab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
}
