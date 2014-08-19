//
//  CatchCrash.h
//  Test
//
//  Created by 卢大维 on 14-8-19.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  catchCrash时，用这个收集异常比较好，暂不能Signal引起的异常
 */
@interface CatchCrash : NSObject

void uncaughtExceptionHandler(NSException *exception);
+(void)uploadCrashLog;

@end
