//
//  AdvertWebController.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/28.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit
import WebKit
import NicooNetwork

/// 支付网页
class PayWebController: UIViewController {
    
    private lazy var navBar: CNavigationBar = {
        let bar = CNavigationBar()
        bar.backgroundColor = kBarColor
        bar.titleLabel.text = "支付"
        bar.backButton.isHidden = false
        bar.delegate = self
        return bar
    }()

    private lazy var wkConfig: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        return config
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 100, width: screenWidth, height: screenWidth * 9/16), configuration: wkConfig)
        webView.navigationDelegate = self
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.backgroundColor = UIColor.darkText
        return webView
    }()
    var urlString: String?
    var navTitle: String?
    var ad_id = 0
    /// 处理导航栏
    var navHidenCallBackHandler:((_ isAnimated: Bool) -> Void)?
    
    deinit {
        print("vc is deinit")    // 出站的时候，这里没走，说明当前控制器没有被释放调，存在内存泄漏
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBar)
        title = navTitle ?? ""
        view.backgroundColor = UIColor.white
        view.addSubview(webView)
        layoutNavBar()
        layoutWebView()
        let url = URL(string: urlString ?? "")
        
        ///https://qnahke.fengniaoqp.com/pay_rc.html?qrcode=https://qnahke.fengniaoqp.com/api/rechg/jyUrl?num=269451&amount=29.00&oid=10A1DEvZKSGImo
        webView.load(URLRequest(url: url ?? URL(string: ConstValue.kAppDownLoadLoadUrl)!))
    }
    
    
    private func layoutWebView() {
        webView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
    }
    
    private func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
}

// MARK: - QHNavigationBarDelegate
extension PayWebController:  CNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension PayWebController: WKNavigationDelegate {
    
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
        XSProgressHUD.hide(for: view, animated: false)
    }
    
    //用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling ,nil)
    }
    
    // 开始加载数据
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //Note---对alipays相关scheme处理
        //Note---若遇到支付宝相关scheme,则跳到本地支付宝app
        let requestUrl = webView.url?.absoluteString
        if let reqUrl = requestUrl {
            if (reqUrl.hasPrefix("alipays://") || reqUrl.hasPrefix("alipay://")) {
                //Note跳转到支付宝app
                let bsucc = UIApplication.shared.openURL(URL(string: reqUrl)!)
                //Note:如果跳转失败，则跳转itunes下载支付宝app
                if !bsucc {
                    let alertVC = UIAlertController.init(title: "提示", message: "未检测安装支付宝客户端，请安装重试", preferredStyle: .actionSheet)
                    let installAction = UIAlertAction.init(title: "去安装", style: .default) { (action) in
                        let urlstr = "https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8"
                        let downLoadURL = URL.init(string: urlstr)
                        UIApplication.shared.openURL(downLoadURL!)
                    }
                    let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
                        
                    }
                    alertVC.addAction(installAction)
                    alertVC.addAction(cancelAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
                
            }
            ///Note 跳转到微信
            if (reqUrl.hasPrefix("weixin://")) {
                //Note跳转到支付宝app
                let bsucc = UIApplication.shared.openURL(URL(string: reqUrl)!)
                //Note:如果跳转失败，则跳转itunes下载支付宝app
                if !bsucc {
                    let alertVC = UIAlertController.init(title: "提示", message: "未检测安装微信客户端，请安装重试", preferredStyle: .actionSheet)
                    let installAction = UIAlertAction.init(title: "去安装", style: .default) { (action) in
                        let urlstr = "https://apps.apple.com/cn/app/wei/id414478124"
                        let downLoadURL = URL.init(string: urlstr)
                        UIApplication.shared.openURL(downLoadURL!)
                    }
                    let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
                        
                    }
                    alertVC.addAction(installAction)
                    alertVC.addAction(cancelAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
        
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
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
        XSProgressHUD.hide(for: view, animated: false)
    }
    
    // 当web content处理完成时，会回调
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {

    }
    
    // 当main frame开始加载数据失败时，会回调
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        XSProgressHUD.hide(for: view, animated: false)
    }
    
    // 当main frame最后下载数据失败时，会回调
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        XSProgressHUD.hide(for: view, animated: false)
    }
}

