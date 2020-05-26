
import GPUImage
import AVKit
import AssetsLibrary
import Photos
import UIKit

class QHRecordViewController: QHBaseViewController {
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = ""
        bar.backgroundColor = UIColor.clear
        bar.lineView.backgroundColor = UIColor.clear
        bar.titleLabel.textColor = UIColor.white
        bar.backButton.layer.cornerRadius = 17
        bar.backButton.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        bar.backButton.layer.masksToBounds = true
        bar.delegate = self
        return bar
    }()
    private let imagePlace: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(red: 17/255.0, green: 19/255.0, blue: 27/255.0, alpha: 0.99)
        imageView.image = UIImage(named: "playCellBg")
        return imageView
    }()
    private let recordCover: RecordCoverView = {
        guard let coverView = Bundle.main.loadNibNamed("RecordCoverView", owner: nil, options: nil)?[0] as? RecordCoverView else { return  RecordCoverView() }
        return coverView
    }()
    private let videoImageCover: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor.clear
        return image
    }()
    /// 视频保存路径
    private lazy var fileURL: URL = {
        let tempath = FilesManager.recordSavePath
        if FileManager.default.fileExists(atPath: tempath) == false {
            try! FileManager.default.createDirectory(atPath: tempath, withIntermediateDirectories: true, attributes: nil)
        }
        let dataFormatter =  DateFormatter()
        dataFormatter.dateFormat = "yyyyMMddHHmmss"
        let nowstr = dataFormatter.string(from: Date())
        let pth = tempath + "/\(nowstr)" + "dyUpload.mp4"
        return URL(fileURLWithPath: pth)
    }()
    
    // MARK: - GPUImage
    /// 相机
    private lazy var camera: GPUImageVideoCamera? = {
        //AVCaptureSessionPreset1280x720 AVCaptureSessionPreset3840x2160
        let cam = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.high.rawValue, cameraPosition: .front)
        return cam
    }()
    
    private let deviceCam: AVCaptureDevice? = {
        return AVCaptureDevice.default(for: AVMediaType.video)
    }()
    
    /// 预览图层
    private lazy var preview : GPUImageView = {
        let view = GPUImageView(frame: CGRect(x: -2, y: 0, width: UIScreen.main.bounds.width + 5 , height: UIScreen.main.bounds.size.height))
        return view
    }()
    /// 视频写入（保存）对象
    private lazy var movieWriter: GPUImageMovieWriter = { [unowned self] in
        //创建写入对象
        let writer = GPUImageMovieWriter(movieURL: self.fileURL, size: CGSize(width:  self.view.bounds.width + 5, height: UIScreen.main.bounds.size.height + 10))
        return writer!
    }()
    /// 初始化滤镜
    let bilateralFilter = GPUImageBilateralFilter()     // 磨皮
    let exposureFilter = GPUImageExposureFilter()       // 曝光
    let brightnessFilter = GPUImageBrightnessFilter()   // 美白
    let satureationFilter = GPUImageSaturationFilter()  // 饱和
    let contrastFilter = GPUImageContrastFilter()       // 对比度
    let whiteBalance =  GPUImageWhiteBalanceFilter()    // 白平衡 （冷暖色调）
    let sepiaFilter = GPUImageSepiaFilter()             // 怀旧
    let sharpenFilter = GPUImageSharpenFilter()         // 锐化
    
    var timer: Timer?
    var currentTime = 0.0
    
    /// 默认
    var filterModel: FilterModel = FilterModel(name: "正常", bilateral: 10.3, exposure: 0.0, brightness: 0.1, satureation: 1.0, contrast: 1.0, whiteBalance: 5000.0, tint: 0.0, intensity: 0.0, sharpenness: 0.0, isSelected: true, coverColor: UIColor.clear)
    
    /// 假的去掉美颜的滤镜
    var noBeautyFilter = FilterModel(name: "无美颜", bilateral: 20.73, exposure: 0.0, brightness: 0.1, satureation: 1.0, contrast: 1.0, whiteBalance: 5000.0, tint: 0.0, intensity: 0.0, sharpenness: 0.0, isSelected: true, coverColor: UIColor.clear)
    
    let userViewModel = UserInfoViewModel()
    
    // MARK: - Life - Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserViewModelCallBack()
        
        ///屏蔽掉审核权限api
        loadUserRecordCheckApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DLog("所有文件夹大小 = \(FilesManager.filesSizeOfRecorded())")
    }
    
    private func loadUserRecordCheckApi() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        let _ = userViewModel.recordCheck()
    }
    
    private func setLicenseView() {
        view.addSubview(navBar)
        layoutNavBar()
        let license = LicenseController()
        license.recordAction = true
        let resouce = Bundle.main.path(forResource: "regulation", ofType: "html")
        let urlstr = String(format: "file://%@", resouce!)
        license.urlString = urlstr
        self.addChild(license)
        view.addSubview(license.view)
        layoutLicenseView(license.view)
        navBar.backButton.setImage(UIImage(named: "navBackWhite"), for: .normal)
        navBar.titleLabel.text = "抖阴成人小视频上传须知"
    }
    
    private func setUpUI() {
        view.addSubview(imagePlace)
        view.addSubview(videoImageCover)
        layoutViewBaseView()
        view.addSubview(recordCover)
        recordCover.addSubview(navBar)
        layoutPageSubviews()
        recordCoverViewAction()
        navBar.titleLabel.text = ""
    }
   
    /// 录制视频操作回调
    private func recordCoverViewAction() {
        recordCover.recordActionHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.startRecord()
        }
        recordCover.finishRecordActionHandler = { [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.stopRecording()
        }
        recordCover.filterChoseActionHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showFilterChoseView()
        }
        recordCover.rotateActionHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.rotateCamera()
        }
        recordCover.flashActionHandler = { [weak self] (isOn) in
            guard let strongSelf = self else { return }
            strongSelf.flashlightOnOff()
        }
        recordCover.choseVideoActionHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.choseVideoFromLibrary()
        }
        recordCover.beautyFaceActionHandler = { [weak self] (isOff) in
            guard let strongSelf = self else { return }
            strongSelf.switchBeautyEffect(isOff)
        }
        recordCover.playVideoActionHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.playVideo()
        }
        recordCover.nextStepActionHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.recordVideoEditor()
        }
    }
    
    /// viewModel 回调
    private func addUserViewModelCallBack() {
        userViewModel.recordCheckApiSuccessHandler = { [weak self] in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            ///屏蔽
            strongSelf.fixUserRecordCheck()
        }
        userViewModel.recordCheckApiFailHandler = { [weak self] (errorMsg) in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            XSAlert.show(type: .error, text: "网络请求失败！")
            strongSelf.closeAction()
        }
    }
    
    /// 用户录制权限 对比
    private func fixUserRecordCheck() {
        let checkInfoModel = userViewModel.recordCheckInfoModel
        guard let reviewStatu = checkInfoModel.upload_review else {  // 状态不存在 直接关闭
            closeAction()
            return
        }
        if reviewStatu == .newReviewStatu {
            setLicenseView()
        } else if reviewStatu == .passedReview {
            setUpUI()
            setupCamera()
        } else if reviewStatu == .reviewFailed {
            let leaseCount = (checkInfoModel.upload_review_max_fail ?? 0) - (checkInfoModel.upload_review_fail ?? 0)
            if leaseCount <= 0 {
                alertForCheck("因违反抖阴视频上传规则，或不符合申请要求，您已被永久禁止上传")
            } else {
                XSAlert.show(type: .warning, text: "仅剩\(leaseCount)次申请机会，请珍惜")
                setLicenseView()
            }
        } else if reviewStatu == .waitForReview {
            alertForCheck("上传权限正在申请中，请耐心等待")
        }
    }
    
    /// 录制鉴权失败提示
    private func alertForCheck(_ msg: String) {
        let alertContro = UIAlertController.init(title: "温馨提示", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
            self.closeAction()
        }
        alertContro.addAction(okAction)
        alertContro.modalPresentationStyle = .fullScreen
        self.present(alertContro, animated: true, completion: nil)
    }
  
    /// 预览播放
    private func playVideo() {
        // 这里可以做 原片播放， +  产品内置播放
        let playerVc = AVPlayerViewController()
        playerVc.player = AVPlayer(url: fileURL)
        playerVc.player?.play()
        playerVc.modalPresentationStyle = .fullScreen
        self.present(playerVc, animated: false, completion: nil)
    }
    
    /// 选择视频编辑
    private func libraryVideoEditor(asset: PHAsset) {
        switch asset.mediaType {
        case .video:
            let storyboard: UIStoryboard = UIStoryboard(name: "VT", bundle: nil)
            let vc: VTViewController = storyboard.instantiateViewController(withIdentifier: "VT") as! VTViewController
            vc.asset = asset
            vc.sourceType = .Source_Library
            //vc.camareVideoPath = FileManager.videoExportURL
            self.navigationController?.pushViewController(vc, animated: false)
        default:
            break
        }
    }
    
    /// 录制视频编辑
    private func recordVideoEditor() {
        DLog("filePath = \(fileURL.absoluteString)")
        let storyboard: UIStoryboard = UIStoryboard(name: "VT", bundle: nil)
        let vc: VTViewController = storyboard.instantiateViewController(withIdentifier: "VT") as! VTViewController
        vc.sourceType = .Source_Camare
        vc.camareVideoPath = fileURL
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    private func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - User - Action
private extension QHRecordViewController {
    
    /// 开始录制
    func startRecord() {
        //开始写入
        movieWriter.startRecording()
        recordCover.startRecordStatu()
        timer = Timer.new(every: 1.0.seconds) { (timer) in
            self.updateTimer()
        }
        timer?.start(modes: .common)
    }
    
    /// 点击停止
    func stopRecording() {
        stopTimer()
        camera?.stopCapture()
        camera?.removeAllTargets()
        preview.removeFromSuperview()
        movieWriter.finishRecording()
        self.fileSizeWithPath(fileURL)
        DispatchQueue.main.async {
            self.recordCover.finishRecordStatu()
            self.currentTime = 0.0
            self.getVideoFirstImage()
            self.alertSound()
        }
    }
    
    /// 更新时间
    @objc func updateTimer() {
        currentTime += 1.0
        let second = Int(currentTime)%60 >= 10 ? "\(Int(currentTime)%60)" : "0\(Int(currentTime)%60)"
        let mins = Int(currentTime/60.0) >= 10 ? "\(Int(currentTime/60.0))" : "0\(Int(currentTime/60.0))"
        recordCover.timeLabel.text = String(format: "%@:%@", mins, second)
        recordCover.progressView.setProgress(value: CGFloat(currentTime/400.0))
    }
    
    /// 停止计时
    func stopTimer()  {
        guard let timer = timer else { return }
        timer.invalidate()
    }
    
    /// -提示音机震动
    func alertSound() -> Void {
        var soundID: SystemSoundID = 0
        let soundFile = Bundle.main.path(forResource: "recordStart", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: soundFile!) as  CFURL, &soundID)
        //播放提示音 带有震动
        AudioServicesPlayAlertSound(soundID)
        //播放系统提示音
       // AudioServicesPlaySystemSound(soundID)
    }
    
    /// 切换摄像头
    func rotateCamera() {
        camera?.rotateCamera()
        let posint = camera?.cameraPosition()
        if posint == AVCaptureDevice.Position.front {
            DLog("isFrontFacingCameraPresent")
            if recordCover.flashlightBtn.isSelected {
                //关闭闪光灯
                flashlightOnOff()
            }
            recordCover.flashlightBtn.isEnabled = false
        } else if posint == AVCaptureDevice.Position.back {
            DLog("isBackFacingCameraPresent")
            recordCover.flashlightBtn.isEnabled = true
        }
    }
    
    // 美颜开关键
    func switchBeautyEffect(_ isOff: Bool) {
        if !isOff { // 未关闭
            setFilterProperties()
        } else {
            setNoBeautyFilterproperties()
        }
    }
    
    /// 闪光灯开关 isOn: 是否开启
    func flashlightOnOff() {
        guard let device = deviceCam else { return }
        //呼叫控制硬件
        try! device.lockForConfiguration()
        
        //开启、关闭闪光灯
        if device.torchMode == .on {
            device.torchMode = .off
            recordCover.flashlightBtn.isSelected = false
        } else {
            device.torchMode = .on
            recordCover.flashlightBtn.isSelected = true
        }
        //控制完毕需要关闭控制硬件
        device.unlockForConfiguration()
    }
    
    /// 从相册选择视频
    func choseVideoFromLibrary() {
         //stopRecording()
        camera?.pauseCapture()
        let storyboard: UIStoryboard = UIStoryboard(name: "Thumbnail", bundle: nil)
        let vc: ThumbnailViewController = storyboard.instantiateViewController(withIdentifier: "Thumbnail") as! ThumbnailViewController
//        let nav = QHNavigationController(rootViewController: vc)
        vc.videoChoseHandler = { (asset) in
            DLog("videoChoseHandler.asset= \(asset)")
            self.camera?.stopCapture()
            self.libraryVideoEditor(asset: asset)
        }
        vc.cancleChoseHandler = {
            self.camera?.resumeCameraCapture()
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    /// 选择滤镜
    func showFilterChoseView() {
        let filterView = FilterChoseController()
        filterView.filterChoseHandler = { (filter) in
            self.filterModel = filter
            DLog("self.filterModel.name =\(self.filterModel)")
            self.setFilterProperties()
        }
        filterView.modalPresentationStyle = .overCurrentContext
        filterView.definesPresentationContext = true
        filterView.view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        present(filterView, animated: true, completion: nil)
    }
    
    /// 滤镜属性赋值
    func setFilterProperties() {
        satureationFilter.saturation = filterModel.satureation
        brightnessFilter.brightness = filterModel.brightness
        exposureFilter.exposure = filterModel.exposure
        bilateralFilter.distanceNormalizationFactor = filterModel.bilateral
        contrastFilter.contrast = filterModel.contrast
        whiteBalance.temperature = filterModel.whiteBalance
        whiteBalance.tint = filterModel.tint
        sepiaFilter.intensity = filterModel.intensity
    }
    
    /// 虚构没有美颜
    func setNoBeautyFilterproperties() {
        satureationFilter.saturation = noBeautyFilter.satureation
        brightnessFilter.brightness = noBeautyFilter.brightness
        exposureFilter.exposure = noBeautyFilter.exposure
        bilateralFilter.distanceNormalizationFactor = noBeautyFilter.bilateral
        contrastFilter.contrast = noBeautyFilter.contrast
        whiteBalance.temperature = noBeautyFilter.whiteBalance
        whiteBalance.tint = noBeautyFilter.tint
        sepiaFilter.intensity = noBeautyFilter.intensity
    }
   
}

// MARK: - Record - Set
private extension QHRecordViewController {
    
    func setupCamera() {
        //设置camera方向
        camera?.outputImageOrientation = .portrait
        camera?.horizontallyMirrorFrontFacingCamera = true
        //添加预览图层
        view.insertSubview(preview, belowSubview: recordCover)
        //获取滤镜组
        let filterGroup = getGroupFilters()
        
        //设置GPUImage的响应链
        camera?.addTarget(filterGroup)
        filterGroup.addTarget(preview)
        
        camera?.delegate = self
        //开始采集视频
        camera?.startCapture()
        
        //设置writer属性
        movieWriter.encodingLiveVideo = true
        //将writer设置成滤镜的target
        filterGroup.addTarget(movieWriter)
        
        //设置camera的编码
        camera?.audioEncodingTarget = movieWriter
        
        setFilterProperties()
        
    }
    
    //创建滤镜组
    func getGroupFilters() -> GPUImageFilterGroup {
        let filterGroup = GPUImageFilterGroup()
        //设置滤镜链接关系
        bilateralFilter.addTarget(brightnessFilter)
        brightnessFilter.addTarget(exposureFilter)
        exposureFilter.addTarget(satureationFilter)
        satureationFilter.addTarget(contrastFilter)
        contrastFilter.addTarget(sharpenFilter)
        sharpenFilter.addTarget(sepiaFilter)
        sepiaFilter.addTarget(whiteBalance)
        
        //设置group起始点 终点
        filterGroup.initialFilters = [bilateralFilter]
        filterGroup.terminalFilter = whiteBalance
        return filterGroup
    }
}

// MARK: - GPUImageVideoCameraDelegate
extension QHRecordViewController: GPUImageVideoCameraDelegate {
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        //  DLog("采集到画面")
    }
}

// MARK: - Save Video + VideoImage (截取视频图片)
private extension QHRecordViewController {
    
    // 截取视频第一帧 图片
    func getVideoFirstImage() {
        let urlAsset = AVURLAsset(url: fileURL)
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
            videoImageCover.image = frameImg
        } else {
            //截图失败，显示默认图片
            videoImageCover.image = nil
        }
    }
   
    // 此步骤应该在上传成功之后来做。// 因为保存之后删除沙河中的文件，会导致上传时必须去相册w里面取。
    func checkForAndDeleteFile() {
        let fm = FileManager.default
        let url = fileURL
        let exist = fm.fileExists(atPath: url.path)
        DLog("所有文件夹大小 = \(FilesManager.filesSizeOfRecorded())")
        if exist {
            DLog("删除之前的临时文件")
            do {
                try fm.removeItem(at: url as URL)
            } catch let error as NSError {
                DLog(error.localizedDescription)
            }
        }
    }
    
    // 计算文件大小
    func fileSizeWithPath(_ path: URL) {
        if let dataFile = try? Data(contentsOf: path)  {
            let size = Float(dataFile.count/1024/1024)
            DLog("fileSize = \(size)M \n filePath = \(path)")
        }
    }
    
}


// MARK: QHNavigationBarDelegate
extension QHRecordViewController: QHNavigationBarDelegate {
    func backAction() {
        checkForAndDeleteFile()
        closeAction()
    }
}

// MARK: - Layout
private extension QHRecordViewController {
    
    func layoutViewBaseView() {
        layoutImageBackground()
        layoutVideoCoverImage()
    }
    
    func layoutPageSubviews() {
        layoutRecordCover()
        layoutNavBar()
    }
    
    func layoutRecordCover() {
        recordCover.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func layoutVideoCoverImage() {
        videoImageCover.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutImageBackground() {
        imagePlace.snp.makeConstraints { (make) in
            make.edges.edges.equalToSuperview()
        }
    }
    
    func layoutLicenseView(_ view: UIView) {
        view.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}
