

import UIKit
import AssetsLibrary
import Photos

class QHTabBarViewController: QHTabBarController {
    
    var dataArray: [QHTabBar] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false);
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.view.backgroundColor = UIColor.clear
        
        p_setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private
    
    func p_setup() {
        let tabBarHome = QHTabBar.init(storyboardName: "Home", title: "首页", icon: "", selectIcon: "")
        let tabBarFind = QHTabBar.init(storyboardName: "Find", title: "社区", icon: "", selectIcon: "")
        let tabBarSearch = QHTabBar.init(storyboardName: "Message", title: "发现", icon: "", selectIcon: "")
        let tabBarMine = QHTabBar.init(storyboardName: "Mine", title: "我", icon: "", selectIcon: "")
        dataArray = [tabBarHome, tabBarFind, tabBarSearch ,tabBarMine]
        
        for value in dataArray {
            addChildVCWithStoryboardName(tabBar: value)
        }
        self.tabBarView.reloadData()
        self.selectIndexView(index: 1)
        p_setTabBarViewColor()
    }
    
    func p_setTabBarViewColor() {
        var bScrollEnabled = true
        if self.selectedIndex == 0 {
            self.tabBarView.backgroundColor = UIColor(r: 30, g: 17, b: 23, a: 0.99)
        }
        else {
            bScrollEnabled = false
            self.tabBarView.backgroundColor = UIColor.black
        }
        if self.navigationController?.viewControllers.first is QHRootScrollViewController {
            let vc = self.navigationController?.viewControllers.first as! QHRootScrollViewController
            vc.mainScrollV.isScrollEnabled = false
        }
    }
    
    //MARK: Action
    
    func navigationControllerShouldPush() -> Bool {
        if selectedIndex == 0 {
            return true
        }
        return false
    }
    
    func navigationControllerDidPushBegin() -> Bool {
        var b = false
        let vc = self.children[selectedIndex]
        switch selectedIndex {
        case 0: do {
            let v: QHHomeViewController = vc as! QHHomeViewController
            v.showDetails()
            b = true
        }
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default:
            break
        }
        return b
    }
    
    //MARK: QHTabBarDataSource
    override func tabBarViewForRows(_ tabBarView: QHTabBarView) -> [QHTabBar] {
        return dataArray
    }
    
    ///加号按钮
    override func tabBarViewForMiddle(_ tabBarView: QHTabBarView, size: CGSize) -> UIView? {
        
        let hd = UIDevice.current.isiPhoneXSeriesDevices() ? 5 : -5 as CGFloat
        let w = 45 as CGFloat
        let wd = CGFloat(size.width - 45)/2
        let h = CGFloat(44)
        let middleBtn = UIButton(frame: CGRect(x: wd, y: hd, width: w, height:h))
        middleBtn.setImage(UIImage(named: "centerIcon"), for: .normal)
        middleBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        middleBtn.backgroundColor = UIColor.clear
        middleBtn.addTarget(self, action: #selector(self.goRecordViewAction(_:)), for: .touchUpInside)
        
        return middleBtn
    }
    
    //MARK: QHTabBarDelegate
    override func tabBarView(_ tabBarView: QHTabBarView, didSelectRowAt index: Int) {
        if self.selectedIndex == index {
            //let vc = self.children[selectedIndex]
            switch selectedIndex {
            case 0: do {
               // let v: QHHomeViewController = vc as! QHHomeViewController
                //v.mainCV.reloadData()
                //v.mainCV.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
                break
            case 1:
                break
            case 2:
                break
            case 3:
                break
            default:
                break
            }
        }
        else {
            self.selectedIndex = index
            p_setTabBarViewColor()
        }
    }
    
    //MARK: Action
    ///加号按钮的点击事件
    @objc func goRecordViewAction(_ sender: Any) {
//        (self.navigationController as! QHNavigationController).changeTransition(true)
//        let vc = PushWorksMainController()
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let typeChoseVC = PushTypeChoseController()
        typeChoseVC.modalPresentationStyle = .overCurrentContext
        typeChoseVC.definesPresentationContext = true
        self.present(typeChoseVC, animated: false, completion: nil)
        typeChoseVC.pushtypeChoseHandler = { typeId in
            (self.navigationController as! QHNavigationController).changeTransition(false)
            if typeId == 0 {
                let imagePushVC = PushImagesController()
                imagePushVC.firstSetUI = true
                self.navigationController?.pushViewController(imagePushVC, animated: true)
            } else if typeId == 1 {
                self.choseVideoFromLibrary()
            } else {
                let recordVc = QHRecordViewController()
                self.navigationController?.pushViewController(recordVc, animated: true)
            }
            typeChoseVC.dismiss(animated: false, completion: nil)
        }
    }
    
    /// 从相册选择视频
    func choseVideoFromLibrary() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Thumbnail", bundle: nil)
        let vc: ThumbnailViewController = storyboard.instantiateViewController(withIdentifier: "Thumbnail") as! ThumbnailViewController
        //        let nav = QHNavigationController(rootViewController: vc)
        vc.videoChoseHandler = { (asset) in
            DLog("videoChoseHandler.asset= \(asset)")
            self.libraryVideoEditor(asset: asset)
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    /// 选择视频编辑
    private func libraryVideoEditor(asset: PHAsset) {
        switch asset.mediaType {
        case .video:
            let storyboard: UIStoryboard = UIStoryboard(name: "VT", bundle: nil)
            let vc: VTViewController = storyboard.instantiateViewController(withIdentifier: "VT") as! VTViewController
            vc.asset = asset
            vc.sourceType = .Source_Library
            //vc.camareVideoPath = FileManager.videoExportURL
            self.navigationController?.pushViewController(vc, animated: false)
        default:
            break
        }
    }
}


