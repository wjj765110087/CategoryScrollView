//
//  TaskViewModel.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/5/22.
//  Copyright © 2019年 mac. All rights reserved.
//

import Foundation
import UIKit
import NicooNetwork

/// 任务中心ViewMedel
class TasksViewModel: NSObject {
    
    private lazy var taskListApi: TasksApi = {
        let api = TasksApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var signApi: SignApi = {
        let api = SignApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    //TaskDoneApi
 
    /// 任务列表回调
    var loadTaskListSuccessHandler:(() -> Void)?
    var loadTaskListFailHandler:(() -> Void)?
    /// 签到回调
    var dailySignInSuccessHandler:(() -> Void)?
    var dailySignInFailHandler:((_ msg: String?) -> Void)?

    var taskList: TaskModulesModel?
    
    let userInfo = AcountViewModel()
    
    /// 查询任务列表
    func loadTasksList() {
        let _  = taskListApi.loadData()
    }
    
    /// 签到
    func loadSignApi() {
        let _ = signApi.loadData()
    }
    
    
}

// MARK: - Fix - TaskListData
extension TasksViewModel {
    
    private func requestTaskListSuccess(_ taskList: TaskModulesModel) {
        self.taskList = taskList
        loadTaskListSuccessHandler?()
    }
    
    
}

// MARK: - TasksCallBack
extension TasksViewModel {
    
    func dailySigninSuccess() {
        dailySignInSuccessHandler?()
        userInfo.loadUserInfo()
    }
    
    /// 获取当日时间，并转换为字符串
    ///
    /// - Returns: 时间字符串 "yyyy-MM-dd" 格式
    func getCurrentDay()-> String {
        let now = Date()
        let dataFormater = DateFormatter()
        dataFormater.dateFormat = "yyyy-MM-dd"
        let nowDay = dataFormater.string(from: now)
        return nowDay
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParameterEncodeing
extension TasksViewModel: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is TasksApi || manager is SignApi {
            if let taskList = manager.fetchJSONData(WelfareReformer()) as? TaskModulesModel {
                requestTaskListSuccess(taskList)
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is TasksApi {
            loadTaskListFailHandler?()
        }
        if manager is SignApi {
            dailySignInFailHandler?(manager.errorMessage)
        }
    }
    
}
