//
//  ViewController.swift
//  AYSegmentControl
//
//  Created by Andy on 2019/8/28.
//  Copyright © 2019 wangyawei. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var scrollIndex = 0
    //hScrollView是否需要被布局
    var isNeedLayout = true
    let topConstant: CGFloat = 64
    var dataArray:[String] {
        return ["粉丝榜", "礼物榜"]
    }
    // 是否有TabBar
    var isHasTabBar = false

    /// 横向滚动的scrollView
    private(set) lazy var hScrollView : AYColumnScrollView = {
        let hScrollView = AYColumnScrollView()
        // 回调
        hScrollView.titleClickedCallback = {
            [weak self](tag : Int, title: String) -> Void in
            //点击上面条目的时候
            var point = self!.contentView.contentOffset
            point.x = self!.view.frame.size.width*(CGFloat)(tag)
            self!.contentView.setContentOffset(point, animated: true)
        }
        hScrollView.layer.cornerRadius = 6
        hScrollView.layer.borderWidth = 1
        hScrollView.layer.borderColor = UIColor.hexString("4182FF").cgColor
        hScrollView.titles = self.dataArray
        // 初始化的时候默认选中第0个
        if (self.dataArray.count > 0){
            hScrollView.modifyItemStatusToSelected(title: self.dataArray[0])
        }

        self.view.addSubview(hScrollView)

        hScrollView.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(200)
            make.top.equalTo(self.topConstant)
            make.height.equalTo(32)
        })
        return hScrollView
    }()

    // MARK: - getter&&setter
    lazy var contentView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        let width = self.view.frame.size.width

        scrollView.contentSize = CGSize.init(width: (CGFloat)(self.children.count)*width, height: 0)
        self.view.insertSubview(scrollView, at: 0)

        let contentSet = self.isHasTabBar ? -49 : 0
        scrollView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(0)
            make.width.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(contentSet)
            make.top.equalTo(self.hScrollView.snp.bottom)
        }

        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("父类的--viewDidLoad")
        addChildenVc()
        view.layoutIfNeeded()
        contentView.setContentOffset(CGPoint(x: kScreenWidth * CGFloat(scrollIndex), y: 0), animated: true)

        if scrollIndex == 0 {
            scrollViewDidEndScrollingAnimation(contentView)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isNeedLayout {
            return
        }
        hScrollView.changeFrameToAdjust(isHiddenIndicator: true, sizeCount: 2)
    }


    func addChildenVc() {

        print("父类的-addChildenVc")
    }


    func exchangeTypeWith(index: Int) {

    }

}



extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 获取滚动的页面下标
        let currentIndex = self.contentView.contentOffset.x/self.view.frame.size.width
        let chooseIndex = (Int)(currentIndex)
        hScrollView.modifyItemStatusToSelected(title: self.dataArray[chooseIndex])
        view.layoutIfNeeded()
        // 加载控制器的view
        let vc = children[chooseIndex]
        vc.view.frame = CGRect(x: contentView.contentOffset.x, y: 0, width: kScreenWidth, height: contentView.frame.height)
        contentView.addSubview(vc.view)

        exchangeTypeWith(index: chooseIndex)
    }
}


/*
extension UISegmentedControl {

 /*
 func segmentControlTest() {
 let segment = UISegmentedControl(items: ["测试一", "测试二", "测试三"])
 segment.frame = CGRect(x: 100, y: 100, width: 250, height: 40)
 segment.center.x = self.view.center.x

 segment.setSegmentStyle(normalColor: UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0), selectedColor: UIColor(red: 251/255.0, green: 84/255.0, blue: 6/255.0, alpha: 1.0), dividerColor: UIColor.clear)
 segment.selectedSegmentIndex = 0
 view.addSubview(segment)
 }*/


    /// 自定义样式
    /// - Parameters:
    ///   - normalColor: 普通状态下背景色
    ///   - selectedColor: 选中状态下背景色
    ///   - dividerColor: 选项之间的分割线颜色
    func setSegmentStyle(normalColor: UIColor, selectedColor: UIColor, dividerColor: UIColor) {

        let normalColorImage = UIImage.renderImageWithColor(normalColor, size: CGSize(width: 1.0, height: 1.0))
        let selectedColorImage = UIImage.renderImageWithColor(selectedColor, size: CGSize(width: 1.0, height: 1.0))
        let dividerColorImage = UIImage.renderImageWithColor(dividerColor, size: CGSize(width: 1.0, height: 1.0))

        setBackgroundImage(normalColorImage, for: .normal, barMetrics: .default)
        setBackgroundImage(selectedColorImage, for: .selected, barMetrics: .default)
        setDividerImage(dividerColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        // 文字在两种状态下的颜色
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .selected)

        // 边界颜色、圆角
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = dividerColor.cgColor
        self.layer.masksToBounds = true
    }
}


//通过输入rgb值返回一个该颜色的img
extension UIImage{
    public class func renderImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIImage()
        }
        context.setFillColor(color.cgColor);
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height));
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }
}*/
