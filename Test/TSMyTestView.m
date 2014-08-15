//
//  TSMyTestView.m
//  Test
//
//  Created by 卢大维 on 14-8-13.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSMyTestView.h"

@interface TSMyTestView ()

@property (nonatomic) IBInspectable CGFloat lineWidth;
@property (nonatomic) IBInspectable UIColor *fillColor;
@property (nonatomic) IBInspectable CGFloat cor;

@end

@implementation TSMyTestView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setLineWidth:(CGFloat)lineWidth
{
    self.layer.borderWidth = lineWidth;
}

-(void)setFillColor:(UIColor *)fillColor
{
    self.layer.borderColor = fillColor.CGColor;
}

-(void)setCor:(CGFloat)cor
{
    self.layer.cornerRadius = cor;
}
@end
