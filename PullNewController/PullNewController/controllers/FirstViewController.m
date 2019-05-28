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

@interface FirstViewController () <SGPageTitleViewDelegate, SGPageContentScrollViewDelegate,PullContainerViewControllerDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
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
        make.height.mas_equalTo(@(44+statusHeight));
    }];
    [button addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    
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
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    [headerView addSubview:_pageTitleView];
    [_pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView);
        make.right.mas_equalTo(headerView);
        make.bottom.mas_equalTo(headerView);
        make.height.mas_equalTo(pageTitleViewY-statusHeight);
    }];
    
    [_pageTitleView addBadgeForIndex:1];
    [_pageTitleView addBadgeForIndex:5];
    
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
    CGFloat ContentCollectionViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectZero parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    [self.pageContentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.pageTitleView.mas_bottom);
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

#pragma mark - PullContainerViewControllerDelegate

- (void)pullContainerViewController:(PullContainerViewController *)controller progress:(CGFloat)progress{
    PullContainerViewController * pullcontroller = (PullContainerViewController *) [self parentControllerKindOfClass:[PullContainerViewController class]];
    self.headerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -progress*pullcontroller.max);
    if (progress<0.1) {
        self.headerView.hidden = NO;
        self.headerView.alpha = 1-(progress/0.1);
    }else{
        self.headerView.hidden = YES;
    }
}

@end


