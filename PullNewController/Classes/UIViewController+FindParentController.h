//
//  UIViewController+FindParentController.h
//  PullNewController
//
//  Created by liyufeng on 2019/5/24.
//  Copyright © 2019 liyufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FindParentController)

- (UIViewController *)parentControllerKindOfClass:(Class)cls;

@end

NS_ASSUME_NONNULL_END
