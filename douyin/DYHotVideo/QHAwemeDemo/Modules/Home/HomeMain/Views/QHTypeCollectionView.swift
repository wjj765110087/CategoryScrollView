//
//  QHTypeCollectionView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class QHTypeCollectionView: UICollectionView {

    var didClickTypeKeysCell: (()->())?

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view is QHTypeCollectionView {
            didClickTypeKeysCell?()
        }
        return view
    }

}
