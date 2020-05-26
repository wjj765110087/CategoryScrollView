//
//  TopicCommentController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/9.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import MJRefresh
import NicooNetwork
import IQKeyboardManagerSwift

/// 动态评论
class TopicCommentController: QHBaseViewController {

    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAndDissmiss(_:)))
        return tap
    }()
    let clearView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    let titleLab: UILabel = {
        let lable = UILabel()
        lable.text = "评论"
        lable.textColor = UIColor.white
        lable.backgroundColor = UIColor(red: 16/255.0, green: 13/255.0, blue: 31/255.0, alpha: 0.9)
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 16)
        return lable
    }()
    private lazy var  closeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        button.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        return button
    }()
    private let commentbgView: UIView = {
        let view = UIView()
        view.backgroundColor = ConstValue.kVcViewColor
        return view
    }()
    private lazy var videoCommentView: VideoCommentView = {
        let view = VideoCommentView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 50))
        view.backgroundColor = UIColor(red: 16/255.0, green: 13/255.0, blue: 31/255.0, alpha: 0.9)
        return view
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .grouped)
        table.backgroundColor = UIColor(red: 16/255.0, green: 13/255.0, blue: 31/255.0, alpha: 0.9)   //ConstValue.kVcViewColor
        table.estimatedRowHeight = 100
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.tableFooterView = UIView.init(frame: CGRect.zero)
        table.register(CommentSectionHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: CommentSectionHeaderView.reuseId)
        table.register(CommentsSectionFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: CommentsSectionFooterView.reuseId)
        table.register(CommentCell.classForCoder(), forCellReuseIdentifier: CommentCell.cellId)
        table.mj_footer = loadMoreView
        table.mj_header = refreshView
        return table
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadMore =  MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextPage()
        })
        loadMore?.isHidden = true
        loadMore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadMore!
    }()
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.loadFirstPage()
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
    var userClickHandler:((_ user: UserInfoModel?)->Void)?
    var buyVipClickHandler:(() ->Void)?
    
    var topicId: Int = 0
    var userId: Int?
    var commentMsg = ""
    
    var viewModel = CommentViewModel()
    
    var videoComents = [VideoCommentModel]()
    
    var currentModel: VideoCommentModel?
    
    var currentSection: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearView.addGestureRecognizer(tapGesture)
        view.addSubview(clearView)
        view.addSubview(titleLab)
        view.addSubview(closeBtn)
        view.addSubview(tableView)
        view.addSubview(commentbgView)
        commentbgView.addSubview(videoCommentView)
        layoutPageSubviews()
        addCommentViewCallBackHandler()
        addViewModelCallBack()
        loadData()
    }
    
    private func endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
}

// MARK: - 网络请求
extension TopicCommentController {
    
