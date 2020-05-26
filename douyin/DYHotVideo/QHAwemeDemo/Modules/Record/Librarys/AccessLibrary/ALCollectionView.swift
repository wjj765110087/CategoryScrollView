
import UIKit
import Photos

class ALCollectionView: DefaultCollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var lists: [PHAsset] = [PHAsset]()
    
    private var cellHeight: CGFloat = 0
    private var cellWitdh : CGFloat = 0
    
    
    enum listType {
        case image
        case video
        case imageAndVideo
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.cellWitdh = (UIScreen.main.bounds.width-20) / 3
        self.cellHeight = self.cellWitdh * 4/3
        self.dataSource = self
    }
    
    
    func initList(type: listType, callback: @escaping (_ isAuthorization: Bool) -> Void) {
        self.requestAuthorization { (isAuthorization: Bool) in
            if isAuthorization {
                switch type {
                case .image:
                    self.initListImage {
                        // メインスレッドで reloadData() を呼ばないと警告が出る
                        DispatchQueue.main.async {
                            self.reloadData()
                            callback(isAuthorization)
                        }
                    }
                case .video:
                    self.initListVideo {
                        // メインスレッドで reloadData() を呼ばないと警告が出る
                        DispatchQueue.main.async {
                            self.reloadData()
                            callback(isAuthorization)
                        }
                    }
                case .imageAndVideo:
                    self.initListImage {
                        self.initListVideo {
                            // メインスレッドで reloadData() を呼ばないと警告が出る
                            DispatchQueue.main.async {
                                self.reloadData()
                                callback(isAuthorization)
                            }
                        }
                    }
                }
                return
            }
            callback(false)
        }
    }
    
    
    private func initListImage(callback: () -> Void) {
        let asset: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        asset.enumerateObjects { (asset: PHAsset, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
            self.lists.append(asset)
        }
        callback()
    }
    
    
    private func initListVideo(callback: () -> Void) {
        let asset: PHFetchResult = PHAsset.fetchAssets(with: .video, options: nil)
        asset.enumerateObjects { (asset: PHAsset, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
            self.lists.append(asset)
        }
        callback()
    }
    
    
    private func requestAuthorization(callback: @escaping (_ isAuthorization: Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
            switch status {
            case .authorized:
                callback(true)
            case .denied:
                callback(false)
            case .notDetermined:
                self.requestAuthorization { (isAuthorization: Bool) in
                    callback(isAuthorization)
                }
            case .restricted:
                callback(false)
            }
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lists.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item: PHAsset = self.lists[indexPath.row]
        let cell: ALCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ALCollectionViewCell", for: indexPath) as! ALCollectionViewCell
        cell.setCell(asset: item, size: CGSize(width: self.cellWitdh , height: self.cellHeight))
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWitdh, height: cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
