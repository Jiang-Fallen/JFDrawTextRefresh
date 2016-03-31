//
//  JFRefreshBezierLabel.h
//  Wefafa
//
//  Created by Mr_J on 16/3/15.
//  Copyright © 2016年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFRefreshBezierLabel : UIView

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, assign, readonly) CGSize textSize;
@property (nonatomic, assign) CGFloat offset;// 0-1
@property (nonatomic, assign) BOOL showAnimation;

@end
