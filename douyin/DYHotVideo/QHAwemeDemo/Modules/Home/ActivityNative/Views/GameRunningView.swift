//
//  GameRunningView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-19.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import AVKit
import Foundation

class GameRunningView: UIView {
    
    @IBOutlet weak var centerBgImg: UIImageView!
    @IBOutlet weak var centerGifShowImg: UIImageView!
    @IBOutlet weak var centerGiftName: UILabel!
    
    let colorName:[String] = ["game_YellowItem", "game_RedItem", "game_BlueItem", "game_YellowItem", "game_GreenItem","game_RedItem", "game_YellowItem", "game_RedItem", "game_GreenItem", "game_YellowItem", "game_BlueItem", "game_YellowItem","game_RedItem","game_GreenItem","game_BlueItem", "game_GreenItem","game_RedItem","game_BlueItem"]
    
    var allButtons = [UIView]()
    var index: Int = 0
    var isEnd: Bool = false
    /// 多少秒跳一格
    var speel: TimeInterval = 0.05
    /// 衰减速度。
    var weakenSpeel: TimeInterval = 0.05
    var player: AVPlayer?
    var endingBlock:(() ->Void)?
    
    /// 是否押注
    var isStaked: Bool = false
    /// 是否中奖
    var isWin: Bool = false
    /// 中奖号码
    var result: Int = 1
    
    /// 记录奇偶
    var timeInt = 0
    var timer: Timer?
    /// Datas
    var gameData: GameMainModel?
    var winProp: PropsModel?
    /// 中奖号码 押了多少倍
    var propNumBall: Int = 0
    
    deinit {
        timer?.invalidate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 0 ..< self.subviews.count {
            let view = self.subviews[i]
            if view.isKind(of: GameRunItemView.self) && view.tag > 0 && view.tag < 19 {
                view.layer.borderWidth = (screenWidth-70)/12
                view.layer.borderColor = UIColor.clear.cgColor
                allButtons.append(view)
            }
        }
        allButtons = allButtons.sorted { (view1, view2) -> Bool in
            return view1.tag < view2.tag
        }
        for i in 0 ..< allButtons.count {
            let button = allButtons[i]
            (button as! GameRunItemView).setBackgroundImage(UIImage(named: colorName[i]), for: .normal)
        }
        centerGiftName.text = "10金币押一次 赢道具兑大奖"
    }
    
    /// 数据与后台对接
    func setGameModel(_ gameData: GameMainModel) {
        self.gameData = gameData
        if let gameInfo = gameData.activity_info {
            centerGiftName.text = "\(gameInfo.game_coins ?? "10")金币押一次 赢道具兑大奖"
        }
        if let propsModels = gameData.game_data, propsModels.count > 0 {
            if propsModels.count != allButtons.count {
                print("propsModels.count == \(propsModels.count), allButtons.count = \(allButtons.count)")
                XSAlert.show(type: .error, text: "道具数量和游戏机上格子数量不一致！")
                return
            }
            for i in 0 ..< propsModels.count {
                let button = allButtons[i]
                let model = propsModels[i]
                (button as! GameRunItemView).pictureBtn.kfSetHeaderImageWithUrl(model.props_img, placeHolder: UIImage(named: "babyGame"))
                (button as! GameRunItemView).beiLabel.text = "X\(model.props_nbets ?? 1)"
            }
        }
    }
    
    func resetAllParameter() {
        centerGifShowImg.image = UIImage(named: "game_centerNormalIcon")
        if let gameInfo = gameData?.activity_info {
            centerGiftName.text = "\(gameInfo.game_coins ?? "10")金币押一次 赢道具兑大奖"
        }
        centerBgImg.image = UIImage(named: "game_centerNormalBg")
        speel = 0.05           /// 重置速度
        isEnd = false         /// 重置开关
        timer?.invalidate()
        timeInt = 0
    }
    
