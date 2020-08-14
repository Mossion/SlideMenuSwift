//
//  ViewController.swift
//  SlideMenuSwift
//
//  Created by LTMAC on 2020/8/11.
//  Copyright © 2020 LTMAC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .red
        
        self.view.addSubview(self.leftButton)
        self.leftButton.frame = CGRect.init(x: 100, y: 100, width: 150, height: 30)
        self.view.addSubview(self.rightButton)
        self.rightButton.frame = CGRect.init(x: 100, y: 200, width: 150, height: 30)
        self.view.addSubview(self.slideEnableButton)
        self.slideEnableButton.frame = CGRect.init(x: 100, y: 300, width: 150, height: 30)
    }
    
    @objc func leftButtonClick() {
        self.lt_slideMenu?.showLeftViewController(animated: true)
    }
    
    @objc func rigthButtonClick() {
        self.lt_slideMenu?.showRightViewController(animated: true)
    }
    
    @objc func slideEnableButtonClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.lt_slideMenu?.slideEnabled = !btn.isSelected
    }
    
    lazy var leftButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("左侧滑", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var rightButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("右侧滑", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(rigthButtonClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var slideEnableButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("禁止手势滑动", for: .normal)
        btn.setTitle("启动手势滑动", for: .selected)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(slideEnableButtonClick(btn:)), for: .touchUpInside)
        return btn
    }()
}

