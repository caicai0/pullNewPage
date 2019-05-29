//
//  PullContainerViewController.h
//  PullNewController
//
//  Created by liyufeng on 2019/5/23.
//  Copyright © 2019 liyufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PullContainerViewControllerStatus) {
    PullContainerViewControllerStatusDefault, //初始状态
    PullContainerViewControllerStatusShowTop //显示top页面后
};

@class PullContainerViewController;

@protocol PullContainerViewControllerDelegate <NSObject>

- (void)pullContainerViewController:(PullContainerViewController *)controller progress:(CGFloat)progress;

@end

@interface PullContainerViewController : UIViewController
//拖动过程控制参数
@property (nonatomic, assign)CGFloat panOffset;//拖动手势的偏移量
@property (nonatomic, assign)BOOL handlPan;//是否处理拖动事件
//属性参数
@property (nonatomic, strong)NSPointerArray * delegates;
@property (nonatomic, assign)CGFloat middle;//分界点
@property (nonatomic, assign)CGFloat max;//最大极限位置
@property (nonatomic, assign, readonly)PullContainerViewControllerStatus status;//状态
@property (nonatomic, assign, readonly)PullContainerViewControllerStatus willChangeToStatus;//将要变化到的样子
@property (nonatomic, assign, readonly)BOOL pulling;//拖动中

@property (nonatomic, strong, readonly) UIViewController *topVC;
@property (nonatomic, strong, readonly) UIViewController *mainVC;
@property (nonatomic, assign) UIEdgeInsets topEdgeInsets;//顶部页面的边距信息
@property (nonatomic, assign) UIEdgeInsets mainEdegeInsets;//主页面的边距信息

- (instancetype)initWithTopView:(UIViewController *)topVC
                    andMainView:(UIViewController *)mainVC;

- (void)changeToStatus:(PullContainerViewControllerStatus)status;//调用切换状态

@end

NS_ASSUME_NONNULL_END
