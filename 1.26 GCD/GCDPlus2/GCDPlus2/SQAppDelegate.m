//
//  SQAppDelegate.m
//  GCDPlus2
//
//  Created by Xue on 16/1/27.
//  Copyright (c) 2016年 QQ:565007544. All rights reserved.
//

#import "SQAppDelegate.h"

@implementation SQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //在并行队列中 获知队列中的所有任务都执行完毕

    //使用dispatch_group
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    

    //创建组
    dispatch_group_t group = dispatch_group_create();
    
    //向组以及监听的队列中添加任务
    dispatch_group_async(group, global_queue, ^{
        
        [NSThread sleepForTimeInterval:8];
        NSLog(@"任务1");
    });
    
    dispatch_group_async(group, global_queue, ^{
        
        [NSThread sleepForTimeInterval:3];
        NSLog(@"任务2");
    });
    
    //当队列中所有任务都执行完成时 group会发通知 block会调用
    dispatch_group_notify(group, global_queue, ^{
        NSLog(@"global_queue中的任务都执行完成了");
    });
/*
    //barrier
    //创建一个自定义并发队列
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.xsq.concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"操作1-------");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"操作1=======");
    });
    
    //异步提交一个障碍任务 当自定义并发队列执行此方法提交的任务时 不会执行队列中的其他任务
    dispatch_barrier_async(concurrent_queue, ^{
        NSLog(@"操作2-------");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"操作2=======");
    });
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"操作3-------");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"操作3=======");
    });
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"操作4-------");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"操作4=======");
    });

    
    //dispatch_apply相当于同步提交了n个任务
    
    dispatch_queue_t concurrent_queue2 = dispatch_queue_create("com.xsq.concurrent.queue2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(global_queue, ^{
       
//        for (int i=0; i<10; i++)
//        {
//            dispatch_sync(concurrent_queue2, ^{
//                
//            });
//        }
        
        
    });
    
    //同步提交了10个任务 任务在队列中是并发的 执行顺序是不确定的
    dispatch_apply(10, concurrent_queue2, ^(size_t idx) {
        NSLog(@"处理操作前%zu-----", idx);

        [NSThread sleepForTimeInterval:3];
        NSLog(@"处理操作后%zu=====", idx);
    });
    
    NSLog(@"dispatch_apply");
*/
    
    //dispatch_after
    
//    [self performSelector:<#(SEL)#> withObject:<#(id)#> afterDelay:<#(NSTimeInterval)#>]
    
    //构建一个dispatch_time 1.时间 2.时间增量 纳秒 NSEC_PER_SEC一秒等于多少纳秒
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC));
    
    //dispatch_after延迟执行 1.延迟多长时间 dispatch_time 2.延迟在哪个队列执行 3.延迟执行的代码
    dispatch_after(time, dispatch_get_main_queue(), ^{
        NSLog(@"这个是dispatch_after延迟执行");
    });
    
    /*
     并发VS并行
     并发指的是同时执行了多个任务，在多个任务间切换，一般是指同一时间间隔同时执行了多个任务（一般指单核）
     并行指的是同时执行多个任务，一般是指同一时刻同时执行了多少任务（一般指多核）
     
     并行:(多核)
     cpu1：任务part1
     thread:_____________________
     
     
     cpu2: 任务part2
     thread:_____________________
     
     并发:(单核)
     cpu：
     thread1：_  _  _  _  _  _			任务part1
     thread2：  _  _  _  _  _    		任务part2
     
     并行要求并发，并发并不能保证并行（单核）

     */
    
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

@end
