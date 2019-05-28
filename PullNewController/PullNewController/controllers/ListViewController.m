//
//  ListViewController.m
//  PullNewController
//
//  Created by liyufeng on 2019/5/23.
//  Copyright © 2019 liyufeng. All rights reserved.
//

#import "ListViewController.h"
#import "MJRefresh.h"
#import "CenterTouchTableView.h"
#import "PullContainerViewController.h"
#import "Masonry.h"
#import "UIViewController+FindParentController.h"

@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource ,UIGestureRecognizerDelegate>

@property (nonatomic, strong)CenterTouchTableView * tableView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[CenterTouchTableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        NSLog(@"%@",self.tableView.mj_header);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height* 2);
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    __weak typeof(self)weakSelf = self;
    [self.tableView setPanStart:^{
        //更新偏移量
        PullContainerViewController * pullController = (PullContainerViewController *)[weakSelf parentControllerKindOfClass:[PullContainerViewController class]];
        pullController.panOffset = -weakSelf.tableView.contentOffset.y;
    }];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"];
    cell.textLabel.text = @"sdfasfsdfs";
    return cell;
}

#pragma mark - scrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //调整scrollView.bounces
    CGFloat fullPage = scrollView.contentSize.height - scrollView.bounds.size.height;
    if (fullPage<0) {
        fullPage = 0;
    }
    if (scrollView.contentOffset.y <= (fullPage/2)) {
        scrollView.bounces = NO;
    }else{
        scrollView.bounces = YES;
    }
    //调整pullController.handlPan
    PullContainerViewController * pullController = (PullContainerViewController *)[self parentControllerKindOfClass:[PullContainerViewController class]];
    if (scrollView.panGestureRecognizer.numberOfTouches) {
        if (scrollView.contentOffset.y <= 0) {
            pullController.handlPan = YES;
        }else{
            pullController.handlPan = NO;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

@end
