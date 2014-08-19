//
//  TSView.m
//  Test
//
//  Created by 卢大维 on 14-8-11.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSView.h"
#import "UIView+LoadFromNib.h"

@interface TSView ()

@property (nonatomic,weak) IBOutlet UIView *subTestView;
@property (nonatomic,weak) IBOutlet UIView *testView;

@end

@implementation TSView

+(id)loadFromXib
{
    return [self loadFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)awakeFromNib
{

}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    __block UIView *hitView = [super hitTest:point withEvent:event];

    [self.subviews enumerateObjectsUsingBlock:^(UIView *sub, NSUInteger idx, BOOL *stop) {

        CGPoint superPoint = [sub convertPoint:point fromView:self];
        BOOL flag = [sub pointInside:superPoint withEvent:event];
        if (CGRectContainsPoint(sub.bounds, superPoint)) {
            if ([sub isKindOfClass:[UIButton class]]) {
                if (flag) {
                    hitView = sub;
                    *stop = YES;
                }
            }
            
            if (sub == self.subTestView) {
                hitView = self.subTestView;
                *stop = YES;
            }
            
            if (sub == self.testView) {
                hitView = self.testView;
                *stop = YES;
            }
        }
        
    }];

    return hitView;
}

-(IBAction)clickSelf
{
    NSLog(@"click self");
}

-(IBAction)clickSubView
{
    NSLog(@"click subView");
}

-(IBAction)clickButton
{
    NSLog(@"click buton");
}
@end
