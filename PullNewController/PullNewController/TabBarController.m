//
//  TabBarController.m
//  PullNewController
//
//  Created by liyufeng on 2019/5/26.
//  Copyright © 2019 liyufeng. All rights reserved.
//

#import "TabBarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "MainPullViewController.h"
#import "ListViewController.h"

@interface TabBarController ()<PullContainerViewControllerDelegate>

@property (nonatomic, assign)CGRect tabBarOriginFrame;
@property (nonatomic, assign)BOOL willTabBarHidden;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController * top = [[ListViewController alloc]initWithNibName:nil bundle:nil];
    UIViewController * main = [[FirstViewController alloc]initWithNibName:nil bundle:nil];
    PullContainerViewController * pullController = [[MainPullViewController alloc]initWithTopView:top andMainView:main];
    [pullController.delegates addPointer:(void * _Nullable)(self)];
    
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    pullController.middle = ([UIScreen mainScreen].bounds.size.height-statusHeight-44)/3;
    pullController.max = ([UIScreen mainScreen].bounds.size.height-statusHeight-44);
    pullController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"pull" image:nil tag:0];
    NSMutableArray * arr = [NSMutableArray arrayWithArray:self.viewControllers];
    [arr addObject:pullController];
    [self setViewControllers:[NSArray arrayWithArray:arr] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarOriginFrame = self.tabBar.frame;
    self.willTabBarHidden = self.tabBar.hidden;
}

- (void)setTabbarHidden:(BOOL)hidden animation:(BOOL)animation{
    if (self.tabBar.hidden == hidden) {
        return;
    }
    if (self.willTabBarHidden == hidden) {
        return;
    }
    self.willTabBarHidden = hidden;
    __weak typeof(self)weakSelf = self;
    void(^handle)(void) = ^{
        if (hidden) {
            CGRect frame = self.tabBar.frame;
            weakSelf.tabBar.frame = CGRectMake(frame.origin.x, self.tabBarOriginFrame.origin.y+frame.size.height, frame.size.width, frame.size.height);
            weakSelf.tabBar.alpha = 0;
        }else{
            CGRect frame = self.tabBar.frame;
            weakSelf.tabBar.frame = CGRectMake(frame.origin.x, self.tabBarOriginFrame.origin.y, frame.size.width, frame.size.height);
            weakSelf.tabBar.alpha = 1;
        }
    };
    if (animation) {
        [UIView animateWithDuration:0.1 animations:^{
            handle();
        } completion:^(BOOL finished) {
            weakSelf.tabBar.hidden = hidden;
        }];
    }else{
        handle();
        weakSelf.tabBar.hidden = hidden;
    }
}

- (void)pullContainerViewController:(PullContainerViewController *)controller progress:(CGFloat)progress{
    if (controller.willChangeToStatus == PullContainerViewControllerStatusShowTop) {
        if (!self.tabBar.hidden) {
            [self setTabbarHidden:YES animation:YES];
        }
    }else{
        if (self.tabBar.hidden) {
            [self setTabbarHidden:NO animation:YES];
        }
    }
}

@end
