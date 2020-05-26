//
//  CommentsContentView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CommentsContentView: UIView {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CommunityCommentCell.classForCoder(), forCellReuseIdentifier: CommunityCommentCell.cellId)
        return tableView
    }()
    let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith - 60.0, height: 50))
        view.backgroundColor = UIColor.clear
        return view
    }()
    let footlabel: UILabel = {
        let lable = UILabel(frame: CGRect(x: 0, y: 5, width: ConstValue.kScreenWdith - 60.0, height: 25))
        lable.text = "-- 查看全部评论"
        lable.textColor = UIColor(r: 153, g: 153, b: 153)
        lable.font = UIFont.systemFont(ofSize: 13)
        return lable
    }()
    lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(seeAllButtonClick), for: .touchUpInside)
        return button
    }()
    var commentSources = [VideoCommentModel]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor =  ConstValue.kViewLightColor
        addSubview(tableView)
        footerView.addSubview(footlabel)
        footerView.addSubview(seeAllButton)
        layoutFootSubviews()
        tableView.tableFooterView = footerView
        layoutTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func seeAllButtonClick() {
        
    }
    
    func setDatas(_ comments: [VideoCommentModel]) {
        commentSources = comments
        tableView.reloadData()
    }
    
   
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CommentsContentView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityCommentCell.cellId, for: indexPath) as! CommunityCommentCell
        cell.setModel(commentSources[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

// MARK: - layout
private extension CommentsContentView {
    private func layoutFootSubviews() {
        layoutFootlabel()
        layoutSeeAllButton()
    }
    
    private func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
    }
    private func layoutFootlabel() {
        footlabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(10)
        }
    }
    private func layoutSeeAllButton() {
        seeAllButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}



class CommunityCommentCell: UITableViewCell {
    
    static let cellId = "CommunityCommentCell"
    
    let userCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "小姐姐你是北京的呀,北京哪里的我也是,北京要不要约以下"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(userCommentLabel)
        layoutcommentLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutcommentLabel() {
        userCommentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(14)
            make.trailing.equalTo(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    func setModel(_ model: VideoCommentModel) {
        if let userName = model.user?.nikename, let content = model.content {
            let allString = "\(userName): \(content)"
            userCommentLabel.attributedText = TextSpaceManager.configColorString(allString: allString, attribStr: userName, UIColor.white, UIFont.boldSystemFont(ofSize: 14))
        }
        
    }
    
}
