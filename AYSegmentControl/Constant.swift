//
//  Constant.swift
//  AYSegmentControl
//
//  Created by Andy on 2019/8/28.
//  Copyright © 2019 wangyawei. All rights reserved.
//

import UIKit

/// 屏幕英寸屏
struct AYinches {
    /// 是否是4.0英寸屏
    static let inches40 = UIScreen.main.bounds.size.height == 568.0
    /// 是否是4.7英寸屏
    static let inches47 = UIScreen.main.bounds.size.height == 667.0
    /// 是否是5.5英寸屏
    static let inches55 = UIScreen.main.bounds.size.height == 736.0
}

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
