//
//  TasksApis.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/5/22.
//  Copyright © 2019年 mac. All rights reserved.
//

import Foundation

/// 任务列表Api
class TasksApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/user/task"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return TasksApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}

/// 完成任务Api
class TaskDoneApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/user/save-card"
    static let kEvent = "event"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return TaskDoneApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}

/// 做任务Api
class SignApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/user/sign"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return SignApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}


