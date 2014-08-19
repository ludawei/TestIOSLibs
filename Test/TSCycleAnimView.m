//
//  TSCycleAnimView.m
//  Test
//
//  Created by 卢大维 on 14-8-19.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSCycleAnimView.h"

@interface TSCycleAnimView ()

@property (nonatomic,strong) NSMutableArray *dicts;

@property (nonatomic) int currentIndex;
@property (nonatomic) CGFloat start,end;

@end

@implementation TSCycleAnimView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithDicts:(NSDictionary *)dict,...
{
    if (self = [super init]) {
        self.dicts = [NSMutableArray array];
        
        va_list args;
        va_start(args, dict);
        if (dict) {
            
            [self.dicts addObject:dict];
            NSDictionary *other;
            while ((other = va_arg(args, NSDictionary*))) {
                
                [self.dicts addObject:other];
            }
        }
        va_end(args);
    }
    
    return self;
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self checkRadios];
    [self startAnim];
}

-(void)checkRadios
{
    __block CGFloat total = 0;
    [self.dicts enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        total += [[dict objectForKey:cyRadio] floatValue];
    }];
    
    NSAssert(total/360.0 == 1, @"total is not 1.0!");
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self startAnim];
}

-(void)startAnim
{
    self.currentIndex = 0;
    [self startAnimWithIndex:self.currentIndex];
}

-(void)startAnimWithIndex:(int)index
{
    if (index < 0 || index >= self.dicts.count) {
        return;
    }
    
    CGFloat radio = self.frame.size.width/2 - 10;
    
    self.start = self.end;
    self.end += [[self.dicts[index] objectForKey:cyRadio] floatValue]/360;
    UIColor *color = [self.dicts[index] objectForKey:cyColor];
    
    //    NSLog(@"start : %f, end : %f", self.start, self.end);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(radio,radio) radius:radio startAngle:M_PI*2 endAngle:0 clockwise:NO];
    [path closePath];
    
    CAShapeLayer *arcLayer = [CAShapeLayer layer];
    arcLayer.path = path.CGPath;
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor = color.CGColor;
    arcLayer.lineWidth = (radio)*2;
    arcLayer.cornerRadius = radio;
    arcLayer.strokeStart = self.start;
    arcLayer.strokeEnd = self.end;
    arcLayer.masksToBounds = YES;
    arcLayer.frame = CGRectMake(10, 10, radio*2, radio*2);
    [self.layer addSublayer:arcLayer];
    
    [self drawLineAnimation:arcLayer start:self.start end:self.end];
}

//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer start:(CGFloat)start end:(CGFloat)end
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    bas.duration = (end-start)*3;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithFloat:start];
    bas.toValue=[NSNumber numberWithFloat:end];
    
    if (start == 0) {
        bas.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    }
    else if (end == 1)
    {
        bas.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    [layer addAnimation:bas forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        self.currentIndex++;
        
        [self startAnimWithIndex:self.currentIndex];
    }
}

@end
