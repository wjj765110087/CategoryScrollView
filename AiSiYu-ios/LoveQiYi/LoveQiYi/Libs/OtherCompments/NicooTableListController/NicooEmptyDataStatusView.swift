

import UIKit

protocol EmptyDataStatusViewDelegate: class {
    func errorMessageViewBeenTapped()
}

class EmptyDataStatusView: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    fileprivate weak var _delegate:EmptyDataStatusViewDelegate?
    weak var delegate: EmptyDataStatusViewDelegate? {
        get {
            return _delegate
        }
        set (newVal) {
            _delegate = newVal
            self.initializeTapGesture()
        }
    }
    
    fileprivate func initializeTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EmptyDataStatusView.viewBeenTapped(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func viewBeenTapped(_ gesture: UITapGestureRecognizer) {
        self._delegate?.errorMessageViewBeenTapped()
    }
}
