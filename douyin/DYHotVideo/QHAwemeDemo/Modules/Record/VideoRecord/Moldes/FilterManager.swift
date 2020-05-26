//
//  FilterManager.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/21.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation

/// 滤镜
struct FilterModel {
    var name: String = "正常"       //  滤镜取名
    var bilateral: CGFloat = 5.0   //  磨皮 ：数值越大，表示拍摄距离越近，越多麻子  建议值： 0.0 - 10.0
    var exposure: CGFloat = 0.0    //  曝光 ： -10.0 -> 10.0   0.0 as the normal level
    var brightness: CGFloat = 0.1  //  美白值 ： -1.0 - 1.0  0.0 as the normal level
    var satureation: CGFloat = 1.0 //  饱和度 ： 0 - 2.0  1.0 as the normal level
    var contrast: CGFloat =  1.0   //  对比度 ： 0 - 4.0  1.0 as the normal level
    /// whiteBalance 和 tint 用于控制冷暖色调
    var whiteBalance: CGFloat = 5000.0  // （最大值10000，最小值1000，正常值5000）
    var tint: CGFloat = 0.0         // (最大值1000，最小值-1000，正常值0.0）与 whiteBalance 混用，可以产生很多效果
    var intensity: CGFloat = 0.0    // 褐色（怀旧）：   default is 1.0 ,  0.0 表示滤镜没有效果
    var sharpenness: CGFloat = 0.0  // 锐化 ： ranges from -4.0 to 4.0, with 0.0 as the normal level
    var isSelected: Bool = false    // 是否为当前选中的滤镜
    var coverColor: UIColor = UIColor.clear
}

/// 滤镜管理员
class FilterManager: NSObject {
    
    lazy var filters: [FilterModel] = {
        let allFilters = [filter_Normal, filter_Cartoon, filter_Buaty, filter_RedCover, filter_GreenCover, filter_BlueCover, filter_OldCover, filter_RedSunCover, filter_BlueSunCover, filter_SunCover, filter_GreenSunCover, filter_LoverCover, filter_QingQuCover]
        return allFilters
    }()
    
    
   /* bilateral(磨皮) === 8.0
    brightness（美白） === 0.0
    exposure（曝光） === 0.0
    satureation（饱和度） === 1.0
    contrast(对比度) === 1.0
    sharpen(锐化) === 0.0
    sepiaFilter(怀旧) == 0.0
    whiteBalance === 5000.0
    tint === 0.0 */
    /// 初始状态的filter
    private lazy var filter_Normal: FilterModel = {
        let color = UIColor.clear
        let filter = FilterModel(name: "正常", bilateral: 10.3, exposure: 0.0, brightness: 0.1, satureation: 1.0, contrast: 1.0, whiteBalance: 5000.0, tint: 0.0, intensity: 0.0, sharpenness: 0.0, isSelected: true, coverColor: color)
        return filter
    }()
    
