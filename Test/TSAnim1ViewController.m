//
//  TSAnim1ViewController.m
//  Test
//
//  Created by 卢大维 on 14-8-19.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSAnim1ViewController.h"
#import "TSCycleAnimView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TSAnim1ViewController ()

@end

@implementation TSAnim1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TSCycleAnimView *pie =[[TSCycleAnimView alloc] initWithDicts:@{cyRadio : @(40), cyColor : [UIColor redColor]},
                                                                @{cyRadio : @(60), cyColor : [UIColor grayColor]},
                                                                @{cyRadio : @(110), cyColor : UIColorFromRGB(0xEE4337)},
                                                                @{cyRadio : @(60), cyColor : UIColorFromRGB(0xEE713B)},
                                                                @{cyRadio : @(90), cyColor : [UIColor yellowColor]},
                                                                nil];
    pie.frame = CGRectMake(0,100,self.view.bounds.size.width, self.view.bounds.size.width);
    pie.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pie];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)clickErrorLog
{
    NSArray *arry=[NSArray arrayWithObject:@"sss"];
    NSLog(@"%@",[arry objectAtIndex:1]);
}

@end
