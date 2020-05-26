//
//  LicenseController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/10.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import WebKit

/// 上传须知
class LicenseController: UIViewController {
    
    static let kListener = "JSListener"
    static let kListenerFenxiao = "JSListenerFX"
    private lazy var wkConfig: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        //声明一个WKUserScript对象
        let params = ["" : ""]
        let script = WKUserScript.init(source: "function callJavaScript() {nativeToJavaScript('\(params)');}", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        return config
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 100, width: ConstValue.kScreenWdith, height: ConstValue.kScreenWdith * 9/16), configuration: wkConfig)
        webView.navigationDelegate = self
        webView.isOpaque = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.backgroundColor = UIColor.darkText
        // 用WeakScriptMessageDelegate(self) 代替self,解决内存泄漏的问题
        webView.configuration.userContentController.add(WeakScriptDelegate(self), name: LicenseController.kListener)
        webView.configuration.userContentController.add(WeakScriptDelegate(self), name: LicenseController.kListenerFenxiao)
        return webView
    }()
    var urlString: String?
    var navTitle: String?
    /// 是否是录制操作进入此页面
    var recordAction: Bool = false
    
    deinit {
        DLog("vc is deinit")    // 出站的时候，这里没走，说明当前控制器没有被释放调，存在内存泄漏
        webView.configuration.userContentController.removeScriptMessageHandler(forName: LicenseController.kListener)
        webView.configuration.userContentController.removeScriptMessageHandler(forName: LicenseController.kListenerFenxiao)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(webView)
        layoutWebView()
        if let urlstr = urlString {
            if let url = URL(string: urlstr) {
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.navigationController as? QHNavigationController)?.changeTransition(false)
    }
    
    private func layoutWebView() {
        webView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(0)
        }
    }
    
    private func goApplyUploadRight() {
        let applyVc = ApplyForUploadController()
        navigationController?.pushViewController(applyVc, animated: true)
    }
    
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func goInvited() {
        let vc = PopularizeController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - js交互  js调用原生  获取到JS传来的参数

extension LicenseController: WKScriptMessageHandler {
    /// 交互， 监听JS的事件返回
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == LicenseController.kListener {
            DLog("Js回调的数据为:---\(message.body), 当前线程是：\(Thread.current)")
            if recordAction {
                goApplyUploadRight()
            } else {
                goBack()
            }
        }
        if message.name == LicenseController.kListenerFenxiao {
            DLog("Js回调的数据为:---\(message.body), 当前线程是：\(Thread.current)")
            goInvited()
        }
    }
}

extension LicenseController: WKNavigationDelegate {
    
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
    
    }
    
    // 当main frame接收到服务重定向时调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // 接收到服务器跳转请求之后调用
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }
    
    //当main frame导航完成时，会回调
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    // 当web content处理完成时，会回调
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    
    // 当main frame开始加载数据失败时，会回调
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    // 当main frame最后下载数据失败时，会回调
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

    }
}

