//
//  PullContainerViewController.swift
//  PullViewController-Swift
//
//  Created by liyufeng on 2019/5/27.
//  Copyright © 2019 liyufeng. All rights reserved.
//

import UIKit

enum Status {
    case main
    case top
}

@objc protocol PullContainerViewControllerDelegate {
    @objc optional
    func pullContainerViewController(controller:PullContainerViewController,progress:CGFloat)
}

@objc class PullContainerViewController: UIViewController{
    
    var topVc : UIViewController = UIViewController()
    var mainVc : UIViewController = UIViewController()
    
    var middle : CGFloat = 0
    var max : CGFloat = 0
    var status : Status = .main
    var willChangedToStatus : Status = .top
    var pulling : Bool = false
    //拖动控制参数
    public var handlPan : Bool = true;
    public var panOffset:CGFloat = 0 {
        didSet{
            handlPan = !(panOffset < 0)
        }
    }
    
    public let delegates : NSPointerArray = NSPointerArray.weakObjects()
    
    private var start:CGFloat = 0
    
    init(topVc:UIViewController,mainVc:UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.topVc = topVc
        self.mainVc = mainVc
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if middle == 0 {
            middle = view.bounds.size.height/2
        }
        if max == 0 {
            max = view.bounds.size.height
        }
        
        if !self.children.contains(mainVc) {
            self.addChild(mainVc)
            view.addSubview(mainVc.view)
            mainVc.view.frame = view.bounds
            //滑动手势
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(pan:)))
            mainVc.view .addGestureRecognizer(pan)
            pan.cancelsTouchesInView = true
            pan.delegate = self
        }
    }
    
    @objc func handlePan(pan:UIPanGestureRecognizer) -> () {
        let point = pan.translation(in: view)
        if pan.state == .began {
            start = mainVc.view.transform.ty
        }
        if status == .main {
            if pulling == false {
                pulling = true
            }
            var y : CGFloat = 0
            if point.y > 0 && handlPan {
                if !children.contains(topVc) {
                    addChild(topVc)
                    topVc.beginAppearanceTransition(true, animated: false)
                    view.insertSubview(topVc.view, at: 0)
                    topVc.view.frame = view.bounds
                }
                y = point.y + panOffset + start
                if y < 0 {
                    y = 0
                }else if y > max {
                    y = max
                }
                //根据y做动画
                mainVc.view.transform = CGAffineTransform(translationX: 0, y: y)
                willChangedToStatus = (y < middle) ? .main : .top
                updateDelegates(progress: y/max)
            }
            if pan.state == .ended || pan.state == .cancelled {
                if y < middle {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.mainVc.view.transform = CGAffineTransform.identity
                    }) { (_) in
                        self.status = .main
                        self.pulling = false
                        self.updateDelegates(progress: 0)
                    }
                }else{
                    UIView.animate(withDuration: 0.2, animations: {
                        self.mainVc.view.transform = CGAffineTransform(translationX: 0, y: self.max)
                    }) { (_) in
                        self.status = .top
                        self.pulling = false
                        self.updateDelegates(progress: 1)
                    }
                }
            }
        }
        if status == .top {
            if pulling == false {
                pulling = true
            }
            var y = max
            if point.y < 0 && self.handlPan {
                y = point.y + start
                if y < 0 {
                    y = 0
                }else if(y > max){
                    y = max
                }
                mainVc.view.transform = CGAffineTransform(translationX: 0, y: y)
                willChangedToStatus = (y < middle) ? .main : .top
                updateDelegates(progress: y/max)
            }
            if pan.state == .ended || pan.state == .cancelled {
                if y < middle {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.mainVc.view.transform = CGAffineTransform.identity
                    }) { (_) in
                        self.status = .main
                        self.pulling = false
                        self.updateDelegates(progress: 0)
                    }
                }else{
                    UIView.animate(withDuration: 0.2, animations: {
                        self.mainVc.view.transform = CGAffineTransform(translationX: 0, y: self.max)
                    }) { (_) in
                        self.status = .top
                        self.pulling = false
                        self.updateDelegates(progress: 1)
                    }
                }
            }
        }
    }
    func updateDelegates(progress:CGFloat) -> () {
        delegates.compact()
        for pointer in delegates.allObjects {
            (pointer as AnyObject).pullContainerViewController?(controller: self, progress: progress)
        }
    }
}

extension PullContainerViewController:UIGestureRecognizerDelegate {
    
}
