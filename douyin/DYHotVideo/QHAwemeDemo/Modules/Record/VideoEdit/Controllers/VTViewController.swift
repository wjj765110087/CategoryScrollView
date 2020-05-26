
import UIKit
import Photos

/// 视频文件来源
///
/// - Source_Camare: 实时拍摄
/// - Source_Library: 相册选取
enum VideoSourceType: Int {
    case Source_Camare = 1
    case Source_Library
}

/// 上传用作 -》
///
/// - UploadFor_Works: 个人作品上传
/// - UploadFor_Check: 上传作品权限审核用
enum UploadType: Int {
    case UploadFor_Works = 1
    case UploadFor_Check
}

class VTViewController: UIViewController, TrimmerViewDelegate {
    
    @IBOutlet weak var videoPlayerView: VTVideoPlayerView!
    @IBOutlet weak var trimmerView: TrimmerView!
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var camareVideoPath: URL?
    
    var asset: PHAsset?
    
    private var avAsset: AVAsset?
    
    var sourceType: VideoSourceType = .Source_Library
    
    var uploadType: UploadType = .UploadFor_Works
    
    var applyCheckDoneActionHandler:((_ image: UIImage?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewsLayer()
        initPlayer()
        (self.navigationController as? QHNavigationController)?.changeTransition(false)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        // parent = nil の時が navigationItem の戻るボタンで戻った時
        if parent == nil {
            videoPlayerView.finish()
        }
    }
    
    private func setupSubviewsLayer() {
        view.backgroundColor = ConstValue.kVcViewColor
        backButton.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
        doneButton.backgroundColor = UIColor(red: 0/255.0, green: 123/255.0, blue: 255/255.0, alpha: 1.0)
        trimmerView.mainColor = UIColor(red: 0/255.0, green: 123/255.0, blue: 255/255.0, alpha: 1.0)
        trimmerView.handleColor = UIColor.white
        saveButton.layer.masksToBounds = true
        trimmerView.positionBarColor = UIColor.white
    }
    
    private func initPlayer() {
        // FIXME: 关键处理:
        // TODO: 这里的 self.avAsset 是由 相册中视频 asset 转换而来，如果是拍摄而来， 直接用本地视频路径创建self.avAsset， 如果是拍摄的视频， 隐藏滤镜选择按钮
        if sourceType == .Source_Library {
            saveButton.isHidden = true
            self.asset?.toAVAsset { (asset: AVAsset?) in
                if let a: AVAsset = asset {
                    DispatchQueue.main.async {
                        self.fixAvAsset(a)
                    }
                }
            }
        } else {
            let a = AVAsset.init(url: camareVideoPath!)
            saveButton.isHidden = false
            self.fixAvAsset(a)
        }
    }
    
    private func fixAvAsset(_ asset: AVAsset) {
        /// 最多截取5分钟
        let maxDuration: CMTime = CMTimeMake(value: 300, timescale: 1)
        timeLabel.text = ""
        trimmerView.minDuration = 16.0
        trimmerView.maxDuration = maxDuration.seconds
        trimmerView.delegate = self
        
        self.timeLabel.text = asset.duration.seconds.toFormatedString()
        self.avAsset = asset
        self.videoPlayerView.prepare(asset: asset)
        self.trimmerView.asset = asset
        self.timeLabel.text = (self.videoPlayerView.endTime.seconds < maxDuration.seconds) ? self.videoPlayerView.endTime.seconds.toFormatedString() : maxDuration.seconds.toFormatedString()
        self.videoPlayerView.endTime = (self.videoPlayerView.endTime.seconds < maxDuration.seconds) ? self.videoPlayerView.endTime : maxDuration
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        sender.isSelected = !videoPlayerView.isPause
        if self.videoPlayerView.isPause {
            self.videoPlayerView.resume()
        } else {
            self.videoPlayerView.pause()
        }
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        if let asset: AVAsset = self.avAsset {
            if asset.duration.seconds < 16.0 {
                // 原视频小于15秒，直接在这里拦截
                XSAlert.show(type: .warning, text: "视频太短，没有快感哦！")
                return
            }
            if let tasks = UploadTask.shareTask().tasks, tasks.count > 0 {
                alertForUpdateVideos()
                return
            }
            XSProgressHUD.showCycleProgress(msg: "视频导出中...", onView: view, animated: false)
            // 点击下一步，先暂停视频
            videoPlayerView.pause()
            playerButton.isSelected = true
            exporteEditedVideo(asset: asset)
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        if let urlVideo = self.camareVideoPath {
            alertForSaveVideo(urlVideo)
        } else {
            closeAction()
        }
    }
    
    @IBAction func saveVideoToLibrary(_ sender: UIButton) {
        if let urlVideo = self.camareVideoPath {
            saveVideoToLibrary(pathUrl: urlVideo, afterClose: false)
        } else {
            XSAlert.show(type: .error, text: "视频不存在!")
        }
    }
    
    private func closeAction() {
        self.videoPlayerView.finish()
        FilesManager.deleteAllRecordFile()
        UploadTask.shareTask().talksModel = nil
        UploadTask.shareTask().content = nil
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /// 导出视频
    private func exporteEditedVideo(asset: AVAsset) {
        let exporter: VideoExporter = VideoExporter(to: FileManager.videoExportURL)
        exporter.startTime = self.videoPlayerView.startTime
        exporter.endTime = self.videoPlayerView.endTime
        exporter.export(asset: asset) { (error: Bool, message: String) in
            if error {
                DispatchQueue.main.async {
                    DLog(message)
                    XSAlert.show(type: .error, text: message)
                }
                return
            }
            DispatchQueue.main.async {
                /// 这里要做： 1. 删除y录制的视频（不管是不是录制进来的，都执行一次删除） 2.跳转到选封面的地方，去选择封面
                XSProgressHUD.hide(for: self.view, animated: false)
                let videoSize = self.fileSizeWithPath(exporter.outputUrl)
                if videoSize <= 0.0 { /// 视频导出失败
                    XSAlert.show(type: .error, text: "视频导出失败！")
                } else if videoSize > 250.0 { /// 视频大于250M
                   self.alertForFileSizeWarning()
                } else {
                    if self.uploadType == .UploadFor_Check {
                        self.applyCheckDoneActionHandler?(self.getVideoFirstImage())
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let coverVC = VideoCoverChoseController()
                        coverVC.videoPathUrl = exporter.outputUrl
                        self.navigationController?.pushViewController(coverVC, animated: true)
                    }
                }
            }
        }
    }
    
    // 截取视频第一帧 图片
    func getVideoFirstImage() -> UIImage? {
        let urlAsset = AVURLAsset(url: FileManager.videoExportURL)
        let seconds = urlAsset.duration.seconds
        DLog("second: \(seconds)")
        //生成视频截图
        let generator = AVAssetImageGenerator(asset: urlAsset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let time = CMTimeMakeWithSeconds(0.0,preferredTimescale: 600)
        var actualTime:CMTime = CMTimeMake(value: 0,timescale: 1)
        if let imageRef:CGImage = try? generator.copyCGImage(at: time, actualTime: &actualTime) {
            let frameImg = UIImage(cgImage: imageRef)
            //显示截图
            return frameImg
        }
        return nil
    }
    
    private func alertForFileSizeWarning() {
        let msgCamareSource = "视频大小超出上传限制，建议您重新截取,或保存视频后，再分段截取上传！"
        let msgLibrarySource = "视频大小超出上传限制，请重新截取！"
        let alertContro = UIAlertController.init(title: nil, message: self.sourceType == .Source_Camare ? msgCamareSource : msgLibrarySource, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "重新截取", style: .default) { (action) in
            
        }
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.closeAction()
        }
        alertContro.addAction(okAction)
        alertContro.addAction(cancleAction)
        alertContro.modalPresentationStyle = .fullScreen
        self.present(alertContro, animated: true, completion: nil)
    }
    
    private func alertForUpdateVideos() {
        let msg = "您有一个待处理视频，请前往个人中心 -> 作品列表 查看视频上传状态。"
        let alertContro = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "知道了", style: .cancel) { (action) in
        }
        alertContro.addAction(cancleAction)
        alertContro.modalPresentationStyle = .fullScreen
        self.present(alertContro, animated: true, completion: nil)
    }
    
    private func alertForSaveVideo(_ urlPath: URL) {
        if self.sourceType == .Source_Camare {
            let alertContro = UIAlertController.init(title: "温馨提示", message: "是否保存视频到相册，以便下次上传？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "保存", style: .default) { (action) in
                self.saveVideoToLibrary(pathUrl: urlPath, afterClose: true)
            }
            let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                self.closeAction()
            }
            alertContro.addAction(okAction)
            alertContro.addAction(cancleAction)
            alertContro.modalPresentationStyle = .fullScreen
            self.present(alertContro, animated: true, completion: nil)
        }
    }
    
    private func saveVideoToLibrary(pathUrl: URL, afterClose: Bool) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: pathUrl)
        }, completionHandler: { (success: Bool, error: Error?) in
            if success {
                DispatchQueue.main.async {
                    XSAlert.show(type: .success, text: "保存成功！")
                    if afterClose {
                         self.closeAction()
                    }
                }
                return
            }
            var message: String = "failed: save to Library"
            if let err: Error = error {
                message = err.localizedDescription
            }
            DLog(message)
        })
    }
    
    // 计算文件大小
    private func fileSizeWithPath(_ url: URL) -> Float {
        DLog("outputPath = \(url.absoluteString)")
        if let dataFile = try? Data(contentsOf: url)  {
            let size = Float(dataFile.count/1024/1024)
            DLog("fileSize = \(size)M")
            return size
        }
        return 0.0
    }
    
    // MARK: - TrimmerViewDelegate
    
    func didChangePositionBar(_ playerTime: CMTime) {
        videoPlayerView.pause()
        playerButton.isSelected = true
        if let startTime: CMTime = trimmerView.startTime, let endTime: CMTime = trimmerView.endTime {
            let diff: Double = endTime.seconds - startTime.seconds
            timeLabel.text = "已截取: \(diff.toFormatedString())"
            videoPlayerView.seek(to: playerTime)
            videoPlayerView.startTime = startTime
            videoPlayerView.endTime = endTime
        }
    }
    
    
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        if let startTime: CMTime = trimmerView.startTime, let endTime: CMTime = trimmerView.endTime {
            let diff: Double = endTime.seconds - startTime.seconds
            timeLabel.text = "已截取: \(diff.toFormatedString())"
            videoPlayerView.seek(to: playerTime)
            videoPlayerView.startTime = startTime
            videoPlayerView.endTime = endTime
        }
    }
    
}
