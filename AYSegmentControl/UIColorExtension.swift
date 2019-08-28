
//
//  UIColorExtension.swift
//  AYSegmentControl
//
//  Created by Andy on 2019/8/28.
//  Copyright © 2019 wangyawei. All rights reserved.
//

import UIKit

extension UIColor {

    // 3CA5FF
    static func color3CA5FF() ->  UIColor {
        return UIColor.colorWithHexString("3CA5FF")
    }

    // 默认titleColor  #666666
    static func color666666() ->  UIColor {
        return UIColor.colorWithHexString("666666")
    }

    // 选中的titleColor #4182FF
    static func color4182FF() ->  UIColor {
        return UIColor.colorWithHexString("4182FF")
    }

    // 选中的titleGroundcolor e3edff
    static func colore3edff() ->  UIColor {
        return UIColor.colorWithHexString("E3EDFF")
    }

    // colorfff9eb
    static func colorfff9eb() ->  UIColor {
        return UIColor.colorWithHexString("fff9eb")
    }

    static func hexString(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString = String(cString[cString.index(after: cString.startIndex)..<cString.endIndex])
        }

        // 如果不符合要求，返回灰色
        if cString.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

    /// - Parameters:
    ///   - colorHex: 十六进制字符串
    ///   - alpha: 透明度
    /// - Returns: 颜色
    static func colorWithHexString(_ colorHex: NSString, alpha: String = "ff") -> UIColor {
        let rString = colorHex.substring(with: NSMakeRange(0, 2))
        let gString = colorHex.substring(with: NSMakeRange(2, 2))
        let bString = colorHex.substring(with: NSMakeRange(4, 2))

        var r: UInt32 = 0 , g: UInt32 = 0, b: UInt32 = 0, a: UInt32 = 1
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        Scanner(string: alpha).scanHexInt32(&a)

        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
}
