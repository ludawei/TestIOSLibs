//
//  TSCollectionViewLayout.m
//  Test
//
//  Created by 卢大维 on 14-8-7.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSCollectionViewLayout.h"
#import <UIKit/UIKit.h>

@interface TSCollectionViewLayout ()

@property (nonatomic,strong) UIDynamicAnimator *dynamicAnimator;

@end

@implementation TSCollectionViewLayout

-(id)init
{
    if (self = [super init]) {
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        self.itemSize = CGSizeMake(100, 100);
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    CGSize contentSize = self.collectionView.contentSize;
    NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
}
@end
