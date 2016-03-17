//
//  SQViewController.m
//  GCDTest
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
	

    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //下载一张图片
    
    NSString *urlStr=@"http://img2.imgtn.bdimg.com/it/u=512314079,4060102663&fm=206&gp=0.jpg";
    NSString *str=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:str];
    
    dispatch_queue_t first_serial_queue =  dispatch_queue_create("com.xsq.firstSerialQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(global_queue, ^{
        
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

        NSLog(@"下载图片1完成");
        
        dispatch_sync(main_queue, ^{
            _imageView.image=[UIImage imageWithData:data];
        });
        
    });
    
    NSString *urlStr2 = @"http://img0.imgtn.bdimg.com/it/u=2316917339,1302361579&fm=206&gp=0.jpg";
    NSURL *url2 = [NSURL URLWithString:urlStr2];
    
    dispatch_async(global_queue, ^{
        NSLog(@"下载图片2开始");
        
        NSURLRequest *request=[NSURLRequest requestWithURL:url2];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        dispatch_sync(main_queue, ^{
            _imageView2.image=[UIImage imageWithData:data];
        });
    });
    
    /*
     GCD中的线程管理完全由当前系统来管理，它会根据当前的cpu状态来动态的分配线程给GCD使用
     
     队列分为串行队列和并发队列
     
     串行队列：
     一般说的串行队列都是自定义队列，会开辟分线程执行队列中的任务，队列中的任务是按照添加到队列中的顺序来执行的
     
     并行队列：
     一般说的是全局队列，全局队列不需要创建，系统提供的一个在全局可以获取的并行队列。队列中的任务都是并发执行的
     全局队列有4种，提供了四种优先级 高、默认、低、后台
     在iOS5.0以后加入了自定义并行队列
     
     主队列：
     主队列是一个全局可以访问的串行队列，提交到主队列中的任务是在主线程执行的，一般用作线程间通信，回到主线程刷新UI
     
     同步提交和异步提交

     同步提交：会阻塞当前线程，等提交的任务完成后继续向下执行
     异步提交：不会阻塞当前线程，提交任务后，不等待任务完成直接向下执行
     
     同步提交不会开辟新的线程，只在当前线程执行
     
     如果当前队列为串行队列，同步提交任务到当前队列会造成死锁
     
     
     常用用法
     串行队列创建一个
     并行队列 直接获取全局队列
     刷新UI 主队列
     
     阻塞主线程
     1、下载数据
     2、进行大量计算
     3、处理大量解析
     
     */
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
