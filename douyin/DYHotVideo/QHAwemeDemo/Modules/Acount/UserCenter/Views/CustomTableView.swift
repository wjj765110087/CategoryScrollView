//
//  CustomTableView.swift
//  RootTabBarController
//
//  Created by mac on 2019/9/28.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class CustomTableView: UITableView {


}

extension CustomTableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            if otherGestureRecognizer.view != nil {
                if otherGestureRecognizer.view!.isKind(of: CustomcollectionView.self) || otherGestureRecognizer.view!.isKind(of: CommunityTableView.self) {
                    return true
                }
            }
        }
       return false
    }
}

class CustomcollectionView: UICollectionView {
    
    
}

extension CustomcollectionView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view != nil {
            if otherGestureRecognizer.view!.isKind(of: CustomTableView.self)  {
                return true
            }
        }
        return false
    }
}


class CommunityTableView: UITableView {
    
}
extension CommunityTableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            if otherGestureRecognizer.view != nil {
                if otherGestureRecognizer.view!.isKind(of: CustomTableView.self)  {
                    return true
                }
            }
        }
        return false
    }
}
