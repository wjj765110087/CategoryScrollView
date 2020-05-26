
import UIKit
import Photos

/// 视频选择列表
class ThumbnailViewController: QHBaseViewController {
    
    @IBOutlet weak var alCollectionView: ALCollectionView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "视频选择"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    var videoChoseHandler:((_ asset: PHAsset) -> Void)?
    var cancleChoseHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        layoutPageSubviews()
       
        self.initCollectionView()
    }
    
    private func initCollectionView() {
        alCollectionView.didOverScrollTop = { [weak self] in
            self?.close()
        }
        alCollectionView.didSelectItemAt = { [weak self] (collectionView: UICollectionView, indexPath: IndexPath) in
            if let cell: ALCollectionViewCell = collectionView.cellForItem(at: indexPath) as? ALCollectionViewCell {
                if let asset: PHAsset = cell.asset {
                   self?.goBack(asset: asset)
                }
            }
        }
        alCollectionView.initList(type: .video) { (isAuthorization: Bool) in
            DLog("isAuthorization: \(isAuthorization)")
        }
    }
    
    private func goBack(asset: PHAsset) {
        self.dismiss(animated: true) {
            DLog("allready dissMiss")
            self.videoChoseHandler?(asset)
        }
    }
    
    private func close() {
        dismiss(animated: true) {
            self.cancleChoseHandler?()
        }
    }
    
}

// MARK: - QHNavigationBarDelegate
extension ThumbnailViewController:  QHNavigationBarDelegate  {
    
    func backAction() {
        dismiss(animated: true) {
            self.cancleChoseHandler?()
        }
    }
}

// MARK: - Layout
private extension ThumbnailViewController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutCollection()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutCollection() {
        alCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
}
