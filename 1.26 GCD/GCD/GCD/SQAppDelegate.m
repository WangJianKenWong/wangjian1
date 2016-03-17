//
//  SQAppDelegate.m
//  GCD
//
//  Created by Xue on 16/1/26.
//  Copyright (c) 2016年 QQ:565007544. All rights reserved.
//

#import "SQAppDelegate.h"

@implementation SQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //串行队列和并发队列
    
    //创建一个串行队列 1.唯一标识符 格式为com.xsq.queue_name 2.队列属性 串行or并发  传NULL表示串行
    dispatch_queue_t first_serial_queue =  dispatch_queue_create("com.xsq.firstSerialQueue", DISPATCH_QUEUE_SERIAL);
    
    //创建一个并发队列 DISPATCH_QUEUE_CONCURRENT和DISPATCH_QUEUE_SERIAL
    dispatch_queue_t first_concurrent_queue =  dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    
    //Apple给我们提供了两个不需要创建可以直接获取的队列 一个串行一个并发
    //主队列：main_queue 串行
    //全局队列：global_queue 并发
    
    
    //获取主队列 因为是在主线程中执行的 所以该队列为串行队列 该队列可以用来在分线程中刷新UI
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    //获取全局队列 1.优先级 2.系统保留将来可能要用 传0 不为0则此方法返回NULL
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"%@", global_queue);
    
    
#pragma mark - 同步提交和异步提交
    
    //同步提交 会等到任务结束继续向下执行
    //同步提交任务到自定义串行队列
    dispatch_async(first_serial_queue, ^{
        //此处执行任务
        NSLog(@"%@______%@", [NSThread currentThread], [NSThread isMainThread]?@"主线程":@"分线程");
    });
    
    NSLog(@"同步提交1");
    //同步提交任务到自定义串行队列 任务在主线程中执行
    
    //同步提交任务到自定义并发队列
    dispatch_async(first_concurrent_queue, ^{
        //此处执行任务
        NSLog(@"%@______%@", [NSThread currentThread], [NSThread isMainThread]?@"主线程":@"分线程");
    });
    NSLog(@"同步提交2");
    // 同步提交任务到自定义并发队列 任务是在主线程中执行的
    
    //同步提交到全局队列
    dispatch_async(global_queue, ^{
        //此处执行任务
        NSLog(@"%@______%@", [NSThread currentThread], [NSThread isMainThread]?@"主线程":@"分线程");
    });
    NSLog(@"同步提交3");
    // 同步提交到全局队列 任务是在主线程中执行的
    

    //同步提交任务到主队列
    dispatch_async(main_queue, ^{
        //此处执行任务
        NSLog(@"%@______%@", [NSThread currentThread], [NSThread isMainThread]?@"主线程":@"分线程");
    });
    NSLog(@"同步提交4");
    

    /*
     同步提交要等待block完成才会向下执行
     block是在主线程中执行的 block需要等待同步提交完成以后才会执行
     */


    //同步提交小结：同步提交会在当前线程等待任务的结束后再继续执行后面的代码
    
#warning 如果在主线程中同步提交 会造成线程死锁
    
    //异步提交 不会等到任务结束 马上向下执行

    dispatch_async(first_serial_queue, ^{
        //此处执行任务
        NSLog(@"异步串行：%@______%@", [NSThread currentThread], [NSThread isMainThread]?@"主线程":@"分线程");
        
        dispatch_sync(main_queue, ^{
            NSLog(@"分线程中同步提交%@______%@", [NSThread currentThread], [NSThread isMainThread]?@"主线程":@"分线程");
        });
        NSLog(@"分线程中同步提交完成");
    });
    NSLog(@"异步提交1");
    

    
//    dispatch_async(first_serial_queue, ^{
//        NSLog(@"异步串行：%@______%@", [NSThread currentThread], [NSThread isMainThread]?@"主线程":@"分线程");
//    });
    
    
    return YES;
}


NSString * getDocumentsPath()
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}


/*!
 * @typedef dispatch_queue_priority_t
 * Type of dispatch_queue_priority
 *
 * @constant DISPATCH_QUEUE_PRIORITY_HIGH
 * Items dispatched to the queue will run at high priority,
 * i.e. the queue will be scheduled for execution before
 * any default priority or low priority queue.
 *
 * @constant DISPATCH_QUEUE_PRIORITY_DEFAULT
 * Items dispatched to the queue will run at the default
 * priority, i.e. the queue will be scheduled for execution
 * after all high priority queues have been scheduled, but
 * before any low priority queues have been scheduled.
 *
 * @constant DISPATCH_QUEUE_PRIORITY_LOW
 * Items dispatched to the queue will run at low priority,
 * i.e. the queue will be scheduled for execution after all
 * default priority and high priority queues have been
 * scheduled.
 *
 * @constant DISPATCH_QUEUE_PRIORITY_BACKGROUND
 * Items dispatched to the queue will run at background priority, i.e. the queue
 * will be scheduled for execution after all higher priority queues have been
 * scheduled and the system will run items on this queue on a thread with
 * background status as per setpriority(2) (i.e. disk I/O is throttled and the
 * thread's scheduling priority is set to lowest value).
 */

@end
