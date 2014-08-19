//
//  CatchCrash.m
//  Test
//
//  Created by 卢大维 on 14-8-19.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "CatchCrash.h"

static NSString *logFileNameString = @"crachLog";

@implementation CatchCrash

void uncaughtExceptionHandler(NSException *exception)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *uuid = ^{
        NSString *  result;
        CFUUIDRef   uuid;
        CFStringRef uuidStr;
        uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        uuidStr = CFUUIDCreateString(NULL, uuid);
        assert(uuidStr != NULL);
        result = [NSString stringWithFormat:@"%@", uuidStr];
        assert(result != nil);
        CFRelease(uuidStr);
        CFRelease(uuid);
        return result;
    }();
    
    NSString *iosSystemName = [[UIDevice currentDevice] systemName],
    *iosSystemVer =  [[UIDevice currentDevice] systemVersion],
    *appVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
    *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
    *appBundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    
//    NSMutableString *exceptionDesc = [NSMutableString string];
//    [exceptionDesc appendFormat:@"/*********Crash Time*************/\ncrashTime      :  %@\n", [dateFormatter stringFromDate:[NSDate date]]];
//    [exceptionDesc appendFormat:@"/*********Device Info*************/\niosSystemInfo  :  %@ %@\nUUID           :  %@\n",iosSystemName,iosSystemVer,uuid];
//    [exceptionDesc appendFormat:@"/*********APP Info*************/\nappName        :  %@\nappVer         :  %@\nappBundle      :  %@\n",appName,appVer,appBundle];
//    [exceptionDesc appendFormat:@"/*********Exception Info*************/\nExceptionName  :  %@\nExceptionReason:  %@\n/******Tarck Info*******/\n",[exception name],[exception reason]];
//    [exceptionDesc appendString:[[exception callStackSymbols] componentsJoinedByString:@"\n"]];
    
    NSMutableDictionary *exceptionDict = [NSMutableDictionary dictionary];
    [exceptionDict setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"crashTime"];
    [exceptionDict setObject:[NSString stringWithFormat:@"%@ %@", iosSystemName,iosSystemVer] forKey:@"iosSystemInfo"];
    [exceptionDict setObject:uuid forKey:@"UUID"];
    [exceptionDict setObject:appVer forKey:@"appVer"];
    [exceptionDict setObject:appBundle forKey:@"appBundle"];
    [exceptionDict setObject:appName forKey:@"appName"];
    [exceptionDict setObject:[exception name] forKey:@"exceptionName"];
    [exceptionDict setObject:[exception reason] forKey:@"exceptionReason"];
    [exceptionDict setObject:[[exception callStackSymbols] componentsJoinedByString:@"\n"] forKey:@"exceptionTarcks"];
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:logFileNameString];
    BOOL status = NO;
    int i = 0;
    do{
        status = [exceptionDict writeToFile:filePath atomically:YES];
        ++i;
    }while (!status && i<5);
}

+(void)uploadCrashLog
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:logFileNameString];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        NSDictionary *exceptionDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSLog(@"%@", exceptionDict);
        
        // todo http upload ...
        
        // remove the file
        NSError *error = nil;
        int i = 0;
        do {
            [manager removeItemAtPath:filePath error:&error];
        } while (error != nil && i < 5);
    }
    
}

@end
