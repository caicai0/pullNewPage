//
//  MainPullViewController.m
//  PullNewController
//
//  Created by liyufeng on 2019/5/28.
//  Copyright © 2019 liyufeng. All rights reserved.
//

#import "MainPullViewController.h"
#import "Masonry.h"
#import "SGPagingView.h"
#import "FirstViewController.h"

@interface MainPullViewController () <PullContainerViewControllerDelegate>

@property (nonatomic, strong)UIView * headerView;
@property (nonatomic, strong)SGPageTitleView * pageTitleView;

@end

@implementation MainPullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.delegates addPointer:(__bridge void * _Nullable)(self)];
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        pageTitleViewY = 64;
    } else {
        pageTitleViewY = 88;
    }
    
    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(pageTitleViewY));
    }];
    self.headerView = headerView;
    
    NSArray *titleArr = @[@"精选", @"电影", @"电视剧", @"综艺", @"NBA", @"娱乐", @"动漫", @"演唱会", @"VIP会员"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:(FirstViewController *)self.mainVC titleNames:titleArr configure:configure];
    [headerView addSubview:_pageTitleView];
    [_pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView);
        make.right.mas_equalTo(headerView);
        make.bottom.mas_equalTo(headerView);
        make.height.mas_equalTo(pageTitleViewY-statusHeight);
    }];
    
    [_pageTitleView addBadgeForIndex:1];
    [_pageTitleView addBadgeForIndex:5];
    ((FirstViewController *)self.mainVC).pageTitleView = _pageTitleView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.headerView];
}

#pragma mark - PullContainerViewControllerDelegate

- (void)pullContainerViewController:(PullContainerViewController *)controller progress:(CGFloat)progress{
//    self.headerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -progress*controller.max);
    if (progress<0.1) {
        self.headerView.hidden = NO;
        self.headerView.alpha = 1-(progress/0.1);
    }else{
        self.headerView.hidden = YES;
    }
}

@end
