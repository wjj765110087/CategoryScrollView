//
//  TopicCellFooter.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/8.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class TopicCellFooter: UITableViewHeaderFooterView {

    static let footerId = "TopicCellFooter"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor =  ConstValue.kViewLightColor
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CommunityCommentCell.classForCoder(), forCellReuseIdentifier: CommunityCommentCell.cellId)
        return tableView
    }()
    let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith - 60.0, height: 35))
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
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor =  ConstValue.kViewLightColor
        return view
    }()
    lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(seeAllButtonClick), for: .touchUpInside)
        return button
    }()
    var itemActionHandler:(()->Void)?
    
    var commentSources = [VideoCommentModel]()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        addSubview(tableView)
        addSubview(lineView)
        footerView.addSubview(footlabel)
        footerView.addSubview(seeAllButton)
        layoutFootSubviews()
        tableView.tableFooterView = footerView
        layoutTableView()
        layoutLineView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func seeAllButtonClick() {
        itemActionHandler?()
    }
    
    func setDatas(_ comments: [VideoCommentModel]) {
        commentSources = comments
        tableView.reloadData()
    }
    
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TopicCellFooter: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentSources.count >= 2 ? 2 : commentSources.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityCommentCell.cellId, for: indexPath) as! CommunityCommentCell
        cell.setModel(commentSources[indexPath.row])
        cell.selectedBackgroundView = UIView()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemActionHandler?()
    }
}

// MARK: - layout
private extension TopicCellFooter {
    private func layoutFootSubviews() {
        layoutFootlabel()
        layoutSeeAllButton()
    }
    func layoutLineView() {
        lineView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    private func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(5)
            make.bottom.equalTo(-25)
        }
    }
    private func layoutFootlabel() {
        footlabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.centerY.equalToSuperview()
        }
    }
    private func layoutSeeAllButton() {
        seeAllButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}



class TopicCellLineFooter: UITableViewHeaderFooterView {
    
    static let footerId = "TopicCellLineFooter"
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor =  ConstValue.kViewLightColor
        contentView.backgroundColor =  ConstValue.kViewLightColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
