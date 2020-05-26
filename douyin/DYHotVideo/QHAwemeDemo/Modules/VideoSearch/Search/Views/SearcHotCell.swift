
import UIKit

class SearcHotCell: UICollectionViewCell {

    static let cellId = "SearcHotCell"
    var titleLab: UILabel = {
        let lan = UILabel()
        lan.font = UIFont.systemFont(ofSize: 13)
        lan.textAlignment = .center
        lan.textColor = UIColor.white
        lan.layer.cornerRadius = 2
        lan.layer.masksToBounds = true
        return lan
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLab)
        titleLab.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layoutSubviews()
    }
  
   
}
