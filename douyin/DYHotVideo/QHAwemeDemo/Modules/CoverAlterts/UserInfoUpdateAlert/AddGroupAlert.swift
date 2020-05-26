//
//  AddGroupAlert.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/18.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class AddGroupAlert: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var didClickRowHandler:((_ model: AddGroupLinkModel) ->())?
    
    var models: [AddGroupLinkModel] = [AddGroupLinkModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(RowCell.classForCoder(), forCellReuseIdentifier: RowCell.cellId)
        if let addGroupLinkModels = SystemMsg.share().addGroupLinkModels, addGroupLinkModels.count > 0 {
            self.models = addGroupLinkModels
            tableViewHeightConstraint.constant = CGFloat(Float(models.count) * Float(RowCell.cellHeight))
            contentViewHeight.constant = CGFloat(Float(models.count) * Float(RowCell.cellHeight) + 50.0)
        }
    }
    
    func setModels(models: [AddGroupLinkModel]) {
        self.models = models
        tableViewHeightConstraint.constant = CGFloat(Float(models.count) * Float(RowCell.cellHeight))
        contentViewHeight.constant = CGFloat(Float(models.count) * Float(RowCell.cellHeight) + 50.0)
    }
}

extension AddGroupAlert: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.cellId, for: indexPath) as! RowCell
        cell.setModel(model: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RowCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didClickRowHandler?(models[indexPath.row])
    }
}


class RowCell: UITableViewCell {
    static let cellId = "RowCell"
    static let cellHeight: CGFloat = 58.0
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLab: UILabel = {
       let label = UILabel()
       label.text = ""
       label.textColor = UIColor.init(r: 34, g: 34, b: 34)
       label.font = UIFont.boldSystemFont(ofSize: 15)
       return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: RowCell.cellId)
        selectionStyle = .none
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLab)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        layoutPageViews()
    }
    
    func setModel(model: AddGroupLinkModel) {
        iconImageView.kfSetHorizontalImageWithUrl(model.icon)
        titleLab.text = model.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RowCell {
    
    private func layoutPageViews() {
        layoutIconImageView()
        layoutTitleLab()
    }
    
    private func layoutIconImageView() {
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(35)
            make.width.height.equalTo(37.5)
        }
    }
    
    private func  layoutTitleLab() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
}
