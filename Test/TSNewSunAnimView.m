//
//  TSNewSunAnimView.m
//  Test
//
//  Created by 卢大维 on 15/3/19.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "TSNewSunAnimView.h"

#define POINT_WIDTH 4.0f

@interface TSNewSunAnimView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *sunImageView;
@property (nonatomic ,strong) UIView *fillView;
@property (nonatomic) CGFloat radius;

@end

@implementation TSNewSunAnimView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat tempAngle1 = atan2(frame.size.width/2, frame.size.height);
        CGFloat temp = sqrt(frame.size.height*frame.size.height + (frame.size.width/2)*(frame.size.width/2))/2;
        CGFloat radius = temp/cos(tempAngle1);
        self.radius = radius;
        
        CGFloat tempAngel2 = atan2(frame.size.width/2, radius - frame.size.height);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, NULL, frame.size.width/2, radius, radius, M_PI*3/2-tempAngel2, M_PI*3/2+tempAngel2, NO);
        
        CAShapeLayer *lay = [CAShapeLayer layer];
        lay.lineWidth = 1.0;
        lay.strokeColor = [UIColor grayColor].CGColor;
        lay.fillColor = [UIColor clearColor].CGColor;
        lay.lineDashPattern = @[@3, @3];
        lay.path = path;
        [self.layer addSublayer:lay];
        
        
        CGMutablePathRef path1 = CGPathCreateMutable();
        CGPathAddArc(path1, NULL, frame.size.width/2, radius, radius-0.5, M_PI*3/2-tempAngel2, M_PI*3/2+tempAngel2, NO);
        
        CAShapeLayer *lay1 = [CAShapeLayer layer];
        lay1.path = path1;
        
        UIView *fillView = [[UIView alloc] initWithFrame:CGRectZero];
        fillView.layer.mask = lay1;
        fillView.backgroundColor = [UIColor grayColor];
        [self addSubview:fillView];
        self.fillView = fillView;
        
        self.sunImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maximum_temperature"]];
        self.sunImageView.center = CGPointMake(0, frame.size.height);
        [self addSubview:self.sunImageView];
        
        [self initLabels];
    }
    
    return self;
}

-(void)initLabels
{
    UILabel *pointLbl1 = [self createPointLableWithFrame:CGRectMake(-POINT_WIDTH/2, self.bounds.size.height-POINT_WIDTH/2, POINT_WIDTH, POINT_WIDTH)];
    [self addSubview:pointLbl1];
    
    UILabel *pointLbl2 = [self createPointLableWithFrame:CGRectMake(self.bounds.size.width-POINT_WIDTH/2, self.bounds.size.height-POINT_WIDTH/2, POINT_WIDTH, POINT_WIDTH)];
    [self addSubview:pointLbl2];
    
    UILabel *leftLbl = [self createTextLableWithFrame:CGRectMake(-30, self.bounds.size.height+5, 60, 18)];
    leftLbl.text = @"text1";
    [self addSubview:leftLbl];
    
    UILabel *rightLbl = [self createTextLableWithFrame:CGRectMake(self.bounds.size.width-30, self.bounds.size.height+5, 60, 18)];
    rightLbl.text = @"text2";
    [self addSubview:rightLbl];
}

-(UILabel *)createPointLableWithFrame:(CGRect)frame
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    lbl.backgroundColor = [UIColor colorWithRed:1.0000 green:0.8431 blue:0.2392 alpha:1.0000];
    lbl.layer.cornerRadius = frame.size.width/2;
    lbl.clipsToBounds = YES;

    return lbl;
}

-(UILabel *)createTextLableWithFrame:(CGRect)frame
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    lbl.font = [UIFont fontWithName:@"Helvetica" size:12];
    lbl.textColor = [UIColor whiteColor];;
    lbl.textAlignment = NSTextAlignmentCenter;
    
    return lbl;
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.010 target:self selector:@selector(sunAnimation) userInfo:nil repeats:YES];
}

-(void)sunAnimation
{
    CGFloat currentX = self.sunImageView.center.x + 1;
    if (currentX > self.bounds.size.width) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    int currentY = [self yPointWithxPoint:currentX];
    self.sunImageView.center = CGPointMake(currentX, currentY);
    
    self.fillView.frame = CGRectMake(0, 0, currentX, self.bounds.size.height);
}

-(CGFloat)yPointWithxPoint:(CGFloat)xpoint
{
    CGFloat xWidth = fabs(self.radius - xpoint);
    int height = roundf(sqrt((self.radius*self.radius) - (xWidth*xWidth)));
    return self.radius -  height;
}

@end
