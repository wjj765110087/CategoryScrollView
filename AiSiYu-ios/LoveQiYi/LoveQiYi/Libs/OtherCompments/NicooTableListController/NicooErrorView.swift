
import UIKit
import SnapKit

public enum NicooErrorType: NSInteger {
    case noData = 1              // 数据为空
    case noNetwork              // 网络错误
    case timeout               // 请求超时
    case defaultError          // 未知错误
}

open class NicooErrorView: UIView {

    private let imageView: UIImageView = UIImageView()
    private let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = UIColor.lightGray
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        return label
    }()
    lazy private var refreshLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.isHidden = true
        label.text = "请点击页面刷新"
        label.textColor = UIColor.lightGray
        return label
    }()
    private var clickHandler: (() -> Void)?

    // MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(label)
        addSubview(refreshLabel)
        layoutPageSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    open class func showErrorMessage(_ errorType: NicooErrorType, on view: UIView, topMargin: CGFloat? = 0, clickHandler: (() -> Void)?) {
        removeErrorMeesageFrom(view)

        let errorView = NicooErrorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        errorView.titleLabel.isHidden = true
        errorView.clickHandler = clickHandler
        if errorType == .noData {
            errorView.imageView.image = UIImage(named: "GlobalNOData")
            errorView.label.text = "发现0条数据!"
        } else {
            errorView.imageView.image = UIImage(named: "noNetWorkShow")
            errorView.label.text = "通往污次元的网络中断了!"
            errorView.refreshLabel.isHidden = false
            errorView.addGestureRecognizer(UITapGestureRecognizer(target: errorView, action: #selector(NicooErrorView.viewBeenTapped(_:))))
        }
        view.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            if topMargin != nil, topMargin! > 0 {
                make.top.equalTo(topMargin!)
            } else {
                make.centerY.equalToSuperview()
            }
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    open class func showErrorMessage(_ message: String, on view: UIView, customerTopMargin: CGFloat?,clickHandler: (() -> Void)?) {
        removeErrorMeesageFrom(view)
        
        let errorView = NicooErrorView(frame: view.frame)
        errorView.imageView.isHidden = true
        errorView.label.isHidden = true
        errorView.refreshLabel.isHidden = true
        errorView.titleLabel.text = message
        errorView.titleLabel.numberOfLines = 3
        view.addSubview(errorView)
        errorView.clickHandler = clickHandler
        errorView.addGestureRecognizer(UITapGestureRecognizer(target: errorView, action: #selector(NicooErrorView.viewBeenTapped(_:))))
        errorView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            if customerTopMargin != nil, customerTopMargin! > 0 {
                make.top.equalTo(customerTopMargin!)
            } else {
                make.centerY.equalToSuperview()
            }
            make.bottom.equalTo(view.snp.bottom)
        }
    }

   open class func removeErrorMeesageFrom(_ view: UIView) {
        for subview in view.subviews {
            if subview is NicooErrorView {
                subview.removeFromSuperview()
                break
            }
        }
    }

    // MARK: - User actions
    
    @objc fileprivate func viewBeenTapped(_ gesture: UITapGestureRecognizer) {
        self.clickHandler?()
    }
    
    // MARK: - Private functions

    private func layoutPageSubviews() {
        layoutTitleLabel()
        layoutImageView()
        layoutLabel()
        layoutRefreshBtn()
    }

    private func layoutTitleLabel() {
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(0)
            make.leading.equalTo(0)
        }
    }
    
    private func layoutImageView() {
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(118)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    private func layoutLabel() {
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(0)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(38)
        }
    }

    private func layoutRefreshBtn() {
        refreshLabel.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
}
