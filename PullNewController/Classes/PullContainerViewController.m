//
//  PullContainerViewController.m
//  PullNewController
//
//  Created by liyufeng on 2019/5/23.
//  Copyright © 2019 liyufeng. All rights reserved.
//

#import "PullContainerViewController.h"
#import "FXBlurView.h"

@interface PullContainerViewController ()<UIGestureRecognizerDelegate>
//public
@property (nonatomic, assign)PullContainerViewControllerStatus status;//状态
@property (nonatomic, assign)PullContainerViewControllerStatus willChangeToStatus;//将要变化到的样子
@property (nonatomic, assign)BOOL pulling;//拖动中
@property (nonatomic, strong) UIViewController *topVC;
@property (nonatomic, strong) UIViewController *mainVC;
//private
@property (nonatomic, strong)UIPanGestureRecognizer * pan;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)FXBlurView * blurView;

@end

@implementation PullContainerViewController

/**
 @brief 初始化侧滑控制器
 @param topVC 左视图控制器
 mainVC 中间视图控制器
 @result instancetype 初始化生成的对象
 */
- (instancetype)initWithTopView:(UIViewController *)topVC
                     andMainView:(UIViewController *)mainVC
{
    if(self = [super init]){
        self.delegates = [NSPointerArray weakObjectsPointerArray];
        self.handlPan = YES;
        self.mainEdegeInsets = UIEdgeInsetsZero;
        self.topEdgeInsets = UIEdgeInsetsZero;
        self.scrollView = [[UIScrollView alloc]init];
        self.topVC = topVC;
        self.mainVC = mainVC;
        [self.delegates addPointer:(__bridge void * _Nullable)(self.topVC)];
        [self.delegates addPointer:(__bridge void * _Nullable)(self.mainVC)];
    }
    return self;
}

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self.childViewControllers containsObject:self.mainVC]) {
        [self addChildViewController:self.mainVC];
        [self.view addSubview:self.mainVC.view];
        [self addAutolayoutToView:self.mainVC.view superView:self.view edgeInsets:self.mainEdegeInsets];
        self.mainVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.mainVC.view.layer.shadowOpacity = 0.2;
        self.mainVC.view.layer.shadowRadius = 10;
        //滑动手势
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self.mainVC.view addGestureRecognizer:self.pan];
        [self.pan setCancelsTouchesInView:YES];
        self.pan.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.middle) {
        self.middle = self.view.bounds.size.height/2;
    }
    if (!self.max) {
        self.max = self.view.bounds.size.height;
    }
}

- (void)setPanOffset:(CGFloat)panOffset{
    _panOffset = panOffset;
    if (panOffset<0) {
        self.handlPan = NO;
    }else{
        self.handlPan = YES;
    }
}

- (void)changeToStatus:(PullContainerViewControllerStatus)status{
    if (self.status == status) {
        return;
    }
    if (_willChangeToStatus == status) {
        return;
    }
    if (status == PullContainerViewControllerStatusDefault) {
        [UIView animateWithDuration:0.2 animations:^{
            self.mainVC.view.transform = CGAffineTransformIdentity;
            [self updateDelegate:0];
        } completion:^(BOOL finished) {
            self.status = PullContainerViewControllerStatusDefault;
            self.pulling = NO;
            [self updateDelegate:0];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.mainVC.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.max);
            [self updateDelegate:1];
        } completion:^(BOOL finished) {
            self.status = PullContainerViewControllerStatusShowTop;
            self.pulling = NO;
            [self updateDelegate:1];
        }];
    }
}

#pragma mark - private

- (void)addAutolayoutToView:(UIView *)view superView:(UIView *)superView edgeInsets:(UIEdgeInsets)edgeInsets{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:edgeInsets.left];
    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-edgeInsets.right];
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:edgeInsets.top];
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-edgeInsets.bottom];
    [superView addConstraints:@[left,right,top,bottom]];
}

