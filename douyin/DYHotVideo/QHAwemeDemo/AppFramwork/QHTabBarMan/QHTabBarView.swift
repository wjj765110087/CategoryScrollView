

import UIKit

public protocol QHTabBarDataSource: NSObjectProtocol {
    func tabBarViewForRows(_ tabBarView: QHTabBarView) -> [QHTabBar]
    
    func tabBarViewForMiddle(_ tabBarView: QHTabBarView, size: CGSize) -> UIView?
}

@objc protocol QHTabBarDelegate: NSObjectProtocol {
    @objc optional func tabBarView(_ tabBarView: QHTabBarView, didSelectRowAt index: Int)
}

public class QHTabBarView: UIView {
    
    weak var dataSource: QHTabBarDataSource?
    
    weak var delegate: QHTabBarDelegate?
    
    var superView: UIView?
    
    var selectIndex: Int = 0//从1开始
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        p_setup()
        reloadData()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        p_setup()
        reloadData()
    }
    
    //MARK: Private
    
    func p_setup() {
        self.backgroundColor = UIColor.clear
    }
    
    //MARK: Public
    
    func reloadData() {
        superView?.removeFromSuperview()
        superView = UIView(frame: self.bounds)
        superView!.backgroundColor = UIColor.clear
        
        if let dataS = self.dataSource {
            let dataArray = dataS.tabBarViewForRows(self)
            
            var width = CGFloat(self.frame.size.width) / CGFloat(dataArray.count + 1)
            let hight = CGFloat(self.frame.size.height)
            
            let middleView = dataS.tabBarViewForMiddle(self, size: CGSize(width: width, height: hight))
            
            var middleIndex = Int(dataArray.count) / 2
            if nil == middleView {
                width = CGFloat(self.frame.size.width) / CGFloat(dataArray.count)
                middleIndex = 0
            }
            
            var xIndex = 0
            for (index, value) in dataArray.enumerated() {
                xIndex = index
                if xIndex >= middleIndex && middleIndex != 0 {
                    xIndex += 1
                }
                
                if index == middleIndex && middleIndex != 0 {
                    let view = UIView(frame: CGRect(x: CGFloat(middleIndex) * width, y: 5, width: width, height: hight))
                    view.backgroundColor = UIColor.clear
                    view.addSubview(middleView!)
                    superView!.addSubview(view)
                }
            
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: CGFloat(xIndex) * width, y: UIDevice.current.isiPhoneXSeriesDevices() ? 10 : 0, width: width, height: 44)
                btn.backgroundColor = UIColor.clear
                
                let normalTitle = NSMutableAttributedString(string: value.title, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(white: 0.85, alpha: 0.95)])
                btn.setAttributedTitle(normalTitle, for: .normal)
                
                let selectTitle = NSMutableAttributedString(string: value.title, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white])
                btn.setAttributedTitle(selectTitle, for: .selected)
                
                btn.addTarget(self, action: #selector(QHTabBarView.selectAction(sender:)),for: UIControl.Event.touchUpInside)
                btn.isSelected = false
                btn.tag = index + 1
                
                let lineView = UIView(frame: CGRect(x: CGFloat(xIndex) * width + width*2.5/7, y: UIDevice.current.isiPhoneXSeriesDevices() ? 54 : 41, width: width*2/7, height: 2))
                lineView.backgroundColor = UIColor.white
                lineView.layer.cornerRadius = 1.0
                lineView.layer.masksToBounds = true
                lineView.tag = (index + 1) * 100
                lineView.isHidden = (index + 1) != 1
               
                superView!.addSubview(btn)
                superView!.addSubview(lineView)
            }
        }
        
        self.addSubview(superView!)
    }
    
    func selectTabBar(index: Int) {
        if index == selectIndex {
            return
        }
        if let btn: UIButton = superView?.viewWithTag(index) as? UIButton, let line = superView?.viewWithTag(index * 100)  {
            if let selectedBtn: UIButton = superView?.viewWithTag(selectIndex) as? UIButton, let lineSelected = superView?.viewWithTag(selectIndex * 100) {
                selectedBtn.isSelected = false
                lineSelected.isHidden = true
            }
            btn.isSelected = true
            line.isHidden = false
            selectIndex = index
        }
    }
    
    //MARK: Action
    
    @objc func selectAction(sender: UIButton) {
        if let del = self.delegate {
            if (del.tabBarView) != nil {
                del.tabBarView?(self, didSelectRowAt: (sender.tag - 1))
            }
            
            selectTabBar(index: sender.tag)
        }
    }
}
