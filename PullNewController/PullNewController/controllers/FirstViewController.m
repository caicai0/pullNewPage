//
//  DefaultScrollVC.m
//  SGPageViewExample
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "FirstViewController.h"
#import "SGPagingView.h"
#import "ListViewController.h"
#import "PullContainerViewController.h"
#import "UIViewController+FindParentController.h"
#import "PullContainerViewController.h"
#import "Masonry.h"

@interface FirstViewController ()
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;
@property (nonatomic, strong) UIView * headerView;

@end

@implementation FirstViewController

- (void)dealloc {
    NSLog(@"DefaultScrollVC - - dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndex:) name:@"changeSelectedIndex" object:nil];
    
    [self setupPageView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)changeSelectedIndex:(NSNotification *)noti {
    _pageTitleView.resetSelectedIndex = [noti.object integerValue];
}

- (void)setupPageView {
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        pageTitleViewY = 64;
    } else {
        pageTitleViewY = 88;
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_equalTo(@(44));
    }];
    [button addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    
    ListViewController *oneVC = [[ListViewController alloc] init];
    ListViewController *twoVC = [[ListViewController alloc] init];
    UIViewController *threeVC = [[UIViewController alloc] init];
    UIViewController *fourVC = [[UIViewController alloc] init];
    UIViewController *fiveVC = [[UIViewController alloc] init];
    UIViewController *sixVC = [[UIViewController alloc] init];
    UIViewController *sevenVC = [[UIViewController alloc] init];
    UIViewController *eightVC = [[UIViewController alloc] init];
    UIViewController *nineVC = [[UIViewController alloc] init];
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC, fiveVC, sixVC, sevenVC, eightVC, nineVC];
    /// pageContentScrollView
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectZero parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    [self.pageContentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(button.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)backToMain{
    PullContainerViewController * pullController = (PullContainerViewController *)[self parentControllerKindOfClass:[PullContainerViewController class]];
    [pullController changeToStatus:PullContainerViewControllerStatusDefault];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index {
    if (index == 1 || index == 5) {
        [_pageTitleView removeBadgeForIndex:index];
    }
    PullContainerViewController * pullController = (PullContainerViewController *)[self parentControllerKindOfClass:[PullContainerViewController class]];
    pullController.panOffset = 0;
    pullController.handlPan = YES;
}

@end


