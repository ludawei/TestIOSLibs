//
//  TSUncaughtExceptionHandler.h
//  Test
//
//  Created by 卢大维 on 14-7-31.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSUncaughtExceptionHandler : NSObject
{
    BOOL dismissed;
}
@end
void HandleException(NSException *exception);
void SignalHandler(int signal);


void InstallUncaughtExceptionHandler(void);