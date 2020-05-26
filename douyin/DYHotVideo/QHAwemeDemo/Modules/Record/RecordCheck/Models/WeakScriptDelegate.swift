

import UIKit
import WebKit

/// 为了解决内存泄漏，将 ScriptMessageDelegate 作为交互的代理对象，替代web所在的VC
class WeakScriptDelegate: NSObject, WKScriptMessageHandler {
    
    weak var scriptDelegate: WKScriptMessageHandler?
    
    init(_ scriptDelegate: WKScriptMessageHandler) {
        self.scriptDelegate = scriptDelegate
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
    
    deinit {
        DLog("WeakScriptDelegate is deinit")
    }
}


