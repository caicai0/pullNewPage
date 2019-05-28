//
//  TabBarController.swift
//  PullViewController-Swift
//
//  Created by liyufeng on 2019/5/27.
//  Copyright © 2019 liyufeng. All rights reserved.
//

import UIKit

@objc class TabBarController: UITabBarController {
    var tabBarOriginFrame : CGRect = CGRect.zero
    var willTabBarHidden : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let main = FirstViewController()
        let top = SecondViewController()
        let pullController = PullContainerViewController(topVc: top, mainVc: main)
        pullController.delegates.addPointer(Unmanaged.passRetained(self).toOpaque())
        pullController.delegates.addPointer(Unmanaged.passRetained(top).toOpaque())
        pullController.delegates.addPointer(Unmanaged.passRetained(main).toOpaque())
        pullController.middle = (UIScreen.main.bounds.size.height-83)/3
        pullController.max = (UIScreen.main.bounds.size.height-83)
        pullController.tabBarItem = UITabBarItem(title: "pull", image: nil, tag: 0)
        var arr = Array<UIViewController>()
        arr.append(pullController)
        setViewControllers(arr, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarOriginFrame = tabBar.frame
        willTabBarHidden = tabBar.isHidden
    }
    
    func setTabBar(hidden:Bool,animation:Bool) {
        if tabBar.isHidden == hidden {
            return
        }
        if willTabBarHidden == hidden {
            return
        }
        willTabBarHidden = hidden
        func handle() {
            if hidden {
                let frame : CGRect = tabBar.frame
                tabBar.frame = CGRect(x: frame.origin.x, y: tabBarOriginFrame.origin.y+frame.size.height, width: frame.size.width, height: frame.size.height)
                tabBar.alpha = 0
            }else{
                let frame : CGRect = tabBar.frame
                tabBar.frame = CGRect(x: frame.origin.x, y: tabBarOriginFrame.origin.y, width: frame.size.width, height: frame.size.height)
                tabBar.alpha = 1
            }
        }
        if animation {
            UIView.animate(withDuration: 0.1, animations: {
                handle()
            }) { (finish) in
                self.tabBar.isHidden = hidden
            }
        }
    }
}

extension TabBarController:PullContainerViewControllerDelegate {
    func pullContainerViewController(controller: PullContainerViewController, progress: CGFloat) {
        if controller.status == .top {
            if !tabBar.isHidden {
                setTabBar(hidden: true, animation: true)
            }
        }else{
            if tabBar.isHidden {
                setTabBar(hidden: false, animation: true)
            }
        }
    }
}
