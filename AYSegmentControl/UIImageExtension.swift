
//
//  UIImageExtension.swift
//  AYSegmentControl
//
//  Created by Andy on 2019/8/28.
//  Copyright © 2019 wangyawei. All rights reserved.
//

import UIKit

extension UIImage {
    /// 颜色转化为图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - andFrame: 大小
    /// - Returns: 图片
    public class func image(_ color: UIColor, andFrame: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)) ->
        UIImage? {
            UIGraphicsBeginImageContext(andFrame.size)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            context.setFillColor(color.cgColor)
            context.fill(andFrame)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
    }


    static func loadImageWithName(_ name : String) -> UIImage? {
        return UIImage(named: name)
    }
}
