//
//  UIViewController+FindParentController.m
//  PullNewController
//
//  Created by liyufeng on 2019/5/24.
//  Copyright © 2019 liyufeng. All rights reserved.
//

#import "UIViewController+FindParentController.h"

@implementation UIViewController (FindParentController)

- (UIViewController *)parentControllerKindOfClass:(Class)cls{
    UIViewController * parentController = self.parentViewController;
    while (parentController && ![parentController isKindOfClass:cls]) {
        parentController = parentController.parentViewController;
    }
    return parentController;
}

@end
