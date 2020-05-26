//
//  GameModels.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-21.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import Foundation


class ConvertListModel: Codable {
    var user_props_data: [PropsModel]?   /*==用户已拥有的道具信息==*/
    var game_prize_data: [GameGiftListModel]?
}

class PropsModel: Codable {
    var id: Int?
    var props_id: Int?
    var activity_id: Int?
    var paset_id: Int?         //
    
    var game: String?
    var props_name: String?
    var props_name_en: String?   // 英文名
    var props_img: String?
    var props_nbets: Int?    /*道具押1注中奖或获得多少个此道具*/
    var props_nball: Int?    /*_后台业务计算放了多少个记号球,若0,永远不会中奖*/
    var props_probability: String?
    var created_at: String?
    
    var sort: Int?
    var _site: Int?           //*(非数据库字段)业务下标位置, 1 就是界面中左上角第一个道具*/
    
    var user_props_number: Int?   // 当前用户 拥有多少个 当前礼物
}

class GameGiftListModel: Codable {
    var props_info: GiftSectionModel?      /// *==对接标题内容==*  /
    var prize_list: [GiftModels]?          /// *==奖品列表===*  /
}

class GiftSectionModel: Codable {
    var props_name: String?
    var props_title: String?
    var props_name_en: String?
    var props_img: String?
    var _user_props_number: Int?    // 当前用户 拥有多少个 当前礼物
}

class GiftModels: Codable {
    var prizero_sid: Int?         /*奖品ID*/
    var activity_id: Int?
    var props_id: Int?            /*道具ID*/
    var prize_name: String?       /*奖品名称*/
    var prize_type: String?
    var prize_type_ext: String?
    var prize_remark: String?     /*奖品描述*/
    var prize_img: String?        /*奖品图片*/
    var prize_props_number: Int?  /*需要多少个道具才可以兑换*/
    var _is_convert: Int?         /*是否兑换 0-不可以(即道具不足) 1-可以*/
}


/// 中奖，兑奖 广播
struct GameNoticeModel: Codable {
    var id: Int?
    var user_id: Int?
    var remark_user: String?
    var created_at: String?
}


class GameMainModel: Codable {
    var activity_info: GameInfoModel?
    var game_data: [PropsModel]?
    var game_props_data: [PropsModel]?
    var user_wallet_info: WalletInfo?
}


class GameInfoModel: Codable {
    var id: Int?
    var title: String?
    var game_coins: String?
    var start_date: String?
    var end_date: String?
    var rules_url: String?
}

class GameTaskModel: Codable {
    var id: Int?
    var group: TaskCategory?
    var key: String?
    var title: String?
    var coins: Int?
    var icon: String?
    var sort: Int?
    var number: Int?
    var created_at: String?
    var updated_at: String?
    var has: Int?
    var sign: TaskSign?
    var remark: String?
    var isSelected: Int?    //0 未选中， 1 选中
    var props: [propsModel]?
}

class propsModel: Codable {
    var count: Int?
    var props_name: String
    var props_id: Int?
    var props_img: String?
}

enum TaskCategory: String,Codable {
    case coins = "COINS"
    case props = "PROPS"
}

enum TaskSign: Int, Codable {
    case doTask = 0
    case waitGet = 1
    case hasFinish = 2
}

class GetTaskSuccessModel: Codable {
    var user_id: Int?
    var task_id: Int?
    var updated_at: String?
    var created_at: String?
    var _id: String?
}

class GameResultModel: Codable {
    var rand_props_info: PropsModel?
    var _site: Int?         ///
    var is_win: Int?     // 1 中奖  0 未中将
    var user_info: WalletInfo?
}


struct GiftListModel: Codable {
    var current_page: Int?
    var data: [MyGiftModle]?
}

struct MyGiftModle: Codable {
    var id: Int?
    var user_id: Int?
    var activity_id: Int?
    var prizero_sid: Int?
    var remark_user: String?
    var remark_admin: String?
    var props_id: Int?
    var props_use_number: Int?
    var is_action: Int?       // 是否发放
    var created_at: String?
    var prize_type: String?
    var prize_name: String?
    var prize_remark: String?  /*奖品描述*/
    var prize_img: String?
    var prize_type_zh: String?   /*奖品类别_业务中文意思*/
}
