//
//  JFDrawTextView.h
//  JFDrawTextRefreshDemo
//
//  Created by Mr_J on 16/3/31.
//  Copyright © 2016年 Mr_Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JFRefreshBezierLabel;

typedef NS_ENUM(NSInteger, JFRefreshState){
    JFRefreshStateNormal = 0,
    JFRefreshStateRefreshing = 1,
    JFRefreshStateWillRefresh = 2
};

@interface JFDrawTextView : UIView

@property (nonatomic, copy) void (^action)();
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) JFRefreshState refreshState;
@property (nonatomic, strong, readonly) JFRefreshBezierLabel *bezierLabel;

@property (nonatomic, weak) NSString *refreshText;
@property (nonatomic, weak) UIColor *textColor;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
- (void)endHeaderRefresh;

@end
