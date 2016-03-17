//
//  SQAppDelegate.h
//  GCD
//
//  Created by Xue on 16/1/26.
//  Copyright (c) 2016年 QQ:565007544. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SQAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#if OS_OBJECT_USE_OBJC  //iOS6才有的宏 或者__IPHONE_OS_VERSION_MIN_REQUIRED 当前应用程序支持的最低版本
@property (nonatomic, strong) dispatch_queue_t queue;
#else
@property (nonatomic, assign) dispatch_queue_t queue;
#endif

@end
