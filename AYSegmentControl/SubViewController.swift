
//
//  SubViewController.swift
//  AYSegmentControl
//
//  Created by Andy on 2019/8/28.
//  Copyright © 2019 wangyawei. All rights reserved.
//

import UIKit

class SubViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("子类的--viewDidLoad")

        title = "等级"
    }


    override func addChildenVc() {
         print("子类的-addChildenVc")
        let firstVc = UIViewController()
        firstVc.view.backgroundColor = UIColor.yellow
        addChild(firstVc)

        let secondVc = UIViewController()
        secondVc.view.backgroundColor = UIColor.purple
        addChild(secondVc)
    }

    override var dataArray: [String] {
        return ["粉丝榜", "礼物榜"]
    }
    
    


}
