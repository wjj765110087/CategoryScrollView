//
//  ActivityCountDownView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class ActivityCountDownView: UIView {

    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var minuteLabel: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var statuLabel: UILabel!
    
    /// 懒加载 倒计时
    lazy var countdownTimer: WMCountDown = {
        return WMCountDown()
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func beiginCountDown(fromTime: String? = nil, endTime: String) {
        countdownTimer.stop()
        statuLabel.isHidden = true
        // 此闭包可以在本类任意方法中写
        countdownTimer.countDown = { [weak self] (d, h, m, s) in
//            let time = d + ":" + h + ":" + m + ":" + s
            //            self?.timeLabel.text = time
            self?.dayLabel.text = "\(d)天"
            self?.hourLabel.text = "\(h)时"
            self?.minuteLabel.text = "\(m)分"
            self?.secondLabel.text = "\(s)秒"
        }
        // 开始倒计时
        // 可以传递开始时间参数，用于计算倒计时时间差，不传，默认从系统当前时间开始计算时间差
//         countdownTimer.start(with: "2018-12-17 22:49:00", end: "2018-12-19 22:49:00")
        
        if let beginTime = fromTime, !beginTime.isEmpty {
              countdownTimer.start(with: beginTime, end: endTime)
        } else {
              countdownTimer.start(with: nil, end: endTime)
        }
    }
    
    func notBegin() {
        statuLabel.isHidden = false
        statuLabel.text = "活动未开始"
    }
    func isFinished() {
        statuLabel.isHidden = false
        statuLabel.text = "活动已结束"
    }
    
}

////VC中使用
//class ViewController: UIViewController {
//
//    /// 懒加载 倒计时
//    lazy var countdownTimer: WMCountDown = {
//        return WMCountDown()
//    }()
//
//    private lazy var activityCountDownView: ActivityCountDownView = {
//        guard let activityCountDownView = Bundle.main.loadNibNamed("ActivityCountDownView", owner: nil, options: nil)?.last as? ActivityCountDownView else {return ActivityCountDownView()}
//        return activityCountDownView
//    }()
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        countdownTimer.resume() // 恢复倒计时
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        countdownTimer.suspend() // 停止倒计时
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // 防止 Cell 重用时 仍在倒计时
//        countdownTimer.stop()
//        activityCountDownView.frame = CGRect(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 80)
//        view.addSubview(activityCountDownView)
//        activityCountDownView.countdownTimer = countdownTimer
//        activityCountDownView.beiginCountDown(fromTime: "2019-11-07 17:00:00", endTime: "2019-11-07 20:00:00 ")
//    }
//
//    // 销毁时应停止并销毁倒计时，节约线程开销
//    deinit {
//        countdownTimer.stop()
//    }
//}
