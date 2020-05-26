//
//  CodeModel.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/25.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation

/// 验证码对象
struct CodeModel: Codable {
    var verification_key: String?
    var expiredAt: String?
    var verification_code: String?
}
