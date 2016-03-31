//
//  JFRefreshBezierLabel.m
//  Wefafa
//
//  Created by Mr_Jiang on 16/3/15.
//  Copyright © 2016年 metersbonwe. All rights reserved.
//

#import "JFRefreshBezierLabel.h"
#import <CoreText/CoreText.h>

@interface JFRefreshBezierLabel ()

@property (nonatomic, strong) CABasicAnimation *gradientAnimation;

@end

@implementation JFRefreshBezierLabel
@synthesize textColor = _textColor;

- (void)setText:(NSString *)text{
    _text = text;
    [self settingLayerForText:text];
}

- (void)setOffset:(CGFloat)offset{
    _offset = offset;
    if (offset < 1) self.showAnimation = NO;
    self.shapeLayer.strokeEnd = offset;
}

- (UIColor *)textColor{
    if (!_textColor) {
        _textColor = [UIColor orangeColor];
    }
    return _textColor;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self updateGradientLayerColors];
}

- (UIFont *)textFont{
    if (!_textFont){
        _textFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:17];
    }
    return _textFont;
}

- (void)updateGradientLayerColors{
    self.gradientLayer.backgroundColor = self.textColor.CGColor;
    self.gradientLayer.colors = @[(__bridge id)[self.textColor colorWithAlphaComponent:0.3].CGColor,
                              (__bridge id)[self.textColor colorWithAlphaComponent:1].CGColor,
                              (__bridge id)[self.textColor colorWithAlphaComponent:0.3].CGColor];
}

-(CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil)
    {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = CGRectMake(0, 0, self.textSize.width, self.textSize.height);
        _shapeLayer.geometryFlipped = YES;
        _shapeLayer.strokeColor = self.textColor.CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 0.5f;
        _shapeLayer.lineJoin = kCALineJoinRound;
        _shapeLayer.strokeEnd = 0;
    }
    return _shapeLayer;
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.textSize.width + 5, self.textSize.height + 5);
        _gradientLayer.position = CGPointMake(self.frame.size.width/ 2, self.frame.size.height/ 2 + 10);
        _gradientLayer.startPoint = CGPointMake(0, 0.6);
        _gradientLayer.endPoint = CGPointMake(1, 0.4);
        _gradientLayer.locations = @[@0, @0, @1, @1];
        [self updateGradientLayerColors];
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}

- (CGSize)textSize{
    CGSize size = [_text sizeWithAttributes:@{NSFontAttributeName: self.textFont}];
    size.width += _text.length * 2;
    return size;
}

- (CAAnimation *)gradientAnimation{
    if (!_gradientAnimation) {
        NSArray *fromArray = @[@-0.1, @0.0, @0.3, @0.4];
        NSArray *toArray = @[@1, @01.1, @1.4, @1.5];
        self.gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        _gradientAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
        [_gradientAnimation setFromValue:fromArray];
        [_gradientAnimation setToValue:toArray];
        [_gradientAnimation setDuration:0.8];
        [_gradientAnimation setRemovedOnCompletion:YES];
        [_gradientAnimation setFillMode:kCAFillModeForwards];
        [_gradientAnimation setRepeatCount:MAXFLOAT];
        [_gradientLayer addAnimation:_gradientAnimation forKey:@"animateGradient"];
    }
    return _gradientAnimation;
}

- (void)setShowAnimation:(BOOL)showAnimation{
    if (_showAnimation == showAnimation) return;
    _showAnimation = showAnimation;
    if (showAnimation) {
        self.shapeLayer.strokeEnd = 1;
        _gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
    }else{
        _gradientLayer.backgroundColor = self.textColor.CGColor;
    }
    self.gradientAnimation.speed = showAnimation? 1: 0;
}

- (void)settingLayerForText:(NSString *)text{
    NSAttributedString *attrStrs = [[NSAttributedString alloc] initWithString:text
                                                                   attributes:@{NSFontAttributeName: self.textFont}];
    CGMutablePathRef paths = CGPathCreateMutable();
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrStrs);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            {
                CGPathRef path = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x + 2 * runGlyphIndex, position.y);
                CGPathAddPath(paths, &t,path);
                CGPathRelease(path);
            }
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:paths]];
    
//    [path applyTransform:CGAffineTransformMakeTranslation(0.0, self.height)];
    
    CGPathRelease(paths);
    
    self.shapeLayer.path = path.CGPath;
    self.gradientLayer.mask = self.shapeLayer;
}

@end
