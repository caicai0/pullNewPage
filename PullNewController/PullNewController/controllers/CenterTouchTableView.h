//
//  CenterTouchTableView.h
//  PersonalCenter
//
//  Created by 中资北方 on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterTouchTableView : UITableView

@property (nonatomic, assign)BOOL shouldRecognize;
@property (nonatomic, copy)void(^panStart)(void);

@end
