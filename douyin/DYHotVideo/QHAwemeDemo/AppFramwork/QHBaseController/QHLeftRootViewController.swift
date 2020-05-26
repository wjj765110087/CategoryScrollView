

import UIKit

/// 目前用于t展示推广二维码页面
class QHLeftRootViewController: QHBaseViewController {
    
    static let CellID = "cellInvitedC"
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: QHLeftRootViewController.CellID)
        
        return table
    }()
    
    var currentIndex:Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        layoutPageSubviews()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension QHLeftRootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstValue.kScreenHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: QHLeftRootViewController.CellID, for: indexPath)
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = .clear
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension QHLeftRootViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            if translatedPoint.y < -50 && self.currentIndex < 1 {
                self.currentIndex += 1
            }
            if translatedPoint.y > 50 && self.currentIndex > 0 {
                self.currentIndex -= 1
            }
            let indexPath = IndexPath.init(row: self.currentIndex, section: 0)
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }
}

// MARK: - Layout
private extension QHLeftRootViewController {
    
    func layoutPageSubviews() {
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(0)
        }
    }
   
}
