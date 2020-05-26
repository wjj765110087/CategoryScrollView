//
//  HotDetailFooterView.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/24.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
// 

import Foundation

class HotDetailFooterView: UIView {
    
    @IBOutlet weak var downLoadBtn: UIButton!
    
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    var didClickDownLoaderHandeler: (() -> ())?
    
    var didClickLikeHandler: (() -> ())?
    
    var didClickShareHandler: (() -> ())?
    
    @IBAction func didClickBtn(_ sender: UIButton) {
        if sender == self.downLoadBtn {
            self.didClickDownLoaderHandeler?()
        }
        
        if sender == self.likeBtn {
            self.didClickLikeHandler?()
        }
        
        if sender == self.shareBtn {
            self.didClickShareHandler?()
        }
    }
}
