//
//  ViewController.m
//  PullNewController
//
//  Created by liyufeng on 2019/5/23.
//  Copyright © 2019 liyufeng. All rights reserved.
//

#import "ViewController.h"
#import "PullContainerViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}

- (IBAction)clicked:(id)sender {
    UIViewController * top = [[SecondViewController alloc]initWithNibName:nil bundle:nil];
    UIViewController * main = [[FirstViewController alloc]initWithNibName:nil bundle:nil];
    PullContainerViewController * pullController = [[PullContainerViewController alloc]initWithTopView:top andMainView:main];
    pullController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"pull" image:nil tag:0];
    NSMutableArray * arr = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    [arr addObject:pullController];
    [self.tabBarController setViewControllers:[NSArray arrayWithArray:arr] animated:YES];
}

@end
