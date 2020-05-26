//
//  InvestCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class InvestCell: UITableViewCell {
    
    static let cellId = "InvestCell"
    static let cellHeight: CGFloat = 35.0
    
    ///公告的数据源
    var datas: [String] = ["每日充值额度库存有限，充值失败时请尝试其他额度，或稍后再试"]
    
    ///跑马灯
    var runhouseView : UIRunHouseView? = UIRunHouseView()

    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        let view = UIView()
        view.backgroundColor = .clear
        selectedBackgroundView = view
        contentView.addSubview(bgView)
        bgView.addSubview(runhouseView!)
        
        runhouseView?.dataSourse = self
        runhouseView?.backgroundColor = UIColor.clear
        runhouseView?.registerClasse(classType: CustomRunHouseView.classForCoder(), reuseIdentifier: "CustomRunHouseView")
        runhouseView?.registerClasse(classType: ImageTitleView.classForCoder(), reuseIdentifier: "ImageTitleView")
        layoutPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDatas(_ datas: [String]) {
        self.datas = datas
        runhouseView?.reloadData()
    }
}

extension InvestCell: UIRunHouseViewDatasourse {
    //MARK UIRunHouseViewDatasourse 跑马灯数据源
    ///跑马灯有多少个item
    func numberOfItemsInRunHouseView(view: UIRunHouseView) -> Int {
        return datas.count
    }
    
    /// 获取item
    ///
    /// - Parameters:
    ///   - runHouseView: 跑马灯视图
    ///   - index: 对应item的角标值
    /// - Returns:角标对应的视图
    func runHouseView(runHouseView: UIRunHouseView, itemForIndex index: Int) -> UIView {
        
        if index % 2 == 0 {
            var view = runHouseView.dequeneItemViewResueIdentity(resueIdentity: "CustomRunHouseView") as? CustomRunHouseView
            if view == nil {
                view = CustomRunHouseView()
            }
            view?.label.text = self.datas[index]
            return view!
        }else{
            var view = runHouseView.dequeneItemViewResueIdentity(resueIdentity: "ImageTitleView") as? ImageTitleView
            if view == nil {
                view = ImageTitleView()
            }
            view?.label.text = self.datas[index]
            return view!
        }
    }
    
    /// 获取item宽度
    ///
    /// - Parameters:
    ///   - runHouseView: 跑马灯视图
    ///   - index: 对应item的角标值
    /// - Returns: 返回对应item的宽度
    func runHouseView(runHouseView: UIRunHouseView, widthForIndex index: Int) -> CGFloat {
        let str = self.datas[index]
        let font = UIFont.systemFont(ofSize: 12)
        let rect = str.boundingRect(with:CGSize.init(width: CGFloat(MAXFLOAT), height: 50),options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: [NSAttributedString.Key.font:font],context:nil)
        if index % 2 == 0{
            return rect.size.width + 10
        }else{
            return rect.size.width + 50
        }
    }

}

private extension InvestCell {
    func layoutPageViews() {
        layoutBgView()
        layoutRunHouseView()
    }
    
    func layoutBgView() {
        bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(14)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-14)
            make.height.equalTo(35)
        }
    }
    
    func layoutRunHouseView() {
        runhouseView!.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-10)
            make.height.equalTo(35)
        }
    }
}