//滑动手势
static CGFloat start = 0;
- (void) handlePan: (UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        start = self.mainVC.view.transform.ty;
    }
    
    if (self.status == PullContainerViewControllerStatusDefault) {
        if (self.pulling == NO) {
            self.pulling = YES;
        }
        CGFloat y = 0;
        if ((point.y > 0) && self.handlPan) {//下拉
            if (![self.childViewControllers containsObject:self.topVC]) {
                [self addTopView];
            }
            y = point.y+self.panOffset+start;
            if (y < 0) {
                y = 0;
            }else if(y > self.max){
                y = self.max;
            }
            //根据y做动画
            self.mainVC.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, y);
            //更新预测值
            self.willChangeToStatus = (y < self.middle)?PullContainerViewControllerStatusDefault:PullContainerViewControllerStatusShowTop;
            [self updateDelegate:y/self.max];
        }
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
            if (y<self.middle) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.mainVC.view.transform = CGAffineTransformIdentity;
                    [self updateDelegate:0];
                } completion:^(BOOL finished) {
                    self.status = PullContainerViewControllerStatusDefault;
                    self.pulling = NO;
                    [self updateDelegate:0];
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    self.mainVC.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.max);
                    [self updateDelegate:1];
                } completion:^(BOOL finished) {
                    self.status = PullContainerViewControllerStatusShowTop;
                    self.pulling = NO;
                    [self updateDelegate:1];
                }];
            }
        }
        
    }
    if (self.status == PullContainerViewControllerStatusShowTop) {
        if (self.pulling == NO) {
            self.pulling = YES;
        }
        CGFloat y = self.max;
        if ((point.y < 0) && self.handlPan) {//下拉
            y = point.y+start;
            if (y < 0) {
                y = 0;
            }else if(y > self.max){
                y = self.max;
            }
            //根据y做动画
            self.mainVC.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, y);
            //更新预测值
            self.willChangeToStatus = (y < self.middle)?PullContainerViewControllerStatusDefault:PullContainerViewControllerStatusShowTop;
            [self updateDelegate:y/self.max];
        }
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
            if (y<self.middle) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.mainVC.view.transform = CGAffineTransformIdentity;
                    [self updateDelegate:0];
                } completion:^(BOOL finished) {
                    self.status = PullContainerViewControllerStatusDefault;
                    self.pulling = NO;
                    [self updateDelegate:0];
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    self.mainVC.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.max);
                    [self updateDelegate:1];
                } completion:^(BOOL finished) {
                    self.status = PullContainerViewControllerStatusShowTop;
                    self.pulling = NO;
                    [self updateDelegate:1];
                }];
            }
        }
    }
}

- (void)updateDelegate:(CGFloat)progress{
    if (self.max != 0 && progress<(self.middle/self.max/2)) {
        CGFloat p = progress/(self.middle/self.max/2);
        CGFloat blurRadius = (5*(1-p));
        self.blurView.hidden = NO;
        self.blurView.blurRadius = blurRadius;
        self.blurView.dynamic = YES;
    }else{
        self.blurView.hidden = YES;
        self.blurView.dynamic = NO;
    }
    [self.delegates compact];
    NSArray * arr = self.delegates.allObjects;
    for (NSInteger i=0; i<arr.count; i++) {
        UIViewController<PullContainerViewControllerDelegate> * controller = arr[i];
        if (controller && [controller conformsToProtocol:@protocol(PullContainerViewControllerDelegate) ]) {
            if ([controller respondsToSelector:@selector(pullContainerViewController:progress:)]) {
                [controller pullContainerViewController:self progress:progress];
            }
        }
    }
}

- (void)addTopView{
    [self addChildViewController:self.topVC];
    [self.topVC beginAppearanceTransition:YES animated:NO];
    [self.view insertSubview:self.topVC.view atIndex:0];
    [self addAutolayoutToView:self.topVC.view superView:self.view edgeInsets:self.topEdgeInsets];
}

@end
