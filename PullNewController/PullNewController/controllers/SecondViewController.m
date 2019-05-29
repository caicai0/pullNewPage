//
//  SecondViewController.m
//  PullNewController
//
//  Created by liyufeng on 2019/5/23.
//  Copyright © 2019 liyufeng. All rights reserved.
//

#import "SecondViewController.h"
#import "Masonry.h"
#import "PullContainerViewController.h"
#import "GPUImage.h"

#define MIN_SCALE (0.5)

@interface SecondViewController ()<UITableViewDelegate, UITableViewDataSource, PullContainerViewControllerDelegate>

@property (nonatomic, strong)UIView * containerView;
@property (nonatomic, strong)UITableView * tableView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    UIView * containerView = [[UIView alloc]init];
    [self.view addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    self.containerView = containerView;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [containerView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView);
        make.right.mas_equalTo(containerView);
        make.top.mas_equalTo(containerView).mas_offset(20);
        make.bottom.mas_equalTo(containerView);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, MIN_SCALE, MIN_SCALE);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = indexPath.description;
    return cell;
}

#pragma mark - PullContainerViewControllerDelegate
- (void)pullContainerViewController:(PullContainerViewController *)controller progress:(CGFloat)progress{
    CGFloat mp = 0.3;
    if (progress < mp) {
        CGFloat p = (mp-progress)/mp;
        CGFloat scale = (1.0 - MIN_SCALE) * (1 - p) + MIN_SCALE;
        self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    }else{
        self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    }
}

@end
