//
//  LTSlideMenu.swift
//  SlideMenuSwift
//
//  Created by LTMAC on 2020/8/11.
//  Copyright © 2020 LTMAC. All rights reserved.
//

import UIKit

let MenuWidthScale: CGFloat = 0.8;
let MaxCoverAlpha: CGFloat = 0.3;
let MinActionSpeed: CGFloat = 500.0;

class LTSlideMenu: UIViewController {
    
    init(withRootController controller: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        rootViewController = controller
        self.addChild(rootViewController!)
        self.view.addSubview((rootViewController?.view)!)
        rootViewController?.didMove(toParent: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .blue
        updateLeftMenuFrame()
        updateRightMenuFrame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.pan)
        rootViewController?.view.addSubview(self.coverView)
    }
    
    // MARK: -- Other method
    private func updateLeftMenuFrame() {
        leftViewController?.view.center = CGPoint.init(x: (rootViewController?.view.frame.minX)! / 2, y: (leftViewController?.view.center.y)!)
    }
    
    private func updateRightMenuFrame() {
        rightViewController?.view.center = CGPoint.init(x: (self.view.bounds.width + (rootViewController?.view.frame.maxX)!) / 2, y: (rightViewController?.view.center.y)!)
    }
    
    func animationDuration(animated: Bool) -> CGFloat {
        return animated ? 0.25 : 0
    }
    
