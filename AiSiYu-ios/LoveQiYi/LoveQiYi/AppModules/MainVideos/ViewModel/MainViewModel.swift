//
//  MainViewModel.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork

class MainViewModel: NSObject {

    /// 首页顶部大分类
    private lazy var typeApi: MainTypeApi = {
        let api = MainTypeApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    private lazy var modulesApi: MainModulesApi = {
        let api = MainModulesApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var hotListApi: HotListApi = {
        let api = HotListApi()
        api.paramSource = self
        api.delegate = self
        
        return api
    }()
  
    /// 分类请求
    var loadMainTypesSuccess:(() ->Void)?
    var loadMainTypesFail:(() -> Void)?
    
    /// 首页推荐
    var loadModulesSucceedHandler:(() -> ())?
    var loadModulesFailedHandler:((_ msg: String) -> ())?
    
    /// 首页除 推荐外界面
    var videoListSuccessHandler: ((_ models: HotListModel, _ page: Int) -> ())?
    var videoListFailureHandler: ((String) -> ())?
    
    var modules = [ModuleModel]()
    var params: [String: Any]?
    
    /// 首页顶部大分类
    func loadMainTypes() {
        let _ = typeApi.loadData()
    }
    
    /// 首页模块
    func loadMainModulesDatas() {
        let _ = modulesApi.loadData()
    }
    
    /// 首页根据分类Id获取视频列表
    func loadVideoList(_ parmas:[String: Any]?) {
        self.params = parmas
        let _ = hotListApi.loadData()
    }
    
    func loadNextPage() {
        let _ = hotListApi.loadNextPage()
    }
}

// MARK: - succeed
private extension MainViewModel {
    
    func loadModulesDataSuuceed(_ models: [ModuleModel]) {
        self.modules = models
        loadModulesSucceedHandler?()
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension MainViewModel: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        if manager is HotListApi {
            return params
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is MainTypeApi {
            DLog("UserLoginApi --- success")
            if let models = manager.fetchJSONData(MainReformer()) as? [MainTypeModel] {
                let model = MainTypeModel(id: -1, title: "推荐", sort: -1, created_at: nil)
                var typeModels = models
                typeModels.insert(model, at: 0)
                MainType.share().typeModels = typeModels
                loadMainTypesSuccess?()
            }
        }
        if manager is MainModulesApi  {
            if let moduleLs = manager.fetchJSONData(MainReformer()) as? [ModuleModel] {
                DLog("============================")
                loadModulesDataSuuceed(moduleLs)
            }
        }
        if manager is HotListApi {
            if let hotListModel = manager.fetchJSONData(MainReformer()) as? HotListModel {
                videoListSuccessHandler?(hotListModel, hotListApi.pageNumber)
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is MainTypeApi {
            loadMainTypesFail?()
        }
        if manager is MainModulesApi {
            loadModulesFailedHandler?(manager.errorMessage)
        }
        if manager is HotListApi {
            videoListFailureHandler?(manager.errorMessage)
        }
    }
}
