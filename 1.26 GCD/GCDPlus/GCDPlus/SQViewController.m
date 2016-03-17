//
//  SQViewController.m
//  GCDPlus
//
//  Created by Xue on 16/1/26.
//  Copyright (c) 2016年 QQ:565007544. All rights reserved.
//

#import "SQViewController.h"

@interface SQViewController ()

@end

@implementation SQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //模拟线程间通信
#pragma mark - 信号量练习1
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建信号量 初始化计数值 值不能小于0 小于0该方法返回NULL
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    __block NSString *access_token = nil;
    dispatch_async(global_queue, ^{
        NSLog(@"操作1%@", [NSThread currentThread]);
       //操作1 登录 登录后会拿到access_token
        sleep(2);//模拟请求数据 消耗时间
        access_token = @"123";//拿到数据
        
        //发信号 信号量计数+1 如果+1前的值小于0 则直接唤醒被dispatch_semaphore_wait阻塞的线程继续执行
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_async(global_queue, ^{
        NSLog(@"操作2%@", [NSThread currentThread]);
        
        //等信号 信号量-1 如果结果小于0 阻塞当前线程
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        //断言 调试程序 如果条件不成立 程序崩溃 且输出后面的内容
        NSAssert(access_token.length != 0, @"access_token没拿到");
        
        //操作2 需要access_token请求数据
        NSLog(@"使用access_token请求数据，使用信号量线程间通信成功");
    });
    
    
#pragma mark - 信号量练习2 使用信号量控制并发数量
/*
    //创建信号量 并且初始值为10
    dispatch_semaphore_t sema1 =  dispatch_semaphore_create(10);
    for (int i=0; i<100; i++)
    {
        //当循环至第11次时 sema1的值小于0 后面不会再添加任务了
        //等信号 信号量计数-1 如果结果小于0 会阻塞当前线程
        dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
        
        dispatch_async(global_queue, ^{
            
            NSLog(@"练习2%@", [NSThread currentThread]);

            sleep(1);
            
            //每当有任务完成 信号量计数就+1
            //发信号 信号量计数+1 如果+1前的值小于0 则直接唤醒被dispatch_semaphore_wait阻塞的线程继续执行
            dispatch_semaphore_signal(sema1);
        });
    }
*/
    
#pragma mark - dispatch_once保证某段代码只执行一次
    // 通常用于在整个应用程序生命周期内只需要执行一次的代码
    // 单例类中
    
//    [self test];
//    [self test];
//    [self test];
//    [self test];
//    [self test];
    
    dispatch_async(global_queue, ^{
        [self test];
    });
    
    dispatch_async(global_queue, ^{
        [self test];
    });
}

- (void)test
{
    NSLog(@"once前%@", [NSThread currentThread]);
    //定义静态dispatch_once_t变量
    static dispatch_once_t onceToken;
    //参数1 保证参数2只执行一次的变量 参数2 在应用程序生命周期内只执行一次的代码块
    dispatch_once(&onceToken, ^{
        NSLog(@"11111111111");
    });
    NSLog(@"once后%@", [NSThread currentThread]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
