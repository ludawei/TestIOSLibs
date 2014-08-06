//
//  TSViewController.m
//  Test
//
//  Created by 卢大维 on 14-7-31.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSViewController.h"
#import "BFPaperCheckbox.h"
#import "UIColor+BFPaperColors.h"

@interface TSViewController ()<BFPaperCheckboxDelegate>

@end

@implementation TSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"buton" forState:UIControlStateNormal];
    button.center = self.view.center;
    [button addTarget:self action:@selector(onclcko) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
//    NSArray *arry=[NSArray arrayWithObject:@"sss"];
//    NSLog(@"%@",[arry objectAtIndex:1]);
    BFPaperCheckbox *paperCheckbox2 = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(100, 100, 25 * 2, 25 * 2)];
    paperCheckbox2.delegate = self;
    paperCheckbox2.rippleFromTapLocation = NO;
    paperCheckbox2.tapCirclePositiveColor = [UIColor clearColor]; // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
    paperCheckbox2.tapCircleNegativeColor = [UIColor clearColor];   // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
    paperCheckbox2.checkmarkColor = [UIColor paperColorLightBlue];
    [self.view addSubview:paperCheckbox2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onclcko {
    //  [alert show];
    NSArray *arry=[NSArray arrayWithObject:@"sss"];
    NSLog(@"%@",[arry objectAtIndex:1]);
}

#pragma mark - BFPaperCheckbox Delegate
//- (void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox
//{
//    
//}

@end
