
import UIKit
import MJRefresh
import SnapKit

/// 此类为视频列表的基础类，所有包含视频列表的页面  可以直接添加当前视图控制器的view，
/// 1.如果只是展示，直接实现代理来完成自定义cell的样式，

class NicooTableListViewController: UIViewController {
    
    static let  kNicooReuseIdentifier = "NicooCell"               // default reuseIdentifier
    static let  kCustomCellHieght: CGFloat = 50.0                 // default cellHeight
    // MARK: - public var
    public weak var delegate: NicooTableViewDelegate?
    /// 判断是否为下拉刷新，用于区分请求第一页数据时是下拉获取还是第一次请求
    public var isRefreshOperation = false
    public var tableEditing: Bool =  false {
        didSet {
            tableView.allowsMultipleSelectionDuringEditing = true
            tableView.setEditing(tableEditing, animated: true)
            tableView.tintColor = delegate?.editingSelectedViewColor()
//            let count = delegate?.listTableView(tableView, numberOfRowsInSection: 0) ?? 0
//            if count >= 15 {
//                tableView.mj_footer.isHidden = tableEditing
//            } else {
//                tableView.mj_footer.isHidden = true
//            }
//            tableView.mj_header.isHidden = tableEditing
        }
    }
    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        var cellClass: AnyClass = UITableViewCell.classForCoder()
        if let otherCell = delegate?.cellClass(for: self) {
            cellClass = otherCell
        }
        var reuseIdentifier = NicooTableListViewController.kNicooReuseIdentifier
        if let customReuseIdentifier = delegate?.cellReuseIdentifier(for: self) {
            reuseIdentifier = customReuseIdentifier
        }
        tableView.register(cellClass, forCellReuseIdentifier: reuseIdentifier)
        if delegate != nil && delegate!.haveHeaderRefreshView() {
            tableView.mj_header = refreshHeaderView
        }
        if delegate != nil && delegate!.haveFooterRefreshView() {
            tableView.mj_footer = refreshFooterView
            tableView.mj_footer.isHidden = true
        }
        tableView.currentCount = delegate?.listTableView(tableView, numberOfRowsInSection: 0) ?? 0
        tableView.shouldDisplayStatisticsView = delegate?.shouldShowStatics(self) ?? false
        return tableView
    }()
    lazy private var refreshFooterView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadMore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.delegate?.loadMoreData(weakSelf?.tableView)
        })
        loadMore?.stateLabel.font = ConstValue.kRefreshLableFont
        loadMore?.setTitle("", for: .idle)
        loadMore?.setTitle("加载中...", for: .refreshing)
        return loadMore!
    }()
    
    lazy private var refreshHeaderView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.isRefreshOperation = true                         // 执行头部刷新时，将刷新标记为true
            weakSelf?.delegate?.headerRefreshing(weakSelf?.tableView)
        })
        var gifImages = [UIImage]()
        for string in ConstValue.refreshImageNames {
            gifImages.append(UIImage(named: string)!)
        }
        mjRefreshHeader?.setImages(gifImages, for: .refreshing)
        mjRefreshHeader?.setImages(gifImages, for: .idle)
        mjRefreshHeader?.stateLabel.font = ConstValue.kRefreshLableFont
        mjRefreshHeader?.lastUpdatedTimeLabel.font = ConstValue.kRefreshLableFont
        return mjRefreshHeader!
    }()
    
    // MARK: - Life cycl
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        layoutPageSubViews()
    }

}

// MARK: - Privide func

private extension NicooTableListViewController {
    
   
}

