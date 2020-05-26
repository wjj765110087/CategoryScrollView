//
//  ChannelViewModel.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork

class ChannelViewModel: NSObject {
    
    var timesModels = [ChanleTimeModel]() /// 只存一个
    var channelCallback:(() ->())?
    
    func loadChannel() {
        let date1 = Date().timeIntervalSince1970 * 10000
        print("date1 ===== \(date1) == Float(date1) == \(Float(date1))")
        SwiftNetWorkManager.sharedInstance.getRequest("http://channel.lustai.me" + "/ping.txt", success: { (data) in
            let date2 = Date().timeIntervalSince1970 * 10000
            let timeC = Float64(date2) - Float64(date1)
            print("timeC1 ===== \(timeC)")
            let chanmodel = ChanleTimeModel.init(mothUrl: "http://channel.lustai.me", time: timeC, status: 1)
            self.timesModels.append(chanmodel)
            self.channelCallback?()
        }) { (error) in
            self.channelCallback?()
        }
    }
    private func loadChannel1() {
        let date1 = Date().timeIntervalSince1970 * 10000
        SwiftNetWorkManager.sharedInstance.getRequest("http://channel.littlebook.me" + "/ping.txt", success: { (data) in
            let date2 = Date().timeIntervalSince1970 * 10000
            let timeC = Float64(date2) - Float64(date1)
            print("timeC2===== \(timeC)")
            let chanmodel = ChanleTimeModel.init(mothUrl: "http://channel.littlebook.me", time: timeC, status: 1)
            if self.timesModels.count > 0 {
                if (self.timesModels[0].time ?? 0.00) > timeC {
                    self.timesModels.removeAll()
                    self.timesModels.append(chanmodel)
                }
            } else {
                self.timesModels.append(chanmodel)
            }
            self.loadChannel2()
        }) { (error) in
            self.loadChannel2()
        }
    }
    
    private func loadChannel2() {
        let date1 = Date().timeIntervalSince1970 * 10000
        SwiftNetWorkManager.sharedInstance.getRequest("http://channel.hnovel.me" + "/ping.txt", success: { (data) in
            let date2 = Date().timeIntervalSince1970 * 10000
            let timeC = Float64(date2) - Float64(date1)
            print("timeC3===== \(timeC)")
            let chanmodel = ChanleTimeModel.init(mothUrl: "http://channel.hnovel.me", time: timeC, status: 1)
            if self.timesModels.count > 0 {
                if (self.timesModels[0].time ?? 0.00) > timeC {
                    self.timesModels.removeAll()
                    self.timesModels.append(chanmodel)
                }
            } else {
                self.timesModels.append(chanmodel)
            }
            self.channelCallback?()
        }) { (error) in
            self.channelCallback?()
        }
   }
}
