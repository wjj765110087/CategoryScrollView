

import Foundation

/// 视频列表model
class VideoListModel: Codable {
    var current_page: Int?
    var data: [VideoModel]?
    var total: Int?
}

/// 首页数据源列表
class VideoHomeListModel: Codable {
    var current_page: Int?
    var data: [HomeVideoModel]?
    
}

/// 首页视频类型。 "V" - 正常视频  "A" - 广告
enum HomeVideoType: String, Codable {
    case videoType = "V"   // 视频
    case adType = "A"  // 广告
}

/// 首页model
class HomeVideoModel: Codable {
    var type: HomeVideoType?
    var video: VideoModel?
    var ad: AdvertiseModel?
}

/// 视频Model
class VideoModel: Codable {
    
    var id: Int?
    var title: String?
    var title_att: String?
    var created_at: String?
    var updated_at: String?
    var shift_original_filename: String?
    var shift_original_status: Int?
    var genre: Int?
    var user_id: Int?
    var _oid: Int?
    var _origin: String?
    
    var intro: String?
    var cover_path: String?
    var cover_oss_filename: String?
    var play_count: Int?
    var play_url_m3u8: String?
    var play_url_mp4: String?
    
    var is_coins: Int?            // 是否金币视频
    var coins: Int?               // 金币价格

    var recommend: Recommend?     // 是否点过❤️
    var comment_count: Int?       // 评论数
    var recommend_count: Int? = 0 // 点赞数
    var view_flag: Bool? = false  // 当前用户是否可以播放 本视频
    var keys: [VideoKey]?         // 视频标签
    var topic: VideoTopicModel?   // 话题
    
    var check: CheckStatu?        // 用于作品的审核状态
    var isLocalUpload: Bool? = false // 是否为本地上传Model
    var localUrl: URL?
    
    var user: UserInfoModel?
}

/// 是否点👍
enum Recommend: Int, Codable {
    case notRecommend = 0
    case recommend = 1
    
    var isFavor: Bool {
        switch self {
        case .recommend:
            return true
        case .notRecommend:
            return false
        }
    }
}

/// 作品审核状态
///
/// - waitForCheck: 待审核
/// - passCheck: 已审核通过
/// - notPassCheck: 未审核通过
//  - uploading: 本地添加的，正在上传状态
enum CheckStatu: Int, Codable {
    case waitForCheck = 0
    case passCheck = 1
    case notPassCheck = -1
    // 下面两个是本地的状态
    case uploading = 2
    case uploadFailed = 3
}

/// 首页广告
struct AdvertiseModel: Codable {
    var id: Int?
    var ad_type: String?
    var title: String?
    var remark: String?
    var redirect_url: String?   // 广告去哪
    var cover_path: String?     // 封面
    var play_url_m3u8: String?
    var recommend_count: Int?   // 点赞数
    var recommend: Recommend?   // 是否点过❤️
    var comment_count: Int?     // 评论数
}

/// 活动页
class ActivityItems: Codable {
    var item1: ActivityModel?
}

enum ActivityType: String, Codable  {
    case link = "LINK"
    case native = "INTERNAL-LINK"
}

/// 活动页
class ActivityModel: Codable {
    var title: String?
    var _as: String?
    var type: ActivityType?   // 活动跳转类型
    var startDate: String?    // 活动开始时间
    var endDate: String?      // 活动结束时间
    var days: Int?            // 天数
    var icon: String?         // 首页显示入口图片
    var sk_icon: String?      // 活动弹框图片
    var redirect_url: String? // 活动为H5时跳转链接
    var banner: String?       // 活动页面顶部图片
    var childs: [ActivityChild]?  // 活动Item
    var topics: [TalksModel]?     // 参与活动的话题， 仅限于 活动item 为 DYNAMIC_PRAISE 的
    var rules_desc: String?    // 活动简介
    var rules_url: String?     // 活动介绍链接
    var redirect_position: RedirectURLPosition? //跳转类型
}

