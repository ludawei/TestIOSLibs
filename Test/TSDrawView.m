//
//  TSDrawView.m
//  Test
//
//  Created by 卢大维 on 14-8-15.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSDrawView.h"

@interface TSDrawView ()

@property (nonatomic) CGPoint fromPoint,toPoint;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation TSDrawView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    // 画线
    CGContextSetLineWidth(context, 1);
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.5);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.toPoint.x, self.toPoint.y);
    CGContextStrokePath(context);
    
    CGFloat width = MIN(self.bounds.size.width, self.bounds.size.height);
    CGFloat height = width;
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius = (width + height) * 0.25;
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    // 移动到初始点
    CGContextMoveToPoint(context, self.bounds.size.width/2, 0);
    // 绘制第1条线和第1个1/4圆弧，右上圆弧
    CGContextAddLineToPoint(context, width - radius,0);
    CGContextAddArc(context, width - radius, radius, radius, -0.5 *M_PI,0.0, 0);
    // 绘制第2条线和第2个1/4圆弧，右下圆弧
    CGContextAddLineToPoint(context, width, height - radius);
    CGContextAddArc(context, width - radius, height - radius, radius,0.0,0.5 * M_PI,0);
    // 绘制第3条线和第3个1/4圆弧，左下圆弧
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height - radius, radius,0.5 *M_PI, M_PI,0);
    // 绘制第4条线和第4个1/4圆弧，左上圆弧
    CGContextAddLineToPoint(context, 0, radius);
    CGContextAddArc(context, radius, radius, radius,M_PI,1.5 * M_PI,0);
    // 闭合路径
    CGContextClosePath(context);
    // 填充半透明红色
    CGContextSetRGBFillColor(context,1.0,0.0,0.0,0.5);
    CGContextDrawPath(context,kCGPathFill);
    
    
    UIGraphicsPopContext();

}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.toPoint = CGPointZero;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startAnim) userInfo:nil repeats:YES];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self intiUIOfView];
}

-(void)startAnim
{
    if (self.toPoint.x < self.bounds.size.width) {
        self.toPoint = CGPointMake(self.toPoint.x + 1, self.toPoint.y + self.bounds.size.height/self.bounds.size.width);
        [self setNeedsDisplay];
    }
    else
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self intiUIOfView];
}

-(void)intiUIOfView
{
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGSize size = CGSizeMake(self.frame.size.height, self.frame.size.height);
    
//    [path moveToPoint:CGPointMake(60, 0)];
#if 0
    [path addArcWithCenter:CGPointMake(60, 60) radius:60 startAngle:0 endAngle:2*M_PI clockwise:NO];
#else
    [path addArcWithCenter:CGPointMake(size.width/2, size.width/2) radius:size.height/2 startAngle:M_PI*2 endAngle:0 clockwise:NO];
#endif
    [path closePath];
    CAShapeLayer *arcLayer=[CAShapeLayer layer];
    arcLayer.needsDisplayOnBoundsChange = YES;
    arcLayer.path=path.CGPath;//46,169,230
    arcLayer.fillColor=[UIColor blueColor].CGColor;
    arcLayer.strokeColor=[UIColor colorWithWhite:1 alpha:0.7].CGColor;
    arcLayer.lineWidth = size.height;
    arcLayer.strokeEnd = 0.5f;
    arcLayer.cornerRadius = size.height/2;
    arcLayer.masksToBounds = YES;
    arcLayer.frame=CGRectMake(size.width + 40, 0, size.width, size.height);
    [self.layer addSublayer:arcLayer];
    
    [self drawLineAnimation:arcLayer];
    
    UIBezierPath *path1=[UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(self.bounds.size.width, 0)];
    [path1 addLineToPoint:CGPointMake(0, size.height)];
    [path1 closePath];
    CAShapeLayer *lineLayer=[CAShapeLayer layer];
    lineLayer.path=path1.CGPath;//46,169,230
    lineLayer.fillColor=[UIColor clearColor].CGColor;
    lineLayer.strokeColor=[UIColor orangeColor].CGColor;
    lineLayer.lineWidth = 10;
    lineLayer.masksToBounds = YES;
    lineLayer.frame=CGRectMake(0, 0, self.bounds.size.width, size.height);
    [self.layer addSublayer:lineLayer];
    
    [self drawLineAnimation:lineLayer];
}

//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer
{
//    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    bas.duration=2;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithFloat:0.5];
    [layer addAnimation:bas forKey:@"key"];
}
@end
