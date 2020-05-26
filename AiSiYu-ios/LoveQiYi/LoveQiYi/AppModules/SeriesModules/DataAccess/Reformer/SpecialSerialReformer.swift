//
//  SpecialSerialReformer.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import Foundation
import NicooNetwork

class SpecialSerialReformer: NSObject {
    
    ///精选系列列表
    private func reformSpecialSerialListData(_ data: Data?) -> Any? {
        if let specialSerialList = try? decode(response: data, of: ObjectResponse<SpecialSerialListModel>.self)?.result {
            return specialSerialList
        }
        return nil
    }
    
    ///系列详情列表
    private func reformSerialDetailListData(_ data: Data?) -> Any? {
        if let model = try? decode(response: data, of: ObjectResponse<VideoListModel>.self)?.result {
            return model
        }
        
        return nil
    }
}

extension SpecialSerialReformer: NicooAPIManagerDataReformProtocol {
    
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        if manager is SpecialSerialApi {
            return reformSpecialSerialListData(jsonData)
        }
        
        if manager is VideoListApi {
            return reformSerialDetailListData(jsonData)
        }
        
        return nil
    }
}
