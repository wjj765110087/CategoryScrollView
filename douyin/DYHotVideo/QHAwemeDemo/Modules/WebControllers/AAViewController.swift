//
//  AAViewController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/11.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  首页活动页

import UIKit
import WebKit

public let kScreenHeight = UIScreen.main.bounds.size.height
public let kScreenWdith = UIScreen.main.bounds.size.width

enum JSFuctionEnum: String {
    case finishActivity = "finishActivity"
    case uploadVideo = "uploadVideo"
    case showPersonPage = "showPersonPage"
    case showVideo = "showVideo"
}

class AAViewController: UIViewController {
    
    static let kListener = "JSListener"
    static let kListenerOther = "JSListenerOther"
    private let estimatedProgressKeyPath = "estimatedProgress"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var wkConfig: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        //声明一个WKUserScript对象
        let script = WKUserScript.init(source: "", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        return config
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreenWdith, height: kScreenHeight), configuration: wkConfig)
        webView.navigationDelegate = self
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.backgroundColor = UIColor.white
        // 用WeakScriptMessageDelegate(self) 代替self,解决内存泄漏的问题
        webView.configuration.userContentController.add(WeakScriptDelegate(self), name: AAViewController.kListenerOther)
        webView.addObserver(self, forKeyPath: estimatedProgressKeyPath, options: .new, context: nil)
        return webView
    }()
    
    private lazy final var progressView: UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(x: 0, y: safeAreaTopHeight, width: screenWidth, height: 0.5))
        progressView.progressViewStyle = .bar
        progressView.tintColor = UIColor.init(r: 218, g: 187, b: 63)
        progressView.trackTintColor = UIColor.clear
        return progressView
    }()
    
    private var openUrl: URL?
    
    let viewModel: VideoViewModel = VideoViewModel()
    
    deinit {
        DLog("vc is deinit")    // 出站的时候，这里没走，说明当前控制器没有被释放调，存在内存泄漏
        webView.configuration.userContentController.removeScriptMessageHandler(forName: AAViewController.kListenerOther)
        webView.removeObserver(self, forKeyPath: estimatedProgressKeyPath, context: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        view.addSubview(progressView)
        view.addSubview(webView)
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.webView.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        loadWebUrl()
    }
    
    /// 加载网页
    private func loadWebUrl() {
        if openUrl != nil {
            webView.load(URLRequest(url: openUrl!))
        }
    }
    
    init(url: URL) {
        openUrl = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -KVO
extension AAViewController {
    open override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
        guard let theKeyPath = keyPath , object as? WKWebView == webView else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if theKeyPath == estimatedProgressKeyPath {
            updateProgress()
        }
    }
    
    // MARK: Private
    private final func updateProgress() {
        let completed = webView.estimatedProgress == 1.0
        progressView.setProgress(completed ? 0.0 : Float(webView.estimatedProgress), animated: !completed)
        UIApplication.shared.isNetworkActivityIndicatorVisible = !completed
    }
}

//MARK: - js交互 - 原生调用Js
extension AAViewController {
    
    /// WKUserScript对象 调用JS      也可以直接调用 jsString = "nativeToJavaScript('\(params)')"
    @objc func rightBarButtonClick() {
        let jsString = "callJavaScript()"
        webView.evaluateJavaScript(jsString) { (response, error) in
            if (error != nil) {
                DLog("getINFOfROM = \(String(describing: response))")
            }
        }
    }
    
    /// 直接调用JS,传递参数
    @objc func leftBarButtonClick() {
        
        let params = ["firstObjc", "secondObjc"]
        let jsString = "changeHead('\(params)')"
        webView.evaluateJavaScript(jsString) { (response, error) in
            if (error != nil) {
                DLog("getINFOfROM = \(response ?? "")")
            }
        }
        
    }
}


//MARK: - js交互  js调用原生  获取到JS传来的参数

extension AAViewController: WKScriptMessageHandler {
    /// 交互， 监听JS的事件返回
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      if message.name == AAViewController.kListenerOther {
            DLog("Js回调的数据为:---\n\(message.body),")
            if let jsParamDic = message.body as? [String: Any] {
                if let name = jsParamDic["name"] as? String {
                    if name == JSFuctionEnum.finishActivity.rawValue {
                        self.navigationController?.popViewController(animated: true)
                    } else if name  == JSFuctionEnum.uploadVideo.rawValue {
                        let vc = PushWorksMainController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else if name == JSFuctionEnum.showPersonPage.rawValue {
                        ///他的主页
                        if let id = jsParamDic["id"] as? Int, let name = jsParamDic["nickname"] as? String, let avatar = jsParamDic["avatar"] as? String{
                            let userCenterVC = UserMCenterController()
                            let user = UserInfoModel()
                            user.id = id
                            user.nikename = name
                            user.cover_path = avatar
                            userCenterVC.user = user
                            self.navigationController?.pushViewController(userCenterVC, animated: true)
                        }
                    } else if name == JSFuctionEnum.showVideo.rawValue {
                        ///跳的视频详情
                        
                        if let id = jsParamDic["id"] as? Int, let position = jsParamDic["position"] as? Int {
                            
                            addActivityVideoListSuccessCallBack(id: id, position: position)
                            
                            addActivityVideoListFaiureCallBack()
                            
                            ///获取视频列表的数据
                            viewModel.loadActivityVideoListData()
                        }
                    }
                }
            }
        }
    }
}

///视频列表数据回调
extension AAViewController {
    func addActivityVideoListSuccessCallBack(id:Int, position: Int) {
        viewModel.activityVideoListSuccessHandler = { [weak self] videoListModel in
            guard let strongSelf = self else {return}
            let accountVideoPlayVC = SeriesPlayController()
            if let videos = videoListModel.data {
                accountVideoPlayVC.videos = videos
                for videoModel in accountVideoPlayVC.videos {
                    if let videoId = videoModel.id {
                        if id == videoId {
                            accountVideoPlayVC.currentIndex = position
                            accountVideoPlayVC.currentPlayIndex = position
                            let navVC = UINavigationController(rootViewController: accountVideoPlayVC)
                            navVC.modalPresentationStyle = .fullScreen
                            strongSelf.present(navVC, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func addActivityVideoListFaiureCallBack() {
        viewModel.activityVideoListFailureHandelr = { () in
            XSAlert.show(type: .error, text: "没有数据")
        }
    }
}

//MARK: -WKWebView的代理
extension AAViewController: WKNavigationDelegate {
    
    // 决定导航的动作，通常用于处理跨域的链接能否导航。
    // WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接单独处理。
    // 但是，对于Safari是允许跨域的，不用这么处理。
    // 这个是决定是否Request
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    // 开始接收响应
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    //用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling ,nil)
    }
    
    // 开始加载数据
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.isHidden = false
        // self.indicatorView.startAnimating()
    }
    
    // 当main frame接收到服务重定向时调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // 接收到服务器跳转请求之后调用
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.offsetHeight") { [weak self] (result, error) in
            if self != nil {
                if let webheight = result as? CGFloat {
                    DLog("网页高度= \(webheight)")
                }
            }
        }
    }
    
    //当main frame导航完成时，会回调
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.body.offsetHeight") { [weak self] (result, error) in
            if self != nil {
                if let webheight = result as? CGFloat {
                    DLog("网页高度= \(webheight)")
                }
            }
        }
    }
    
    // 当web content处理完成时，会回调
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.evaluateJavaScript("document.body.offsetHeight") { [weak self] (result, error) in
            if self != nil {
                if let webheight = result as? CGFloat {
                    DLog("网页高度= \(webheight)")
                }
            }
        }
    }
    
    // 当main frame开始加载数据失败时，会回调
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    // 当main frame最后下载数据失败时，会回调
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}
