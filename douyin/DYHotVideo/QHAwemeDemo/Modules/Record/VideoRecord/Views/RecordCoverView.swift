//
//  RecordCoverView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/20.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class RecordCoverView: UIView {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var NextStepBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var rotateLabel: UILabel!
    @IBOutlet weak var flashlightBtn: UIButton!
    @IBOutlet weak var flashLable: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var beautyBtn: UIButton!
    @IBOutlet weak var beautyLabel: UILabel!
    @IBOutlet weak var constraintDone: NSLayoutConstraint!
    lazy var progressView: CycleProgressView = {
        let progress = CycleProgressView.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80), lineWidth: 5.0)
        progress.isHidden = true
        return progress
    }()
    
    var rotateActionHandler: (() -> Void)?
    var flashActionHandler: ((_ isFlash: Bool) -> Void)?
    var filterChoseActionHandler: (() -> Void)?
    var beautyFaceActionHandler: ((_ isOn: Bool) -> Void)?
    var finishRecordActionHandler: (() -> Void)?
    var recordActionHandler: (() -> Void)?
    var choseVideoActionHandler: (() -> Void)?
    var playVideoActionHandler: (() -> Void)?
    var nextStepActionHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recordButton.layer.masksToBounds = true
        recordButton.layer.borderColor = UIColor.white.cgColor
        constraintDone.constant = (ConstValue.kScreenWdith/2 - 70)/2
        addSubview(progressView)
        layoutPageSubviews()
        doneButton.isHidden = true
        flashlightBtn.isEnabled = false
        recordButton.backgroundColor = UIColor(r: 0, g: 123, b: 255)
        libraryButton.backgroundColor = UIColor(red: 0/255.0, green: 123/255.0, blue: 255/255.0, alpha: 0.6)
        playBtn.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        playBtn.layer.masksToBounds = true
        NextStepBtn.layer.masksToBounds = true
        NextStepBtn.backgroundColor = UIColor(r: 0, g: 123, b: 255)
    }
    
    @IBAction func rotateAction(_ sender: UIButton) {
        rotateActionHandler?()
    }
    
    @IBAction func flashAction(_ sender: UIButton) {
        flashActionHandler?(sender.isSelected)
    }
    
    @IBAction func filterChoseAction(_ sender: UIButton) {
        filterChoseActionHandler?()
    }
    
    @IBAction func beautyFaceAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        beautyFaceActionHandler?(sender.isSelected)
    }
    
    @IBAction func finishRecordAction(_ sender: UIButton) {
        finishRecordActionHandler?()
    }
    
    @IBAction func recordAction(_ sender: UIButton) {
        recordActionHandler?()
    }
    
    @IBAction func choseVideoAction(_ sender: UIButton) {
        choseVideoActionHandler?()
    }
    
    @IBAction func nextStepAction(_ sender: UIButton) {
        nextStepActionHandler?()
    }
    
    @IBAction func playVideoAction(_ sender: UIButton) {
        playVideoActionHandler?()
    }
    
    /// 点击开始录制，调用，改变UI状态
    func startRecordStatu() {
        recordButton.layer.borderColor = UIColor.clear.cgColor
        progressView.isHidden = false
        recordButton.isEnabled = false
        doneButton.isHidden = false
        libraryButton.isHidden = true
        startRecordAnimation()
    }
    
    /// 结束录制时，吊用
    func finishRecordStatu() {
        recordButton.layer.borderColor = UIColor.clear.cgColor
        recordButton.isEnabled = false
        timeLabel.textColor = UIColor.orange
        doneButton.isHidden = true
        NextStepBtn.isHidden = false
        playBtn.isHidden = false
        rotateButton.isEnabled = false
        filterButton.isEnabled = false
        flashlightBtn.isEnabled = false
        beautyBtn.isEnabled = false
        stopAnimation()
    }
    
    /// 开始录制动画
    func startRecordAnimation() {
        self.recordButton.setImage(UIImage(named: "recordingBtn"), for: .normal)
        self.recordButton.backgroundColor = UIColor.clear
        self.recordButton.setTitle("", for: .normal)
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.0
        animationGroup.beginTime = CACurrentMediaTime()
        animationGroup.repeatCount = .infinity
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        let scaleAnim = CABasicAnimation()
        scaleAnim.keyPath = "transform.scale"
        scaleAnim.fromValue = 0.2
        scaleAnim.toValue = 1.5
        let alphaAnim = CABasicAnimation()
        alphaAnim.keyPath = "opacity"
        alphaAnim.fromValue = 0.35
        alphaAnim.toValue = 1.0
        animationGroup.animations = [scaleAnim,  alphaAnim]
        recordButton.layer.add(animationGroup, forKey: nil)
    }
    
    /// 结束录制
    private func stopAnimation() {
        self.recordButton.setImage(nil, for: .normal)
        self.recordButton.backgroundColor  = UIColor(white: 0.1, alpha: 0.2)
        self.recordButton.setTitle("", for: .normal)
        self.recordButton.layer.removeAllAnimations()
    }
    
}

// MARK: - Layout
private extension RecordCoverView {
    
    func layoutPageSubviews() {
        layoutProgressView()
    }
    
    func layoutProgressView() {
        progressView.snp.makeConstraints { (make) in
            make.centerX.equalTo(recordButton)
            make.centerY.equalTo(recordButton)
            make.width.height.equalTo(80)
        }
    }
}
