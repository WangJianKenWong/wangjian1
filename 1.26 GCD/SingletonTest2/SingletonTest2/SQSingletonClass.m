//
//  SQSingletonClass.m
//  SingletonTest2
//
//  Created by Xue on 16/1/26.
//  Copyright (c) 2016年 QQ:565007544. All rights reserved.
//

#import "SQSingletonClass.h"

@implementation SQSingletonClass

static SQSingletonClass *staicInstance = nil;
+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staicInstance = [[super allocWithZone:NULL] init];
    });
    return staicInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance];
}

@end







