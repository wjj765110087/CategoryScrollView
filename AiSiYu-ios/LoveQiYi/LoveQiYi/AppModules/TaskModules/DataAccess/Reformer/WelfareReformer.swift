//
//  WelfareReformer.swift
//  YellowBook
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 mac. All rights reserved.
//

import Foundation
import NicooNetwork

class WelfareReformer: NSObject {
    /// 任务列表
    private func reformTaskListDatas(_ data: Data?) -> Any? {
        if let taskList = try? decode(response: data, of: ObjectResponse<TaskModulesModel>.self)?.result {
            return taskList
        }
        return nil
    }
    
}

extension WelfareReformer: NicooAPIManagerDataReformProtocol {
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        /// task
        if manager is TasksApi || manager is SignApi {
            return reformTaskListDatas(jsonData)
        }
        return nil
    }
}
