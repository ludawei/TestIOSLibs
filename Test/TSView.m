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

@end
