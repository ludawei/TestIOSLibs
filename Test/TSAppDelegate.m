//
//  TSAppDelegate.m
//  Test
//
//  Created by 卢大维 on 14-7-31.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSAppDelegate.h"
#import "TSUncaughtExceptionHandler.h"
#import "CatchCrash.h"
#import <Fingertips/MBFingerTipWindow.h>

@implementation TSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if 0
    InstallUncaughtExceptionHandler();
#else
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [CatchCrash uploadCrashLog];
#endif

    // Override point for customization after application launch.
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if(url)     {     }
    NSString *bundleId = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
    if(bundleId)     {     }
    UILocalNotification * localNotify = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(localNotify)     {     }
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo)     {     }
    
    CGFloat t = 6.6;
    CGFloat t1 = 6.4;
    CGFloat t2 = 6.51;
    NSLog(@"%.f, %.f, %.f", floorf(t), ceil(t), nearbyint(t));
    NSLog(@"%.f, %.f, %.f", floorf(t1), ceil(t1), nearbyint(t1));
    NSLog(@"%.f, %.f, %.f", floorf(t2), ceil(t2), nearbyint(t2));
    
    NSMutableSet *muSet = [NSMutableSet setWithCapacity:6];
    [muSet addObject:@"对象1"];
    [muSet addObject:@"对象1"];
    [muSet addObject:@"对象1"];[muSet addObject:@"对象1"];
    [muSet addObject:@"对象1"];
    NSSet *set = [NSSet setWithObjects:@"对象2",@"对象3", @"被企鹅咬了一口", nil];
    //添加set数据
    [muSet unionSet:set];
    for (NSObject *object in muSet) {
        NSLog(@"all nuSet:%@",object);
    }
    NSSet *set1 = [NSSet setWithObjects:@"对象2",@"对象3", nil];
    
    //在muSet中删除包含set1总数据
    [muSet minusSet:set1];
    for (NSObject *object in muSet) {
        NSLog(@"after minusSet:%@",object);
    }
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }

//    UIViewController *vc = self.window.rootViewController;
//    CGRect frame = [[UIScreen mainScreen] bounds];
//    self.window = [[MBFingerTipWindow alloc] initWithFrame:frame];
//    self.window.rootViewController = vc;
//    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LocalNotification" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    NSDictionary* dic = [[NSDictionary alloc]init];
    //这里可以接受到本地通知中心发送的消息
    dic = notification.userInfo;
    NSLog(@"user info = %@",[dic objectForKey:@"key"]);
}
@end
