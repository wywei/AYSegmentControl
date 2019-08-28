

//
//  AYColumnScrollView.swift
//  AYSegmentControl
//
//  Created by Andy on 2019/8/28.
//  Copyright © 2019 wangyawei. All rights reserved.
//

import UIKit

let kSpreadDuration = 0.4
let kColumnHasIndicator = true         // 默认有指示线条
let kColumnIndictorH:CGFloat = 2        // 指示线条高度
let kColumnViewH:CGFloat = 48.0

let kColumnIndicatorColor = UIColor.color3CA5FF()
let kColumnTitleMargin:CGFloat = 44          // title按钮之间默认没有间距，这个值保证两个按钮的间距
let kColumnIndictorMinW : CGFloat = 60       // 指示条默认最小宽度
// title普通状态字体
let columnTitleNormalFont:CGFloat = (AYinches.inches47 || AYinches.inches55) ? 15 : 14

// title普通状态颜色
let columnTitleNormalColor   = UIColor.color666666()
// title选中状态颜色
let columnTitleSelectedColor = UIColor.color4182FF()

class AYColumnScrollView: UIScrollView {
    typealias TitleClickedCallback = (Int, String) -> Void
    var titleClickedCallback: TitleClickedCallback?

    var titles = [String]() {
        didSet {
            // 创建标题items
            setupTitleItems()
            // 创建指示器
            setupIndicator()
        }
    }

    // 保存实例化的item
    private var items = [UIButton]()
    // 记录选中的title button
    private var selectedButton = UIButton()
    // 标识是否已经初始化过了
    private var hasInit = false
    // 指示器
    private var indicator = UIView()
    // 指示器中的ImageView
    private lazy var innerImage:UIImageView = {
        let imageView = UIImageView()
        self.indicator.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.indicator)
            make.bottom.equalTo(self.indicator.snp.bottom)
        }
        return imageView
    }()

    /// 实例化item
    private func setupTitleItems() {
        var itemW: CGFloat = 0.0
        for i in 0 ..< titles.count {
            let title = titles[i]
            let item = UIButton()
            item.setTitle(title, for: .normal)
            item.sizeToFit()
            item.setTitleColor(columnTitleNormalColor, for: UIControl.State.normal)
            item.setTitleColor(columnTitleSelectedColor, for: UIControl.State.selected)
            item.setBackgroundImage(UIImage.image(UIColor.colore3edff()), for: .selected)
            item.titleLabel?.font = UIFont.systemFont(ofSize: columnTitleNormalFont)
            item.frame.size = CGSize(width: (item.frame.width + kColumnTitleMargin) > kColumnIndictorMinW ? item.frame.width + kColumnTitleMargin : kColumnIndictorMinW, height: kColumnHasIndicator ? kColumnViewH - kColumnIndictorH : kColumnViewH)     // 增加按钮宽度，达到间隙效果
            item.frame = CGRect(x: itemW, y: 0, width: item.frame.width, height: item.frame.height)
            itemW += item.frame.width
            item.tag = i

            item.addTarget(self, action: #selector(itemDidClick(_:)), for: .touchUpInside)

            items.append(item)
            addSubview(item)
            contentSize = CGSize(width: itemW, height: 0)
        }
    }

    /// 实例化指示器
    private func setupIndicator() {
        if hasInit { return }
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        guard kColumnHasIndicator else {
            return
        }
        let indicator = UIView(frame: CGRect(x:0, y: kColumnViewH - kColumnIndictorH, width: kScreenWidth/CGFloat(items.count), height: kColumnIndictorH))      // 默认取第一个按钮的宽度
        self.indicator = indicator
        indicator.backgroundColor = kColumnIndicatorColor
        insertSubview(indicator, at: 0)
        addSubview(indicator)
        hasInit = true
    }

    @objc private func itemDidClick(_ sender: UIButton) {
        // 切换选中的按钮
        changeItemStatus(button: sender)
        // 回调一下
        titleClickedCallback?(sender.tag, sender.titleLabel?.text ?? "")
    }

    // 改变选中按钮状态（指示器无动画）
    private func changeItemStatus(button : UIButton) {
        selectedButton.titleLabel?.font = UIFont.systemFont(ofSize: columnTitleNormalFont)
        selectedButton.isSelected = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: columnTitleNormalFont)
        button.isSelected = true
        selectedButton = button
        // 改变scrollview的contentOffset
        autoSuitItemsPosition()
        button.layoutIfNeeded()

        let btnWidth = button.frame.width
        let positionX = button.frame.origin.x

        // 改变指示器的frame
        UIView.animate(withDuration: 0.3) {
            self.indicator.frame = CGRect(x: positionX, y: kColumnViewH - kColumnIndictorH, width: btnWidth, height: kColumnIndictorH)
        }
    }


    /// 改变scrollview的contentOffset
   private func autoSuitItemsPosition() {
        UIView.animate(withDuration: kSpreadDuration) {
            if self.contentSize.width > self.frame.size.width {
                var desiredX = self.selectedButton.center.x - self.bounds.width/2
                if desiredX < 0 {
                    desiredX = 0
                }
                if desiredX > (self.contentSize.width - self.bounds.width) {
                    desiredX = self.contentSize.width - self.bounds.width
                }
                if !(self.bounds.width > self.contentSize.width) {
                    self.setContentOffset(CGPoint(x: desiredX, y: 0), animated: true)
                }
            }
        }
    }

}

// MARK: - 公共控制方法
extension AYColumnScrollView {
    // 将对应的title的item设置为选中状态(不带动画)
    func modifyItemStatusToSelected(title: String) {
        for item in items {
            if item.titleLabel?.text == title {
                changeItemStatus(button: item)
                return
            }
        }
    }
}

extension AYColumnScrollView {
    func changeFrameToAdjust(isHiddenIndicator:Bool = false, sizeCount:Int = 3) -> Void
    {
        // 缺省不隐藏
        indicator.isHidden = isHiddenIndicator

        var xPoint = CGFloat(0.0)
        let yPoint:CGFloat = 0.0
        for btn in items {
            btn.frame = CGRect.init(x: xPoint, y: yPoint, width: self.frame.width/(CGFloat)(sizeCount), height: self.frame.size.height)
            xPoint += btn.frame.size.width
            btn.contentMode = UIView.ContentMode.center
        }

    }

    // 钩子方法。钩子方法的另外一个用途:对流程进行控制
    func indicatorStateChange(isHidden:Bool = true){
        indicator.isHidden = isHidden
    }

}
