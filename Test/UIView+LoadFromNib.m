//
//  UIView+LoadFromNib.m
//  Ituji
//
//  Created by dawei on 8/16/12.
//
//

#import "UIView+LoadFromNib.h"

@implementation UIView (LoadFromNib)

+ (id)loadFromNib
{
    id view = nil;
    NSString *xibName = NSStringFromClass([self class]);
    UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:xibName bundle:nil];
    if(temporaryController)
    {
        view = temporaryController.view;
    }
    return view;
}

@end
