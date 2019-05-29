//
//  FirstViewController.h
//  PullNewController
//
//  Created by liyufeng on 2019/5/23.
//  Copyright © 2019 liyufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGPagingView.h"
#import "PullContainerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FirstViewController : UIViewController <SGPageTitleViewDelegate, SGPageContentScrollViewDelegate,PullContainerViewControllerDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;

@end

NS_ASSUME_NONNULL_END
