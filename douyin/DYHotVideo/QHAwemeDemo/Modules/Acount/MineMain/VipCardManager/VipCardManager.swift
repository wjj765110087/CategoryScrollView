//
//  VipCardManager.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation


struct VipCardLayer {
    var cardBgName: String?
    var cardName: String?
    var cardTipsName: String?
    var showTips: Bool = true
    var cardType: VipKey = VipKey.card_Normal
}

/// 会员卡弹框
struct VipAlertLayer {
    var cardBgName: String?
    var cardName: String?
    var cardBtnName: String?
    var cardLogolName: String?
    var cardType: Int = 0
}

/// Vip Card Manager
class VipCardManager: NSObject {
    
    /// 获取卡的UI
    ///
    /// - Parameter cardType: 卡片判断条件
    /// - Returns: 卡片layer 对象
    class func fixVipWithCardType(cardType: VipKey) -> VipCardLayer {
        // 游客卡
        if cardType == VipKey.card_Normal {
            return VipCardLayer(cardBgName: "youKeCardbg", cardName: "YoukeCardNameImage", cardTipsName: "youkeCardTips", showTips: true, cardType: cardType)
        } else if cardType == VipKey.card_Novice {
            // 新手卡
            return VipCardLayer(cardBgName: "xinShouCardBg", cardName: "xinShouCardName", cardTipsName: "xinShouCardTips", showTips: true, cardType: cardType)
        } else if cardType == VipKey.card_TiYan {
            return VipCardLayer(cardBgName: "tiYanCardBg", cardName: "tiYanCardName", cardTipsName: "tiYanCardTips", showTips: true, cardType: cardType)
        } else if cardType == VipKey.card_YouXiang { //122 74 49
            return VipCardLayer(cardBgName: "youXiangCardBg", cardName: "youXiangCardName", cardTipsName: "youXiangCardTips", showTips: true, cardType: cardType)
        } else if cardType == VipKey.card_GuiBing {
            return VipCardLayer(cardBgName: "guibingCardBg", cardName: "GuibingCard", cardTipsName: "cardTipsGB", showTips: true, cardType: cardType)
        } else if cardType == VipKey.card_ZhiZun {
            // 213 174 114
            return VipCardLayer(cardBgName: "blockGlodCard", cardName: "blockCardName", cardTipsName: nil, showTips: false, cardType: cardType)
        } else {
            return VipCardLayer(cardBgName: "youKeCardbg", cardName: "youkeCardName", cardTipsName: "youkeCardTips", showTips: true, cardType: cardType)
        }
    }
    
    /// 获取会员卡弹框UI
    ///
    /// - Parameter cardType: 卡类型
    /// - Returns: 弹框layer对象
    class func getVipCardAlertWith(cardType: VipKey) -> VipAlertLayer {
      
        if cardType ==  VipKey.card_TiYan {
            return VipAlertLayer(cardBgName: "tiyanCardAlertBg", cardName: "tiyanCardAlertName", cardBtnName: "cardCommitBtn", cardLogolName: "sLogolAlert",cardType: 3)
        } else if cardType == VipKey.card_YouXiang {
            return  VipAlertLayer(cardBgName: "zunxiangVipAlertBg", cardName: "zunxiangVipAlertName", cardBtnName: "cardCommitBtn", cardLogolName: "gLogalAlert", cardType: 4)
        } else if cardType == VipKey.card_GuiBing {
            return  VipAlertLayer(cardBgName: "guiBingVipAlertBg", cardName: "guiBingAlertName", cardBtnName: "cardCommitBtn", cardLogolName: "pLogolAlert", cardType:5)
        } else if cardType == VipKey.card_ZhiZun {
            return  VipAlertLayer(cardBgName: "zhizunAlertBg", cardName: "zhizunAlertName", cardBtnName: "closeAlertBtn_1", cardLogolName: "bLogalAlert", cardType: 6)
        } else {
            return  VipAlertLayer(cardBgName: "tiyanCardAlertBg", cardName: "tiyanCardAlertName", cardBtnName: "cardCommitBtn", cardLogolName: "sLogolAlert", cardType: 3)
        }
    }
    
    /// 根据卡类型选择卡背景
    class func getCardBgImageWith(cardType: VipKey) -> UIImage? {
        if cardType == VipKey.card_TiYan {
            return UIImage(named: "tiyanPriceCard")
        } else if cardType == VipKey.card_YouXiang {
            return UIImage(named: "youxiangPriceCard")
        } else if cardType == VipKey.card_GuiBing {
            return UIImage(named: "guibingPriceCard")
        } else if cardType == VipKey.card_ZhiZun {
            return UIImage(named: "zhizunPriceCard")
        } else {
            return UIImage(named: "tiyanPriceCard")
        }
    }
    
    /// 获取价格字体颜色
    ///
    /// - Parameter cardType: 卡类型
    /// - Returns: 颜色
    class func getCardTitleColorWith(cardType: VipKey) -> UIColor {
        if cardType == VipKey.card_TiYan {
            return UIColor(red: 47/255.0, green: 55/255.0, blue: 80/255.0, alpha: 1)
        } else if cardType == VipKey.card_YouXiang {
            return UIColor(red: 122/255.0, green: 74/255.0, blue: 49/255.0, alpha: 1)
        } else if cardType == VipKey.card_GuiBing {
            return UIColor(red: 122/255.0, green: 74/255.0, blue: 49/255.0, alpha: 1)
        } else if cardType == VipKey.card_ZhiZun {
            return UIColor(red:  213/255.0, green: 174/255.0, blue: 114/255.0, alpha: 1)
        } else {
            return UIColor(red:  213/255.0, green: 174/255.0, blue: 114/255.0, alpha: 1)
        }
    }
    
    /// 获取msg字体颜色
    ///
    /// - Parameter cardType: 卡类型
    /// - Returns: 颜色
    class func getCardMsgColorWith(cardType: VipKey) -> UIColor {
        if cardType == VipKey.card_TiYan {
            return UIColor(red: 99/255.0, green: 104/255.0, blue: 121/255.0, alpha: 1)
        } else if cardType == VipKey.card_YouXiang {
            return UIColor(red: 144/255.0, green: 115/255.0, blue: 100/255.0, alpha: 1)
        } else if cardType == VipKey.card_GuiBing {
            return UIColor(red: 147/255.0, green: 99/255.0, blue: 74/255.0, alpha: 1)
        } else if cardType == VipKey.card_ZhiZun {
            return UIColor(red: 147/255.0, green: 99/255.0, blue: 74/255.0, alpha: 1)
        } else {
            return UIColor(red: 147/255.0, green: 99/255.0, blue: 74/255.0, alpha: 1)
        }
    }
    
}
