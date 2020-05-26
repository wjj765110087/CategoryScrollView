
import UIKit

struct ItemModel {
    var question: QuestionModel?
    var isSelected: Bool = false
}


/// 自动布局画BUtton
class ItemLayoutView: UIView {

    var titleLable: UILabel?
    var titleText: String = "请选择问题出现场景 0/3（必选)" {
        didSet {
            titleLable?.text = titleText
        }
    }
    var buttons = [UIButton]()
    var itemModels = [ItemModel]()
    var seletedModels = [ItemModel]()
    
    init(aFrame: CGRect, aTitle: String, aArray: [ItemModel]) {
        super.init(frame: aFrame)
        
        self.backgroundColor = UIColor.clear
        itemModels = aArray
        self.viewLayoutWith(aTitle: aTitle, aArray: aArray)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //计算字体布局
    func viewLayoutWith(aTitle: String, aArray: [ItemModel]) {
        
        if aArray.count == 0 { return }
        self.removeAllSubviews()
        //title
        let tipLabel = UILabel.init(frame: CGRect.init(x: 12, y: 5, width: self.frame.size.width-24, height: 40))
        tipLabel.font = UIFont.boldSystemFont(ofSize: 13)
        tipLabel.textColor = UIColor.darkText
        tipLabel.text = titleText
        titleLable = tipLabel
        self.addSubview(tipLabel)

        var zX = CGFloat(12) //记录按钮的X
        var zY = CGFloat(46) //记录按钮的Y
        let zH = CGFloat(30) //记录按钮的高
        for (index,value) in aArray.enumerated() {
            let valueC : String = value.question?.value ?? ""
            var size = SizeWithFont(content: valueC as NSString, font: UIFont.systemFont(ofSize: 13), maxSize: CGSize.init(width: self.frame.size.width - 12*3, height: 18))
            size.width = size.width + 18 //每个按钮的长度
            //如果摆放的按钮大于屏幕宽 则另起一行
            if (zX+size.width+12) > self.frame.size.width {
                zY = zY + (zH+10) //10是按钮上下间的间隔
                zX = 12 //初始值
            }
            //最后一个按钮离底部距离
            if (zY+zH)>self.frame.size.height {
                //加一个上下间隔和按钮高度
                self.frame.size.height = self.frame.size.height + (10+40)
            }
            let colorNormal = UIColor(r: 244, g: 244, b: 244)
            let buton = UIButton.init(type: .custom)
            buton.tag = index
            buton.frame = CGRect.init(x: zX, y: zY, width: size.width, height: zH)
            buton.setBackgroundImage(UIImage.imageFromColor(colorNormal, frame: CGRect(x: 0, y: 0, width: 120, height: 30)), for: .normal)
            buton.setBackgroundImage(UIImage.imageFromColor(kAppDefaultTitleColor, frame: CGRect(x: 0, y: 0, width: 120, height: 30)), for: .selected)
            buton.setTitleColor(UIColor.darkGray, for: .normal)
            buton.setTitleColor(UIColor.white, for: .selected)
            buton.setTitle(valueC, for: .normal)
            buton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            buton.isSelected = value.isSelected
            buton.layer.cornerRadius = 15
            buton.layer.masksToBounds = true
            buton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            self.addSubview(buton)
           
            zX = zX + (buton.frame.size.width+12) //12是按钮左右间的间隔
        }
    }
    
    @objc func buttonAction(sender: UIButton) {
        if sender.isSelected { // 已经选中
            sender.isSelected = false
            if buttons.contains(sender) {
                buttons = buttons.filter { (button) -> Bool in
                    button.tag != sender.tag
                }
            }
        } else {
            if !buttons.contains(sender) && buttons.count < 3 {
                buttons.append(sender)
                sender.isSelected = true
            } else {
                print("allrealdy chose")
            }
        }
        titleText = "请选择问题出现场景\(buttons.count)/3（必选)"
       // print("buttons = \(buttons)")
        seletedModels.removeAll()
        for button in buttons {
            let item = itemModels[button.tag]
            seletedModels.append(item)
        }
        DLog("seletedModels == \(seletedModels)")
    }
}

extension ItemLayoutView {
    //removeAllSubviews
    func removeAllSubviews() {
        while self.subviews.count > 0{
            self.subviews.last?.removeFromSuperview()
        }
    }
    //font size
    func SizeWithFont(content : NSString, font : UIFont, maxSize : CGSize) -> CGSize {
        return content.boundingRect(with: maxSize, options: (NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue)), attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
}