    func star() {
        for view in allButtons {
            view.backgroundColor = UIColor.green
            view.layer.borderColor = UIColor.clear.cgColor
            (view as! GameRunItemView).lightImage.isHidden = true
        }
        /// 重置参数
        resetAllParameter()
        run(index: self.index)
        playMp3(startMp3Path())
        /// 加转4秒
        self.sleep(4.0) {
            self.speel = 0.15
            print("后台说中了这个数字： ===== \(self.result) self.allButtons[self.index].tag = \(self.allButtons[self.index].tag)")
            self.player?.pause()
            if self.allButtons[self.index].tag == self.result {  // 避免直接就停止的情况  闪灯/开火车
                self.perform(#selector(self.stop), with: nil, afterDelay: 0.5)
            } else {
                self.fixWeakenSpeed()
                self.stop()
            }
        }
    }
    
    func run(index: Int) {
        UIView.animate(withDuration: speel, animations: {
            self.allButtons[index].backgroundColor = UIColor.red
            self.allButtons[index].layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
            (self.allButtons[index] as! GameRunItemView).lightImage.isHidden = false
        }) { (finis) in
            if self.index == self.allButtons.count - 1 { // 最后一个
                self.index = 0
            } else {
                self.index += 1
            }
            if !self.isEnd {
                self.allButtons[index].backgroundColor = UIColor.green
                self.allButtons[index].layer.borderColor = UIColor.clear.cgColor
                (self.allButtons[index] as! GameRunItemView).lightImage.isHidden = true
                self.run(index: self.index)
            } else {
                if self.allButtons[index].tag != self.result {   /// 得到结果
                    self.allButtons[index].backgroundColor = UIColor.green
                    self.allButtons[index].layer.borderColor = UIColor.clear.cgColor
                    (self.allButtons[index] as! GameRunItemView).lightImage.isHidden = true
                    if self.speel < 0.6 {
                        self.speel += self.weakenSpeel
                    }
                    self.endSound()
                    self.run(index: self.index)
                } else {
                    self.allButtons[index].backgroundColor = UIColor.red
                    self.allButtons[index].layer.borderColor = UIColor.clear.cgColor
                    (self.allButtons[index] as! GameRunItemView).lightImage.isHidden = false
                    /// 这里判断是否中奖 （判断押注中 是否有押 result ）
                    self.fixResult()
                    self.endingBlock?()
                }
            }
        }
    }
    
    func fixResult() {
        /// 未押注
        if !isStaked {
            notStakedAction()
            return
        }
        /// 未中奖
        if !isWin {
            loseAction()
            return
        }
        /// 中奖
        winAction()
        
    }
    
    /// 未押注，空转
    func notStakedAction() {
        centerGiftName.text = "需先下注哦！"
    }
    
    /// 中奖后调用
    func winAction() {
        centerGifShowImg.kfSetHeaderImageWithUrl(winProp?.props_img, placeHolder: nil)
        if let bei = winProp?.props_nbets, bei > 0 {
            centerGiftName.text = "\(winProp?.props_name ?? "")X\(bei*propNumBall)"
        }
        flashAnimation()
    }
    
    /// 未中奖调用
    func loseAction() {
        centerGifShowImg.image = UIImage(named: "game_loseCenter")
        centerBgImg.image = UIImage(named: "game_centerHLBG")
        centerGiftName.text = "很遗憾你和奖品只差一丢丢"
    }
    
    /// 计算衰减速度
    func fixWeakenSpeed() {
        var weakenRunItemCount: Int = 0
        if self.allButtons[self.index].tag > self.result { ///中奖号码在后面
            print("衰减后跳动次数为=== \(18 - self.allButtons[self.index].tag + self.result)")
            weakenRunItemCount = 18 - self.allButtons[self.index].tag + self.result
        } else if self.result > self.allButtons[self.index].tag {
            print("<衰减后跳动次数为>=== \(self.result - self.allButtons[self.index].tag)")
            weakenRunItemCount = self.result - self.allButtons[self.index].tag
        }
        let everyItemTime = (0.6 - 0.15)/Float(weakenRunItemCount)
        weakenSpeel = TimeInterval(everyItemTime)
        print("weakenSpeel   ===== \(weakenSpeel)")
    }
    
    @objc func stop() {
        isEnd = true
    }
}

// MARK: - 视频展示
private extension GameRunningView {
    
    func startMp3Path() -> String {
        guard let path = Bundle.main.path(forResource: "laohu3", ofType: ".mp3") else { return ""}
        return path
    }
    
    func endMp3Path() -> String {
        guard let path = Bundle.main.path(forResource: "laohu2", ofType: ".mp3") else { return ""}
        return path
    }
    
    func playMp3(_ path: String) {
        
        let videoURL = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: videoURL)
        //监听播放器进度
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        let player = AVPlayer(playerItem: playerItem)
        //开始播放
        player.play()
        self.player = player
    }
    
    func flashAnimation() {
        timer = Timer.every(0.5.second, { (timer) in
            self.timeInt += 1
            self.changeCenterBackGround()
        })
    }
    func changeCenterBackGround() {
        if timeInt >= 10000 {
            timer?.invalidate()
            return
        }
        if self.timeInt % 2 == 0 {
            self.centerBgImg.image = UIImage(named: "game_centerHLS")
        } else {
            self.centerBgImg.image = UIImage(named: "game_centerHLBG")
        }
    }
    
    @objc func playerDidFinishPlaying(_ notiffcation: Notification) {
        if let item = notiffcation.object as? AVPlayerItem {
            item.seek(to: CMTime.zero)
            self.player?.play()
        }
    }
    
    // MARK: - APP将要被挂起
    /// - Parameter sender: 记录被挂起前的播放状态，进入前台时恢复状态
    @objc func applicationResignActivity(_ sender: NSNotification) {
        self.player?.pause()
    }
    
    // MARK: - APP进入前台，恢复播放状态
    @objc func applicationBecomeActivity(_ sender: NSNotification) {
        self.player?.play()
        
    }
    
    /// -结束
    func endSound() -> Void {
        var soundID: SystemSoundID = 0
        let soundFile = Bundle.main.path(forResource: "laohu2", ofType: "mp3")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: soundFile!) as  CFURL, &soundID)
        //播放提示音 带有震动
        //AudioServicesPlayAlertSound(soundID)
        //播放系统提示音
        AudioServicesPlaySystemSound(soundID)
    }
    
    /// 线程延时
    private func sleep(_ time: Double,mainCall:@escaping ()->()) {
        let time = DispatchTime.now() + .milliseconds(Int(time * 1000))
        DispatchQueue.main.asyncAfter(deadline: time) {
            mainCall()
        }
    }
}