    private lazy var filter_Cartoon: FilterModel = {
        let color = UIColor.clear
        let filter = FilterModel(name: "黑白", bilateral: 10.3, exposure: 0.767, brightness: -0.06, satureation: 0.0, contrast: 1.0, whiteBalance: 5000.0, tint: 0.0, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
    /*bilateral(磨皮) === 6.177095413208008
     brightness（美白） === 0.18536005914211273
     exposure（曝光） === -0.32821735739707947
     satureation（饱和度） === 0.7036600112915039
     contrast(对比度) === 1.63872492313385
     sharpen(锐化) === -0.0802835002541542
     sepiaFilter(怀旧) == 0.0
     whiteBalance === 5000.0
     tint === 12.986902236938477*/
    
    // 唯美
    private lazy var filter_Buaty: FilterModel = {
        let color = UIColor.clear
         let filter = FilterModel(name: "唯美", bilateral: 10.3, exposure: -0.328217, brightness: 0.18536, satureation: 0.70366, contrast: 1.63872, whiteBalance: 5000.0, tint: 13, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
    /*bilateral(磨皮) === 6.177095413208008
     brightness（美白） === 0.18536005914211273
     exposure（曝光） === -0.32821735739707947
     satureation（饱和度） === 0.7036600112915039
     contrast(对比度) === 1.63872492313385
     sharpen(锐化) === -0.0802835002541542
     sepiaFilter(怀旧) == 0.0
     whiteBalance === 5000.0
     tint === 17.709489822387695*/
    private lazy var filter_RedCover: FilterModel = {
        let color = UIColor.clear
        let filter = FilterModel(name: "清新", bilateral: 10.3, exposure: -0.328217, brightness: 0.18536, satureation: 0.70366, contrast: 1.63872, whiteBalance: 5000.0, tint: 17, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
    /*bilateral(磨皮) === 6.177095413208008
     brightness（美白） === 0.18536005914211273
     exposure（曝光） === -0.32821735739707947
     satureation（饱和度） === 0.7036600112915039
     contrast(对比度) === 1.63872492313385
     sharpen(锐化) === -0.0802835002541542
     sepiaFilter(怀旧) == 0.0
     whiteBalance === 5000.0
     tint === -60.212589263916016*/
    private lazy var filter_GreenCover: FilterModel = {
        let color = UIColor.clear
        let filter = FilterModel(name: "青草", bilateral: 10.3, exposure: -0.328217, brightness: 0.18536, satureation: 0.70366, contrast: 1.63872, whiteBalance: 5000.0, tint: -60, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
    /*bilateral(磨皮) === 6.290436267852783
     brightness（美白） === 0.1948051154613495
     exposure（曝光） === -0.1959857940673828
     satureation（饱和度） === 0.7839432954788208
     contrast(对比度) === 1.2467530965805054
     sharpen(锐化) === -0.3353012204170227
     sepiaFilter(怀旧) == 0.0
     whiteBalance === 4729.6337890625
     tint === 0.0*/
    
    private lazy var filter_BlueCover: FilterModel = {
        let color = UIColor.clear
        let filter = FilterModel(name: "日系", bilateral: 10.3, exposure: -0.195986, brightness: 0.1948, satureation: 0.78394, contrast: 1.24675, whiteBalance: 4729.0, tint: 0.0, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
    /*bilateral(磨皮) === 5.827626705169678
     brightness（美白） === 0.1948051154613495
     exposure（曝光） === -0.1959857940673828
     satureation（饱和度） === 0.7839432954788208
     contrast(对比度) === 1.2467530965805054
     sharpen(锐化) === -0.5714287757873535
     sepiaFilter(怀旧) == 0.0
     whiteBalance === 8703.66015625
     tint === 0.0*/
    private lazy var filter_OldCover: FilterModel = {
        let color = UIColor.clear
       let filter = FilterModel(name: "小麦", bilateral: 10.3, exposure: -0.19599, brightness: 0.19481, satureation: 0.78394, contrast: 1.24675, whiteBalance: 8703.0, tint: 0.0, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
    
    /*bilateral(磨皮) === 5.827626705169678
     brightness（美白） === 0.1948051154613495
     exposure（曝光） === -0.1959857940673828
     satureation（饱和度） === 0.7839432954788208
     contrast(对比度) === 1.2467530965805054
     sharpen(锐化) === -0.5714287757873535
     sepiaFilter(怀旧) == 0.0
     whiteBalance === 5882.17236328125
     tint === 0.0*/
    private lazy var filter_SunCover: FilterModel = {
        let color = UIColor.clear
       let filter = FilterModel(name: "阳光", bilateral: 10.3, exposure: -0.19599, brightness: 0.19481, satureation: 0.78394, contrast: 1.24675, whiteBalance: 5882.0, tint: 0.0, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
    /*bilateral(磨皮) === 5.827626705169678
     brightness（美白） === 0.1948051154613495
     exposure（曝光） === -0.1959857940673828
     satureation（饱和度） === 0.7839432954788208
     contrast(对比度) === 1.2467530965805054
     sharpen(锐化) === -0.3353012204170227
     sepiaFilter(怀旧) == 0.0
     whiteBalance === 4315.22998046875
     tint === 0.0*/
    
    private lazy var filter_BlueSunCover: FilterModel = {
        let color = UIColor.clear
        let filter = FilterModel(name: "朦胧", bilateral: 10.3, exposure: -0.19599, brightness: 0.19481, satureation: 0.78394, contrast: 1.24675, whiteBalance: 4315.0, tint: 0.0, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
    /*bilateral(磨皮) === 6.177095413208008
     brightness（美白） === 0.18536005914211273
     exposure（曝光） === -0.32821735739707947
     satureation（饱和度） === 0.7036600112915039
     contrast(对比度) === 1.63872492313385
     sharpen(锐化) === -0.0802835002541542
     sepiaFilter(怀旧) == 0.0
     whiteBalance === 5000.0
     tint === 105.07662963867188*/
    
    private lazy var filter_RedSunCover: FilterModel = {
        let color = UIColor.clear
        let filter = FilterModel(name: "粉嫩", bilateral: 10.3, exposure: 0.3, brightness: 0.045, satureation: 0.82, contrast: 1.0, whiteBalance: 5000.0, tint: 105.0, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
    /*bilateral(磨皮) === 6.177095413208008
     brightness（美白） === 0.18536005914211273
     exposure（曝光） === -0.32821735739707947
     satureation（饱和度） === 0.7036600112915039
     contrast(对比度) === 1.63872492313385
     sharpen(锐化) === -0.0802835002541542
     sepiaFilter(怀旧) == 0.0
     whiteBalance === 5000.0
     tint === -152.30226135253906*/
    private lazy var filter_GreenSunCover: FilterModel = {
        let color = UIColor.clear
        let filter = FilterModel(name: "绿光", bilateral: 10.3, exposure: -0.3282, brightness: 0.18536, satureation: 0.70366, contrast: 1.63872, whiteBalance: 5000.0, tint: -152.0, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
    /*bilateral(磨皮) === 6.290436267852783
     brightness（美白） === 0.1948051154613495
     exposure（曝光） === -0.1959857940673828
     satureation（饱和度） === 0.7839432954788208
     contrast(对比度) === 1.2467530965805054
     sharpen(锐化) === -0.0330582819879055
     sepiaFilter(怀旧) == 0.0
     whiteBalance === 5000.0
     tint === 182.9987030029297*/
    private lazy var filter_LoverCover: FilterModel = {
        let color = UIColor.clear
        let filter = FilterModel(name: "恋爱", bilateral: 10.3, exposure: -0.19598, brightness: 0.1948, satureation: 0.783943, contrast: 1.246753, whiteBalance: 5000.0, tint: 182.0, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
    
    /*bilateral(磨皮) === 5.827626705169678
     brightness（美白） === 0.2514757215976715
     exposure（曝光） === -0.18654084205627441
     satureation（饱和度） === 0.9161747097969055
     contrast(对比度) === 1.4356552362442017
     sharpen(锐化) === -0.5714287757873535
     sepiaFilter(怀旧) == 0.0
     whiteBalance === 5000.0
     tint === 320.31988525390625*/
    private lazy var filter_QingQuCover: FilterModel = {
        let color = UIColor.clear
        let filter = FilterModel(name: "情趣", bilateral: 10.3, exposure: -0.1865, brightness: 0.2515, satureation: 0.916, contrast: 1.435, whiteBalance: 5000.0, tint: 300.0, intensity: 0.0, sharpenness: 0.0, isSelected: false, coverColor: color)
        return filter
    }()
}
