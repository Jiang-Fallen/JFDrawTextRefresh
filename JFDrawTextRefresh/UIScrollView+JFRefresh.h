//
//  UIScrollView+JFRefresh.h
//  RefreshDemo
//
//  Created by Mr_J on 16/3/5.
//  Copyright © 2016年 Mr_J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFDrawTextView.h"

@interface UIScrollView (JFRefresh)

@property (nonatomic, weak) JFDrawTextView *drawTextView;

- (void)addHeaderWithAction:(void (^)())action;
- (void)addHeaderWithAction:(void (^)())action
              customControl:(void (^)(JFDrawTextView *drawView))opration;

- (void)endHeaderRefresh;

@end