class ActivityChild: Codable {
    var name: String?
    var key: ActivityItemKey?
    var api: String?
    var selected: Bool? = false
}

enum ActivityItemKey: String, Codable {
    case Dynamic_Praise = "DYNAMIC_PRAISE"   // 动态点赞
    case Video_Praise   = "VIDEO_PRAISE"     // 视频点赞
    case Upload_Video  = "UPLOAD_VIDEO"      // 上传数量
    case Coins_Video   = "COINS_VIDEO"       // 金币视频排行
    case DefaultKey = ""
}
/// 视频key
struct VideoKey: Codable {
    var key_id: Int?
    var title: String?
    var pivot: Pivot?
}

struct Pivot: Codable {
    var video_id: Int?
    var key_id: Int?
}

/// 系列分类列表model
struct CateTypeListModel: Codable {
    var current_page: Int?
    var data: [VideoCategoryModel]?
}

/// 视频大分类列表MOdel
struct VideoCategoryModel: Codable {
    var id: Int?
    var key_id: Int?
    var keys_title: String?
    var keys_cover: String?
    var view_key_title: String?
    var intro: String?
    var cover_filename: String?
    var page: String?
    var recommend: Int?
    var updated_at: String?
    var updated_at_string: String?
    var video_lists:[VideoModel]?
    var relation_keys: [VideoKey]?
}

/// 视频评论列表MOdel
class VideoCommentListModel: Codable {
    var current_page: Int?
    var data: [VideoCommentModel]?
    var total: Int?
}

/// 评论回复列表MOdel
class CommentAnswerListModel: Codable {
    var current_page: Int?
    var data: [CommentAnswerModel]?
    var total: Int?
}


class VideoCommentModel: Codable {
    var id: Int?
    var parent_id: Int?
    var video_id: Int?
    var topic_content_id: Int?

    var user_id: Int?
    var user: UserInfoModel?
    var content: String?
    var status: Int?
    var ip: String?
    var created_at: String?
    var updated_at: String?
    var deleted_at: String?
    var nikename: String?
    var cover_path: String?
    var time: String?
    var like: Int?      // 喜欢数量
    var is_like: Int?   // 是否👍
    var comment: [CommentAnswerModel]?
    /// 是否已经拉取全部f回复
    var isAllAnswers: Bool? = false
    /// 当前区是否展开
    var isOpen: Bool? = false
    /// 当前请求的页码
    var answerPageNumber: Int? = 1
}

///视频子评论模型
class CommentAnswerModel: Codable {
    
    var id: Int?
    var parent_id: Int?
    var video_id: Int?
    var user_id: Int?
    var nikename: String?
    var cover_path: String?
    var content: String?
    var status: Int?
    var ip: String?
    var created_at: String?
//    var updated_at: String?
//    var deleted_at: String?
    var time: String?
    var user: UserInfoModel?
    /// 是否是作者
    var isZZ: Bool? = false
}

///视频点赞评论
class VideoCommentLikeModel: Codable {
    var result: Int?
}

/// 搜索联想
struct SearchMagicListModel: Codable {
    var current_page: Int?
    var data: [SearchMagicKeyModel]?
}

struct SearchMagicKeyModel: Codable {
    var id: Int?
    var title: String?
}

struct AddGroupLinkModel: Codable {
    var id: Int?
    var title: String?
    var url: String?
    var icon: String?
    var sort: Int?
    var created_at: String?
    var updated_at: String?
}



struct StrInt: Codable {
    var int:Int {
        didSet {
            let stringValue = String(int)
            if  stringValue != string {
                string = stringValue
            }
        }
    }
    
    var string:String {
        didSet {
            if let intValue = Int(string), intValue != int {
                int = intValue
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        
        if let stringValue = try? singleValueContainer.decode(String.self)
        {
            string = stringValue
            int = Int(stringValue) ?? 0
            
        } else if let intValue = try? singleValueContainer.decode(Int.self)
        {
            int = intValue
            string = String(intValue);
        } else
        {
            int = 0
            string = ""
        }
    }
}
