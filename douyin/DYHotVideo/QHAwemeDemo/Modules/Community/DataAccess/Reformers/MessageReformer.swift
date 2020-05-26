//
//  MessageReformer.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/8.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class MessageReformer: NSObject {
    
    ///消息最新数量
    private func reformMessageNewNumDatas(_ data: Data?) -> Any? {
        if let newMewssageNum = try? decode(response: data, of: ObjectResponse<MessageNumModel>.self)?.result {
            return newMewssageNum
        }
        return nil
    }
    
    ///通知
    private func reformMessageNoticeListDatas(_ data: Data?) -> Any? {
        if let messageNoticeList = try? decode(response: data, of: ObjectResponse<NoticeMessageListModel>.self)?.result {
            return messageNoticeList
        }
        return nil
    }

    ///点赞
    private func reformMessagePraiseListDatas(_ data: Data?) -> Any? {
        if let priseMessageList = try? decode(response: data, of: ObjectResponse<PraiseMessageListModel>.self)?.result {
            return priseMessageList
        }
        return nil
    }
    
    ///评论
    private func reformMessageCommentListDatas(_ data: Data?) -> Any? {
        if let commentMessageList = try? decode(response: data, of: ObjectResponse<CommentMessageListModel>.self)?.result {
            return commentMessageList
        }
        return nil
    }
    
    ///粉丝
    private func reformFansListDatas(_ data: Data?) -> Any? {
        if let fansMessageList = try? decode(response: data, of: ObjectResponse<FansMessageListModel>.self)?.result {
            return fansMessageList
        }
        return nil
    }
    
    ///系统消息
    private func reformSystemMessageListDatas(_ data: Data?) -> Any? {
        if let systemMessageList = try? decode(response: data, of: ObjectResponse<SystemMessageListModel>.self)?.result {
            return systemMessageList
        }
        return nil
    }
}

// MARK: - NicooAPIManagerDataReformProtocol
extension MessageReformer: NicooAPIManagerDataReformProtocol {
    
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        if manager is MessageApis {
            return reformMessageNewNumDatas(jsonData)
        }
        
        if manager is NoticeMessageListApi {
            return reformMessageNoticeListDatas(jsonData)
        }
        
        if manager is PraiseMessageListApi {
            return reformMessagePraiseListDatas(jsonData)
        }
        
        if manager is CommentMessageListApi {
            return reformMessageCommentListDatas(jsonData)
        }
        
        if manager is FansMessageListApi {
            return reformFansListDatas(jsonData)
        }
        
        if manager is SystemMessageListApi {
            return reformSystemMessageListDatas(jsonData)
        }
        
        return nil
    }
}


