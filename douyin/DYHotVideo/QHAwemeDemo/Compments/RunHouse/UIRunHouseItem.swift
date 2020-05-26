//
//  UIRunHouseItem.swift
//  QHAwemeDemo
//
//  Created by mac on 11/26/19.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 重用刷新协议，需要在重用时刷新的，只需要自己的item实现这个协议即可
protocol UIRunHouseItemProtocol {
    func prepareForReuse()
}