    // MARK: -- Action
    @objc func panOnMenu(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            originPoint = rootViewController?.view.center
            break
        case .changed:
            panChanged(pan: pan)
            break
        case .ended:
            panEnd(pan: pan)
            break
        default:
            break
        }
    }
    
    func panChanged(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: self.view)
        rootViewController?.view.center = CGPoint.init(x: originPoint!.x + translation.x, y: originPoint!.y)
        if (rightViewController == nil && (rootViewController?.view.frame.minX)! <= 0.0) {
            rootViewController?.view.frame = self.view.bounds
        }
        if leftViewController == nil && (rootViewController?.view.frame.minX)! >= 0.0 {
            rootViewController?.view.frame = self.view.bounds
        }
        // 滑动到边界后不可以再滑动
        if (rootViewController?.view.frame.minX)! > self.menuWidth() {
            rootViewController?.view.center = CGPoint.init(x: (rootViewController?.view.bounds.width)! / 2 + self.menuWidth(), y: (rootViewController?.view.center.y)!)
        }
        if (rootViewController?.view.frame.maxX)! < self.emptyWidth {
            rootViewController?.view.center = CGPoint.init(x: (rootViewController?.view.bounds.width)! / 2 - self.menuWidth(), y: (rootViewController?.view.center.y)!)
        }
        // 判断显示左菜单还是右菜单
        if (rootViewController?.view.frame.minX)! > 0.0 {
            if rightViewController != nil {
                self.view.sendSubviewToBack((rightViewController?.view)!)
            }
            updateLeftMenuFrame()
            coverView.isHidden = false
            rootViewController?.view.bringSubviewToFront(coverView)
            coverView.alpha = (rootViewController?.view.frame.minX)! / self.menuWidth() * MaxCoverAlpha
        } else if (rootViewController?.view.frame.minX)! < 0.0 {
            if leftViewController != nil {
                self.view.sendSubviewToBack((leftViewController?.view)!)                
            }
            updateRightMenuFrame()
            coverView.isHidden = false
            rootViewController?.view.bringSubviewToFront(coverView)
            coverView.alpha = ((self.view.frame.maxX) - (rootViewController?.view.frame.maxX)!) / self.menuWidth() * MaxCoverAlpha
        }
    }
    
    func panEnd(pan: UIPanGestureRecognizer) {
        let speedX: CGFloat = pan.velocity(in: pan.view).x
        if fabsf(Float(speedX)) > Float(MinActionSpeed) {
            self.dealWithFastSliding(speedX: speedX)
            return
        }
        // 正常速度
        if (rootViewController?.view.frame.minX)! > self.menuWidth() / 2 {
            showLeftViewController(animated: true)
        } else if (rootViewController?.view.frame.maxX)! < self.menuWidth() / 2 + self.emptyWidth {
            showRightViewController(animated: true)
        } else {
            showRootViewController(animated: true)
        }
    }
    
    func dealWithFastSliding(speedX: CGFloat) {
        // 向→滑动
        let swipeRight = speedX > 0
        // 向←滑动
        let swipeLeft = speedX < 0
        let rootX: CGFloat = (rootViewController?.view.frame.minX)!
        if swipeRight {
            if rootX > 0 {
                // 显示左菜单
                showLeftViewController(animated: true)
            } else if rootX < 0 {
                // 显示主菜单
                showRootViewController(animated: true)
            }
        }
        if swipeLeft {
            if rootX < 0 {
                showRightViewController(animated: true)
            } else if rootX > 0 {
                showRootViewController(animated: true)
            }
        }
    }
    
    @objc func panOnCoverView(tap: UITapGestureRecognizer) {
        showRootViewController(animated: true)
    }
    
    // MARK: -- Show / Hide
    func showLeftViewController(animated: Bool) {
        guard leftViewController != nil else {
            return
        }
        if rightViewController != nil {
            self.view.sendSubviewToBack((rightViewController?.view)!)
        }
        coverView.isHidden = false
        rootViewController?.view.bringSubviewToFront(coverView)
        UIView.animate(withDuration: TimeInterval(animationDuration(animated: animated)), animations: {
            self.rootViewController?.view.center = CGPoint.init(x: (self.rootViewController?.view.bounds.width)! / 2 + self.menuWidth(), y: (self.leftViewController?.view.center.y)!)
            self.leftViewController?.view.frame = CGRect.init(x: 0, y: 0, width: self.menuWidth(), height: self.view.bounds.height)
            self.coverView.alpha = MaxCoverAlpha
        }) { (finished) in
        }
    }
    
    func showRightViewController(animated: Bool) {
        guard rightViewController != nil else {
            return
        }
        if leftViewController != nil {
            self.view.sendSubviewToBack((leftViewController?.view)!)
        }
        coverView.isHidden = false
        rootViewController?.view.bringSubviewToFront(coverView)
        UIView.animate(withDuration: TimeInterval(animationDuration(animated: animated)), animations: {
            self.rootViewController?.view.center = CGPoint.init(x: (self.rootViewController?.view.bounds.width)! / 2 - self.menuWidth(), y: (self.rootViewController?.view.center.y)!)
            self.rightViewController?.view.frame = CGRect.init(x: self.emptyWidth, y: 0, width: self.menuWidth(), height: self.view.bounds.height)
            self.coverView.alpha = MaxCoverAlpha
        }) { (finished) in
            
        }
    }
    
    func showRootViewController(animated: Bool) {
        UIView.animate(withDuration: TimeInterval(animationDuration(animated: animated)), animations: {
            var frame = self.rootViewController?.view.frame
            frame?.origin.x = 0
            self.rootViewController?.view.frame = frame!
            self.updateLeftMenuFrame()
            self.updateRightMenuFrame()
            self.coverView.alpha = 0
        }) { (finish) in
            self.coverView.isHidden = true
        }
    }
    
    // MARK: -- 属性
    var originPoint: CGPoint?
    /// 根控制器
    var rootViewController: UIViewController?
    /// 左抽屉
    var leftViewController: UIViewController? {
        willSet {
            self.leftViewController = newValue
            leftViewController!.view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: menuWidth(), height: self.view.bounds.height))
            leftViewController!.viewDidLoad()
            self.addChild(leftViewController!)
            self.view.insertSubview((leftViewController!.view)!, at: 0)
            leftViewController!.didMove(toParent: self)
        }
    }
    /// 右抽屉
    var rightViewController: UIViewController? {
        willSet {
            self.rightViewController = newValue
            rightViewController!.view = UIView.init(frame: CGRect.init(x: self.emptyWidth, y: 0, width: self.menuWidth(), height: self.view.bounds.height))
            rightViewController!.viewDidLoad()
            self.addChild(rightViewController!)
            self.view.insertSubview(rightViewController!.view, at: 0)
            rightViewController!.didMove(toParent: self)
        }
    }
    /// 导航控制器
    var naviRootViewController: UINavigationController? {
        let navi: UINavigationController = self.rootViewController as! UINavigationController
        return navi
    }
    
    /// 是否支持手势滑动
    var slideEnabled: Bool = true {
        didSet {
            self.pan.isEnabled = slideEnabled
        }
    }
    
    /// 空白的宽度，只读
    var emptyWidth: CGFloat {
        return self.view.bounds.size.width - menuWidth()
    }
    
    /// 菜单宽度
    func menuWidth() -> CGFloat {
        return CGFloat(MenuWidthScale) * self.view.bounds.width
    }
    
    /// 手势
    lazy var pan: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panOnMenu(pan:)))
        pan.delegate = self
        return pan
    }()
    
    /// 遮罩图
    lazy var coverView: UIView = {
        let view = UIView.init(frame: self.view.bounds)
        view.alpha = 0
        view.isHidden = true
        view.backgroundColor = UIColor.black
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(panOnCoverView(tap:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    override var shouldAutorotate: Bool {
        return false
    }
}

extension LTSlideMenu: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 设置Navigation 子视图不可拖拽
        if (self.rootViewController?.isKind(of: UINavigationController.self))! {
            let navigationController = self.rootViewController as! UINavigationController
            if navigationController.viewControllers.count > 1 && ((navigationController.interactivePopGestureRecognizer?.isEnabled) != nil){
                return false
            }
        }
        // 设置拖拽响应范围
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let actionWidth = self.emptyWidth
            let touchPoint = touch.location(in: gestureRecognizer.view)
            if touchPoint.x <= actionWidth || touchPoint.x > self.view.bounds.width - actionWidth  {
                return true
            } else {
                return false
            }
        }
        return true
    }
}

extension UIViewController {
    var lt_slideMenu: LTSlideMenu? {
        get {
            var slideMenu: UIViewController? = self.parent
            while slideMenu != nil {
                if (slideMenu?.isKind(of: LTSlideMenu.self))! {
                    return slideMenu as? LTSlideMenu
                } else if slideMenu?.parent != nil && slideMenu?.parent != slideMenu {
                    slideMenu = slideMenu?.parent
                } else {
                    return nil
                }
            }
            return nil
        }
    }
}


