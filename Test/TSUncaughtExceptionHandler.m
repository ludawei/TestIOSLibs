//
//  TSUncaughtExceptionHandler.m
//  Test
//
//  Created by 卢大维 on 14-7-31.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSUncaughtExceptionHandler.h"
#include <execinfo.h>
#include <libkern/OSAtomic.h>

#if 1
NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@implementation TSUncaughtExceptionHandler

+ (NSArray *)backtrace
{
    void* callstack[1024];
    int frames = backtrace(callstack, 1024);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
#if 1
    for (i = 0; i < frames; i++)
#else
        for (
             i = UncaughtExceptionHandlerSkipAddressCount;
             i < UncaughtExceptionHandlerSkipAddressCount +
             UncaughtExceptionHandlerReportAddressCount;
             i++)
#endif
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    if (anIndex == 0)
    {
        dismissed = YES;
    }
    else if (anIndex==1) {
        NSLog(@"ssssssss");
    }
}

/**
 *  保存异常信息到文件
 *
 *  @param exception 异常信息
 */
- (void)validateAndSaveCriticalApplicationData:(NSException *)exception
{
    NSMutableString *exceptionDesc = [NSMutableString string];
    NSString *iosSystemName = [[UIDevice currentDevice] systemName],
    *iosSystemVer =  [[UIDevice currentDevice] systemVersion],
    *appVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
    *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
    *appBundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    [exceptionDesc appendFormat:@"/*********Device Info*************/\niosSystemInfo:%@ %@\n",iosSystemName,iosSystemVer];
    [exceptionDesc appendFormat:@"/*********APP Info*************/\nappName:%@,appVer:%@,appBundle:%@\n",appName,appVer,appBundle];
    [exceptionDesc appendFormat:@"/*********Exception Info*************/\nExceptionName:%@,ExceptionReason:%@\n/******Tarck Info*******/\n",[exception name],[exception reason]];
    //[exceptionDesc appendString:[[exception callStackSymbols] componentsJoinedByString:@"\n"]];
    [exceptionDesc appendString:[[[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey] componentsJoinedByString:@"\n"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *logFileNameString = [NSString stringWithFormat:@"%@%@",[dateFormatter stringFromDate:[NSDate date]],^{
        NSMutableString *  result;
        CFUUIDRef   uuid;
        CFStringRef uuidStr;
        uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        uuidStr = CFUUIDCreateString(NULL, uuid);
        assert(uuidStr != NULL);
        result = [NSMutableString stringWithString:[[NSString stringWithFormat:@"%@", uuidStr] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        assert(result != nil);
        CFRelease(uuidStr);
        CFRelease(uuid);
        return result;
    }()];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:logFileNameString];
    NSError *error = nil;
    int i = 0;
    do{
        [exceptionDesc writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        ++i;
    }while (error!=nil && i<5);
}

- (void)handleException:(NSException *)exception
{
    [self validateAndSaveCriticalApplicationData:exception];
    
//    UIAlertView *alert =
//    [[UIAlertView alloc]
//      initWithTitle:NSLocalizedString(@"抱歉，程序出现了异常", nil)
//      message:[NSString stringWithFormat:NSLocalizedString(
//                                                           @"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n\n"
//                                                           @"异常原因如下:\n%@\n%@", nil),
//               [exception reason],
//               [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
//      delegate:self
//      cancelButtonTitle:NSLocalizedString(@"退出", nil)
//      otherButtonTitles:NSLocalizedString(@"继续", nil), nil];
//    [alert show];
    
//    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
//    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
//    
//    while (!dismissed)
//    {
//        for (NSString *mode in (__bridge NSArray *)allModes)
//        {
//            CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
//        }
//    }
//    
//    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
} 

@end

void HandleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSArray *callStack = [TSUncaughtExceptionHandler backtrace];
    NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo
     setObject:callStack
     forKey:UncaughtExceptionHandlerAddressesKey];
    
    [[[TSUncaughtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:[exception name]
      reason:[exception reason]
      userInfo:userInfo]
     waitUntilDone:YES];
}

void SignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo =
    [NSMutableDictionary
     dictionaryWithObject:[NSNumber numberWithInt:signal]
     forKey:UncaughtExceptionHandlerSignalKey];
    
    NSArray *callStack = [TSUncaughtExceptionHandler backtrace];
    [userInfo
     setObject:callStack
     forKey:UncaughtExceptionHandlerAddressesKey];
    
    [[[TSUncaughtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
      reason:
      [NSString stringWithFormat:
       NSLocalizedString(@"Signal %d was raised.", nil),
       signal]
      userInfo:
      [NSDictionary
       dictionaryWithObject:[NSNumber numberWithInt:signal]
       forKey:UncaughtExceptionHandlerSignalKey]]
     waitUntilDone:YES];
}

void InstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}


#endif