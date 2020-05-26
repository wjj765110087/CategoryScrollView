
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
        label.textColor = UIColor(white: 0.8, alpha: 1)
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = UIColor(r: 153, g: 153, b: 153)
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
    lazy private var refreshButton: UIButton = {
       let button = UIButton(type: .custom)
       button.layer.cornerRadius = 20
       button.layer.masksToBounds = true
       button.backgroundColor = ConstValue.kVcViewColor
       button.layer.borderWidth = 1
       button.layer.borderColor = UIColor.init(r: 17, g: 118, b: 242).cgColor
       button.isUserInteractionEnabled = false
       button.setTitle("刷新界面", for: .normal)
       button.setTitleColor(UIColor.white, for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
       return button
    }()
    private var clickHandler: (() -> Void)?

    // MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(label)
        addSubview(refreshLabel)
        addSubview(refreshButton)
        layoutPageSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    open class func showErrorMessage(_ errorType: NicooErrorType, on view: UIView, topMargin: CGFloat? = 0, clickHandler: (() -> Void)?) {
        removeErrorMeesageFrom(view)

        let height: CGFloat = view.frame.height - (topMargin ?? 0.0)
        let errorView = NicooErrorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: height))
        errorView.titleLabel.isHidden = true
        errorView.clickHandler = clickHandler
        if errorType == .noData {
            errorView.imageView.image = UIImage(named: "EmptyData")
            errorView.label.text = "发现0条数据"
            errorView.refreshLabel.isHidden = false
        } else {
            errorView.imageView.image = UIImage(named: "GlobalNONetwork")
            errorView.label.text = "网络请求失败!"
            errorView.refreshLabel.isHidden = false
        }
        errorView.refreshButton.isHidden = true
        errorView.addGestureRecognizer(UITapGestureRecognizer(target: errorView, action: #selector(NicooErrorView.viewBeenTapped(_:))))
        view.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            if topMargin != nil, topMargin! > 0 {
                 make.top.equalTo(topMargin!)
            } else {
                make.centerY.equalToSuperview()
            }
            make.height.equalTo(height)
        }
    }
    
    open class func showErrorMessage(_ errorType: NicooErrorType, _ textMsg: String, on view: UIView, topMargin: CGFloat? = 0, clickHandler: (() -> Void)?) {
        removeErrorMeesageFrom(view)
        
        let height: CGFloat = view.frame.height - (topMargin ?? 0.0)
        let errorView = NicooErrorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: height))
        errorView.titleLabel.isHidden = true
        errorView.clickHandler = clickHandler
        if errorType == .noData {
            errorView.imageView.image = UIImage(named: "EmptyData")
            errorView.label.text = textMsg
            errorView.refreshLabel.isHidden = true
            errorView.refreshButton.isHidden = false
        } else {
            errorView.imageView.image = UIImage(named: "GlobalNONetwork")
            errorView.label.text = "网络请求失败!"
            errorView.refreshLabel.isHidden = true
            errorView.refreshButton.isHidden = true
        }
        errorView.addGestureRecognizer(UITapGestureRecognizer(target: errorView, action: #selector(NicooErrorView.viewBeenTapped(_:))))
        view.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            if topMargin != nil, topMargin! > 0 {
                make.top.equalTo(topMargin!)
            } else {
                make.centerY.equalToSuperview()
            }
            make.height.equalTo(height)
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
        errorView.refreshButton.isHidden = true
        errorView.addGestureRecognizer(UITapGestureRecognizer(target: errorView, action: #selector(NicooErrorView.viewBeenTapped(_:))))
        errorView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            if customerTopMargin != nil, customerTopMargin! > 0 {
                make.top.equalTo(customerTopMargin!)
            } else {
                make.centerY.equalToSuperview()
            }
            make.height.equalTo(150)
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
        layoutRefreshButton()
    }

    private func layoutTitleLabel() {
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(0)
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
            make.top.equalTo(imageView.snp.bottom).offset(10)
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
    
    private func layoutRefreshButton() {
        refreshButton.snp.makeConstraints { (make) in
            make.top.equalTo(refreshLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(101)
            make.height.equalTo(40)
        }
    }
    
}
