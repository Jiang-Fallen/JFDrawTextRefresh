//
//  JFDrawTextView.m
//  JFDrawTextRefreshDemo
//
//  Created by Mr_J on 16/3/31.
//  Copyright © 2016年 Mr_Jiang. All rights reserved.
//

#import "JFDrawTextView.h"
#import "JFRefreshBezierLabel.h"

@interface JFDrawTextView ()
{
    CGFloat _start_Y;
}

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

@implementation JFDrawTextView
@synthesize bezierLabel = _bezierLabel;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
{
    self = [super init];
    if (self) {
        _start_Y = 30;
        [scrollView addSubview:self];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    self.frame = CGRectMake(0, -64, self.scrollView.frame.size.width, 64);
}

- (void)updateLabelForOffset{
    CGFloat offset = self.scrollView.contentOffset.y + self.edgeInsets.top;
    if (offset < -64) {
        if (self.refreshState != JFRefreshStateRefreshing && !self.scrollView.isDragging) {
            self.refreshState = JFRefreshStateWillRefresh;
        }
        self.bezierLabel.offset = 1;
        return;
    }else if(offset > 0){
        self.bezierLabel.offset = 0;
        return;
    }
    if (self.refreshState == JFRefreshStateNormal){
        self.bezierLabel.offset = MAX((-offset - _start_Y)/ (64.0 - _start_Y), 0);
    }
}

- (void)oprationForWillRefresh{
    self.action();
    self.refreshState = JFRefreshStateRefreshing;
    UIEdgeInsets edgeInsets = _edgeInsets;
    edgeInsets.top += 64;
    self.scrollView.contentInset = edgeInsets;
}

- (void)endHeaderRefresh{
    self.refreshState = JFRefreshStateNormal;
}

#pragma mark - set get

- (void)setRefreshState:(JFRefreshState)refreshState{
    if (_refreshState == refreshState) return;
    _refreshState = refreshState;
    switch (refreshState) {
        case JFRefreshStateNormal:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -_edgeInsets.top);
            } completion:^(BOOL finished) {
                self.scrollView.contentInset = _edgeInsets;
            }];
            self.bezierLabel.showAnimation = NO;
        }
            break;
        case JFRefreshStateRefreshing:
            self.bezierLabel.showAnimation = YES;
            break;
        case JFRefreshStateWillRefresh:
            [self oprationForWillRefresh];
            break;
        default:
            break;
    }
}

- (JFRefreshBezierLabel *)bezierLabel{
    if (!_bezierLabel) {
        _bezierLabel = [[JFRefreshBezierLabel alloc]initWithFrame:self.bounds];
        _bezierLabel.text = @"Jiang-Fallen";
        [self addSubview:_bezierLabel];
    }
    return _bezierLabel;
}

- (void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    _edgeInsets = scrollView.contentInset;
}

- (void)setRefreshText:(NSString *)refreshText{
    self.bezierLabel.text = refreshText;
}

- (void)setTextColor:(UIColor *)textColor{
    self.bezierLabel.textColor = textColor;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    
    if (!newSuperview) return;
    [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.scrollView = (UIScrollView *)newSuperview;
}

#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self updateLabelForOffset];
    }
}

@end