    ///用户视频评论列表
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(self.view)
        let params = [TopicCommentListApi.kTopic_Id: topicId]
        viewModel.loadTopicCommentListApi(params: params)
    }
    private func loadFirstPage() {
        let params = [TopicCommentListApi.kTopic_Id: topicId]
        viewModel.loadTopicCommentListApi(params: params)
    }
    private func loadNextPage() {
        let params = [TopicCommentListApi.kTopic_Id: topicId]
        viewModel.loadTopicCommentListNextPage(params: params)
    }
    
    ///用户评论视频
    private func commentVideo(content: String, topicId: Int) {
        let params: [String : Any] = [TopicCommentApi.kTopic_Id: topicId, TopicCommentApi.kContent: content]
        viewModel.loadTopicCommentApi(params: params)
    }
    /// 用户回复评论
    private func answerComment(content: String, commentId: Int) {
        let params: [String : Any] = [TopicCommentApi.kTopic_Id: topicId, TopicCommentApi.kComment_id: commentId,TopicCommentApi.kContent: content]
        viewModel.loadTopicCommentApi(params: params)
    }
    
    ///用户视频子评论列表
    private func loadCommnetSonData(_ commentModel: VideoCommentModel?) {
        let params = [TopicSonCommentListApi.kTopic_Id: topicId, TopicSonCommentListApi.kComment_id: videoComents[currentSection].id ?? 0, TopicSonCommentListApi.kPageNumber: 1]
        viewModel.loadTopicSonCommentListApi(params: params)
    }
    
    private func loadCommnetSonNextPage(_ commentModel: VideoCommentModel?) {
        let params = [TopicSonCommentListApi.kTopic_Id: topicId, TopicSonCommentListApi.kComment_id: commentModel?.id ?? 0,TopicSonCommentListApi.kPageNumber: commentModel?.answerPageNumber ?? 1]
        viewModel.loadTopicSonCommentListNextPage(params: params)
    }
    
    ///用户视频评论点赞
    private func commentLike(commentId: Int) {
        let params = [TopicCommentLikeApi.kComment_id: commentId]
        viewModel.loadTopicCommentLikeData(params: params)
    }
    /// 提示
    private func showTipAlert(_ msg: String, _ title: String?) {
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let actionCancle = UIAlertAction.init(title: "好哒", style: .default, handler: nil)
        let verb = UIAlertAction.init(title: "充值VIP", style: .default) { (action) in
            self.buyVipClickHandler?()
        }
        alert.addAction(actionCancle)
        alert.addAction(verb)
        alert.modalPresentationStyle = .fullScreen
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - 数据回调
extension TopicCommentController {
    
    func addViewModelCallBack() {
        
        viewModel.videoCommentListSuccessHandler = { [weak self] commentList in
            guard let strongSelf = self else {return}
            if let data = commentList.data, let currentPage = commentList.current_page {
                if currentPage == 1 {
                    strongSelf.videoComents = data
                    if data.count == 0 {
                        NicooErrorView.showErrorMessage("暂无相关评论，快来说两句吧 ～", on: strongSelf.view, customerTopMargin: ConstValue.kScreenHeight * 0.45, clickHandler: nil)
                    }
                    strongSelf.perform(#selector(strongSelf.reloadData), with: nil, afterDelay: 0.5)
                }  else {
                    strongSelf.videoComents.append(contentsOf: data)
                }
                strongSelf.titleLab.text = "评论(\(commentList.total ?? 0))"
                strongSelf.loadMoreView.isHidden = data.count < VideoCommentListApi.kDefaultCount
            }
            strongSelf.endRefreshing()
            strongSelf.tableView.reloadData()
        }
        
        viewModel.videoCommentListFailureHandelr = { [weak self] errorMsg in
            guard let strongSelf = self else {return}
            NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view, topMargin: ConstValue.kScreenHeight * 0.35, clickHandler: {
                strongSelf.loadData()
            })
        }
        /// 评论成功回调
        viewModel.videoCommentSuccessHandler = { [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.videoCommentView.textInputView.text = ""
            if strongSelf.currentModel != nil {
                strongSelf.loadCommnetSonData(strongSelf.currentModel)
            } else {
                strongSelf.loadData()
                XSProgressHUD.showSuccess(msg: "评论成功", onView: strongSelf.view, animated: true)
            }
            strongSelf.currentModel = nil
        }
        
        viewModel.videoCommentFailureHandelr = { [weak self] errorMsg in
            self?.showTipAlert("\r \(errorMsg)", nil)
        }
        
        /// 回复列表
        viewModel.videoCommentSonListSuccessHandler = { [weak self] answerList in
            guard let strongSelf = self else {return}
            strongSelf.loadSonCommentListSuccess(answerList)
        }
        
        viewModel.videoCommentLikeSuccessHandler = { [weak self]  in
            guard let strongSelf = self else { return }
            let model = strongSelf.videoComents[strongSelf.currentSection]
            if (model.is_like ?? 0) == 1 {
                model.is_like = 0
                model.like = (model.like ?? 0) - 1
            } else {
                model.is_like = 1
                model.like = (model.like ?? 0) + 1
            }
            strongSelf.tableView.reloadSections([strongSelf.currentSection], with: .automatic)
        }
    }
    func loadSonCommentListSuccess(_ listModel: CommentAnswerListModel) {
        let commentModel = videoComents[currentSection]
        if let datas = listModel.data ,let currentPage = listModel.current_page {
            if currentPage == 1 {
                commentModel.comment = datas
                if commentModel.isOpen ?? false {  // 打开了，页码 +1
                    commentModel.answerPageNumber = currentPage + 1
                    commentModel.isAllAnswers = datas.count < VideoSonCommentListApi.kDefaultCount
                } else {  // 刚收起，重置页码
                    commentModel.answerPageNumber = 1
                }
            } else {
                commentModel.comment?.append(contentsOf: datas)
                commentModel.isAllAnswers = datas.count < TopicSonCommentListApi.kDefaultCount
                commentModel.answerPageNumber = currentPage + 1
            }
            
            tableView.reloadSections([currentSection], with: .automatic)
        }
        
    }
    
}

// MARK: -点击事件
extension TopicCommentController {
    
    /// 添加评论栏点击回调
    func addCommentViewCallBackHandler() {
        videoCommentView.sendCommentTextHandler = { [weak self] (text) in
            guard let strongSelf = self else { return }
            strongSelf.commentMsg = text
            if let commentId = strongSelf.currentModel?.id {
                let answer = text.replacingOccurrences(of: "@\(strongSelf.currentModel?.user?.nikename ?? ""): ", with: "")
                strongSelf.answerComment(content: answer, commentId: commentId)
            } else {
                strongSelf.commentVideo(content: text, topicId: strongSelf.topicId)
            }
        }
    }
    @objc func tapAndDissmiss(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeBtnAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func randomColor(_ userId: Int) -> String {
        let colors = ["#e57373",
                      "#f06292",
                      "#ba68c8",
                      "#9575cd",
                      "#7986cb",
                      "#64b5f6",
                      "#4fc3f7",
                      "#4dd0e1",
                      "#4db6ac",
                      "#81c784",
                      "#aed581",
                      "#ff8a65",
                      "#d4e157",
                      "#ffd54f",
                      "#ffb74d",
                      "#a1887f",
                      "#90a4ae"]
        return colors[Int(userId%17)]
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TopicCommentController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
        return tableView.rowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return videoComents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = videoComents[section]
        if let sonComment = model.comment {
            if sonComment.count > 0 {
                if model.isOpen ?? false {
                    return sonComment.count
                } else {
                    return 1
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.cellId, for: indexPath) as! CommentCell
        let commentModel = videoComents[indexPath.section]
        if let sonComments = commentModel.comment {
            let sonModel = sonComments[indexPath.row]
            if sonModel.user_id != nil {
                sonModel.isZZ = sonModel.user_id == userId
            }
            cell.setModel(model: sonModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentSectionHeaderView.reuseId) as! CommentSectionHeaderView
        let model = videoComents[section]
        header.setModel(model: model)
        header.buttonClickHandler = { [weak self] index in
            guard let strongSelf = self else {return}
            if index == 102 {
               strongSelf.userClickHandler?(model.user)
            } else if index == 101 {
                ///视频评论点赞
                strongSelf.currentModel = model
                strongSelf.currentSection = section
                strongSelf.commentLike(commentId: model.id ?? 0)
            } else if index == 103 {  ///对该评论进行评论
                strongSelf.videoCommentView.textInputView.becomeFirstResponder()
                strongSelf.videoCommentView.textInputView.text = "@\(model.user?.nikename ?? ""): "
                strongSelf.currentSection = section
                strongSelf.currentModel = model
            }
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let commentModel = videoComents[section]
        if let sonComments = commentModel.comment, sonComments.count > 1 {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentsSectionFooterView.reuseId) as! CommentsSectionFooterView
            if commentModel.isAllAnswers == true  { /// 已经展开所有回复
                footer.spreadOutLabel.text = "收起回复"
                footer.downButton.isSelected = true
            } else { // 还可以继续展开
                footer.spreadOutLabel.text = "展示更多回复"
                footer.downButton.isSelected = false
            }
            footer.buttonClickHandler = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.currentSection = section
                if commentModel.isAllAnswers == true { /// 已经展开所有回复
                    commentModel.isOpen = false
                    commentModel.isAllAnswers = false
                    commentModel.answerPageNumber = 1
                    //                    strongSelf.viewModel.resetCommentAnswersApiPage()
                    strongSelf.loadCommnetSonData(commentModel)
                    
                } else { // 还可以继续展开
                    commentModel.isOpen = true
                    if commentModel.answerPageNumber == 1 {
                        strongSelf.loadCommnetSonData(commentModel)
                    } else {
                        strongSelf.loadCommnetSonNextPage(commentModel)
                    }
                    
                }
            }
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = CommentSectionHeaderView.headerHeight
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let sonComments = videoComents[section].comment, sonComments.count > 1 {
            return CommentsSectionFooterView.footerHeight
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Layout
private extension TopicCommentController {
    
    func layoutPageSubviews() {
        layoutClearView()
        layoutCommentBgView()
        layoutCommentView()
        layoutTableView()
        layoutTitleLable()
        layoutCloseBtn()
    }
    
    func layoutClearView() {
        clearView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kScreenHeight * 0.35)
        }
    }
    
    func layoutTitleLable() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(tableView.snp.top)
            make.height.equalTo(50)
        }
    }
    
    func layoutCloseBtn() {
        closeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLab)
            make.trailing.equalTo(-10)
            make.width.height.equalTo(40)
        }
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(videoCommentView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(clearView.snp.bottom)
        }
    }
    func layoutCommentBgView() {
        commentbgView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(UIDevice.current.isiPhoneXSeriesDevices() ? 83 : 49)
        }
    }
    func layoutCommentView() {
        videoCommentView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(49)
        }
    }
}
