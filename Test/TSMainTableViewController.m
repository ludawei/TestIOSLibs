//
//  TSMainTableViewController.m
//  Test
//
//  Created by 卢大维 on 15/3/16.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "TSMainTableViewController.h"
#import "TSOthersViewController.h"

@interface TSMainTableViewController ()

@end

@implementation TSMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickRightButton
{
#if 0
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:10]; //触发通知的时间
        notification.repeatInterval=0; //循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody=@"\u2600 \u2601该去吃晚饭了！";
        
        notification.alertAction = @"打开";  //提示框按钮
        notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
        
//        notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
        
        //下面设置本地通知发送的消息，这个消息可以接受
        NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
        notification.userInfo = infoDic;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
#else
    TSOthersViewController *next = [TSOthersViewController new];
    [self.navigationController pushViewController:next animated:YES];
#endif
}

@end
