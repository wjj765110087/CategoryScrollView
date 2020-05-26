//
//  MainReformer.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork

class MainReformer: NSObject {
    
    private func reformMainTypeDatas(_ data: Data?) -> Any? {
        if let typeList = try? decode(response: data, of: ObjectResponse<[MainTypeModel]>.self)?.result {
            return typeList
        }
        return nil
    }
    private func reformMainModulesDatas(_ data: Data?) -> Any? {
        if let modules = try? decode(response: data, of: ObjectResponse<[ModuleModel]>.self)?.result {
            return modules
        }
        return nil
    }
    
    // 视频列表
    private func reformHotListDatas(_ data: Data?) -> Any? {
        if let taskList = try? decode(response: data, of: ObjectResponse<HotListModel>.self)?.result {
            return taskList
        }
        return nil
    }
    
    ///更多
    private func reformModulesMoreData(_ data: Data?) -> Any? {
        if let videoMoreList = try? decode(response: data, of: ObjectResponse<VideoListModel>.self)?.result {
            return videoMoreList
        }
        return nil
    }
}

extension MainReformer: NicooAPIManagerDataReformProtocol {
    
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        if manager is MainTypeApi {
            return reformMainTypeDatas(jsonData)
        }
        if manager is MainModulesApi {
            return reformMainModulesDatas(jsonData)
        }
        if manager is HotListApi {
            return reformHotListDatas(jsonData)
        }
        if manager is ModulesMoreApi {
            return reformModulesMoreData(jsonData)
        }
        return nil
    }
    
}