// MARK: - Open func  /* 外部通过调用一下方法来操作当前控制器的数据，UI交互 */
 extension NicooTableListViewController {
    
    /// 刷新表
    func reloadData() {
        tableView.reloadData()
        if let rowCount = delegate?.listTableView(tableView, numberOfRowsInSection: 0), rowCount == 0 {
            NicooErrorView.showErrorMessage(.noData, on: view, clickHandler: nil)
        }
    }
    
    /// 网络请求失败时调用
    func showRequestFailedView() {
        NicooErrorView.showErrorMessage(.noNetwork, on: view) { [weak self] in
           self?.delegate?.requestDataAgain()
        }
    }
    
    /// 刷新统计
    func resetStatisticsData() {
        if let dataListCount = delegate?.listTableView(tableView, numberOfRowsInSection: 0), dataListCount > 0 {
            tableView.currentCount = dataListCount
            tableView.shouldDisplayStatisticsView = true
        }
    }
    
    /// 全选时在for循环内调用选中，只为了不暴露tableView
    ///
    /// - Parameter indexPath: indexPath
    func selectedRowAtIndexPath(_ indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    /// 取消全选时在for循环中调用
    ///
    /// - Parameter indexPath: indexPath
    func deselectedRowAtIndexPath(_ indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    /// 获取tableView选中的列表
    ///
    /// - Returns: 选中的indexPaths
    func getAllSelectedRows() -> [IndexPath]? {
        return tableView.indexPathsForSelectedRows
    }

    
    /// 根据每次获取的数据的条数 是否小于 每页的数据条数 来判断是否隐藏 tableView.mj_footer
    func hideRefreshFooterView(_ hideFooter: Bool) {
        if delegate != nil && delegate!.haveFooterRefreshView() {
            tableView.mj_footer.isHidden = hideFooter
        }
    }
    
    /// 结束刷新
    func endRefreshing() {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NicooTableListViewController: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowCount = delegate?.listTableView(tableView, numberOfRowsInSection: section) {
            return rowCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = delegate?.cellHeight(for: self) {
            return height
        }
        return NicooTableListViewController.kCustomCellHieght
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// 如果实现了自定义cell，返回自定义的cell
        if let customCell = delegate?.listTableView(self, tableView: tableView, cellForRowAt: indexPath) {
            let selectedBackground = UIView()
            selectedBackground.backgroundColor = UIColor.clear
            customCell.multipleSelectionBackgroundView = selectedBackground
            /// 自定义cell的配置
            delegate?.configCell(tableView, for: customCell, cellForRowAt: indexPath)
            return customCell
        }
        
        /// 没有自定义cellId， 返回默认的cellI
        let cell = tableView.dequeueReusableCell(withIdentifier: NicooTableListViewController.kNicooReuseIdentifier, for: indexPath)
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.clear
        cell.multipleSelectionBackgroundView = selectedBackground
        /// 自定义cell的配置
        delegate?.configCell(tableView, for: cell, cellForRowAt: indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing { // 编辑状态点击直接调用代理
            delegate?.editingListTableView(tableView, didSelectedAtIndexPath: indexPath, didSelected: tableView.indexPathsForSelectedRows)
        } else {
            delegate?.listTableView(tableView, didSelectedAtIndexPath: indexPath)
        }
    }
    
    /// 反选方法
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {  // 编辑状态下，反选回调反选方法
            delegate?.editingListTableView(tableView, didDeselectRowAt: indexPath, didSelected: tableView.indexPathsForSelectedRows)
        } else {
            delegate?.listTableView(tableView, didDeselectRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let type = UITableViewCell.EditingStyle.delete.rawValue | UITableViewCell.EditingStyle.insert.rawValue
        return UITableViewCell.EditingStyle(rawValue: type)!
    }
}

// MARK: - UIScrollViewDelegate

extension NicooTableListViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if tableView.shouldDisplayStatisticsView {
            resetStatisticsData()
//            tableView.statisticsLabel = nil
//            tableView.showStatisticsLabel(nil)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if tableView.shouldDisplayStatisticsView {
            tableView.hideStatisticsLabel()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if tableView.shouldDisplayStatisticsView {
                tableView.hideStatisticsLabel()
            }
        }
    }
}

// MARK: - layout functions

private extension NicooTableListViewController {
    
    private func layoutPageSubViews() {
        layoutTableView()
    }
    
    private func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    
}

