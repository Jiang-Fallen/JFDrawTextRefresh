//
//  UIScrollView+JFRefresh.m
//  RefreshDemo
//
//  Created by Mr_Jiang on 16/3/20.
//  Copyright © 2016年 Mr_J. All rights reserved.
//

#import "UIScrollView+JFRefresh.h"
#import <objc/runtime.h>

NSString * const _drawTextView = @"frawTextView";
@implementation UIScrollView (JFRefresh)
@dynamic drawTextView;

- (void)addHeaderWithAction:(void (^)())action{
    JFDrawTextView *drawTextView = [[JFDrawTextView alloc]initWithScrollView:self];
    drawTextView.action = action;
    self.drawTextView = drawTextView;
}

- (void)addHeaderWithAction:(void (^)())action customControl:(void (^)(JFDrawTextView *))opration{
    [self addHeaderWithAction:action];
    opration(self.drawTextView);
}

- (JFDrawTextView *)drawTextView{
    return (JFDrawTextView *)objc_getAssociatedObject(self, &_drawTextView);
}

- (void)setDrawTextView:(JFDrawTextView *)drawTextView{
    objc_setAssociatedObject(self, &_drawTextView, drawTextView, OBJC_ASSOCIATION_ASSIGN);
}

- (void)endHeaderRefresh{
    [self.drawTextView endHeaderRefresh];
}

@end
