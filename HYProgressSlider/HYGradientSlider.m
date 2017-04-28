//
//  HYGradientSlider.m
//  ChartDemo
//
//  Created by 胡杨 on 2017/2/10.
//  Copyright © 2017年 net.fitcome.www. All rights reserved.
//

#import "HYGradientSlider.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)


@interface HYGradientSlider ()

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat sideLength;

@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, strong) CAShapeLayer *colorLayer;
@property (nonatomic, strong) CAShapeLayer *gradientMaskLayer;
@end

@implementation HYGradientSlider

- (CGFloat)sideLength {
    return self.frame.size.height;
}

- (CGPoint)centerPoint {
    CGFloat wh = self.sideLength;
    return CGPointMake(wh * 0.5, wh * 0.5);
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        self.minimumValue = 0;
        self.maximumValue = 1.0;
        self.lineWidth = 12;
        self.radius = self.sideLength / 2.0 - self.lineWidth;
        
        
        [self setupGradientLayer];
        
        [self setupGradientMaskLayer];
        
        CAShapeLayer *bgMaskLayer = [self generateMaskLayer];
        self.layer.mask = bgMaskLayer;
    }
    return self;
}
/**
 *  设置渐变色，渐变色由左右两个部分组成
 */
- (void)setupGradientLayer {
    CAShapeLayer *colorLayer = [CAShapeLayer layer];
    self.colorLayer = colorLayer;
    colorLayer.frame = self.bounds;
    [self.layer addSublayer:colorLayer];
    
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.sideLength / 2.0, self.sideLength);
    leftLayer.colors = @[(id)[UIColor redColor].CGColor,
                         (id)[UIColor greenColor].CGColor,
                         (id)[UIColor blueColor].CGColor];
    [colorLayer addSublayer:leftLayer];
    
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.sideLength / 2.0, 0, self.sideLength / 2.0, self.sideLength);
    rightLayer.colors = @[(id)[UIColor redColor].CGColor,
                          (id)[UIColor greenColor].CGColor,
                          (id)[UIColor blueColor].CGColor];
    /* 设置颜色分割线， 
     0.6表示colors中第一个颜色redcolor是从0.6*height处开始的，0.7是greencolor渲染的起始位置0.7*height
     默认情况下是从上往下渲染，startPoint，endPoint可改变渲染的起始位置
     */
//    rightLayer.locations = @[@0.6, @0.7, @0.8];
    
    /* 设置起始点
       点的位置在（0，1）之间
     */
//    rightLayer.startPoint = CGPointMake(0, 0.8);
//    rightLayer.endPoint = CGPointMake(0, 1);
    
    [colorLayer addSublayer:rightLayer];
    
}

/**
 *  设置渐变色的遮罩
 */
- (void)setupGradientMaskLayer {
    CAShapeLayer *gradientMaskLayer = [self generateMaskLayer];
    gradientMaskLayer.lineWidth = self.lineWidth;
    self.colorLayer.mask = gradientMaskLayer;
    self.gradientMaskLayer = gradientMaskLayer;
    
}

- (void)setCurrentValue:(CGFloat)currentValue {
    _currentValue = currentValue;
    CGFloat persentage = currentValue / (self.maximumValue - self.minimumValue);
    self.gradientMaskLayer.strokeEnd = persentage;
    
    if ([self.delegate respondsToSelector:@selector(progressSliderDidValueChanged:)]) {
        [self.delegate progressSliderDidValueChanged:currentValue];
    }
}


/**
 生成一个圆环形遮罩层

 @return 环形遮罩层
 */
- (CAShapeLayer *)generateMaskLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:self.radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    layer.lineWidth = self.lineWidth;
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.lineCap = kCALineCapRound;
    return layer;
}

#pragma mark --- UIControl

/**
 跟踪触摸事件
 */

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
//    NSLog(@" %s  %@ %@", __FUNCTION__, touch, event);
    CGPoint lastPoint = [touch locationInView:self];
    
    CGPoint previousPoint = [touch previousLocationInView:self];
    CGFloat angle = angleFromPoint(lastPoint, self.centerPoint);
    
//    CGPoint precisePoint = [touch preciseLocationInView:self];
//    CGFloat angle2 = angleFromPoint(precisePoint, self.centerPoint);
    CGFloat angle3 = angleFromPoint(previousPoint, self.centerPoint);
    
    
    // 这里这么写是因为当progress 从1->0时，为了不让slider出现从1到0的逆时针动画，所以移除layer再重新添加
    if (angle3 > 6 && angle < 1) {
        [self.gradientMaskLayer removeFromSuperlayer];
        [self setupGradientMaskLayer];
    }
    
    [self setCurrentValue:angle / (M_PI * 2) * (self.maximumValue - self.minimumValue)];
    return YES;
}



static inline CGFloat angleFromPoint(CGPoint point, CGPoint centerPoint) {
    CGFloat a = point.x - centerPoint.x;
    CGFloat b = point.y - centerPoint.y;
    CGFloat c = sqrt(a * a + b * b);
    
    CGFloat angle = 0;
    if (a >= 0) {
        if (b < 0) {
            angle = M_PI_2 - acos(a / c);
        } else {
            angle = M_PI_2 + acos(a / c);
        }
    } else {
        if (b > 0) {
            angle = M_PI_2 + acos(a / c);
        } else {
            angle = M_PI_2 * 3 + asin(-b / c);
        }
    }
    
    return angle;
}


@end
