//
//  TSCycleAnimView.h
//  Test
//
//  Created by 卢大维 on 14-8-19.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cyRadio = @"radio";
static NSString *cyColor = @"color";

@interface TSCycleAnimView : UIView

/**
 *  cyRadio的总和请保证为360～～
 *
 *  @param dict @{cyRadio : @(40), cyColor : [UIColor redColor]}, nil
 *
 *  @return a alloced TSCycleAnimView object.
 */
-(instancetype)initWithDicts:(NSDictionary *)dict,...;

@end
