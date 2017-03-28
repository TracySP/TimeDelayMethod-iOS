//
//  ViewController.m
//  延时方法Demo
//
//  Created by 四维图新SP on 17/3/27.
//  Copyright © 2017年 TracyMcSong. All rights reserved.
//
#define kDelay .3f

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) NSTimer *myTimer;

@property (nonatomic,strong) NSThread *newThread;

@property (nonatomic) BOOL isContinue;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self performSelectorMethod];
    
    [self NSTimerMethod];
    
    [self NSTimerChildThread];
    
    [self NSThreadMethod];
    
    [self GCDMethod];
}
/// performSelector延迟方法 不阻塞主线程 主线程执行
- (void)performSelectorMethod
{
    // 不带参延迟
    [self performSelector:@selector(operateDelay) withObject:nil afterDelay:kDelay];
    // 带参延迟
    [self performSelector:@selector(operateDelay:) withObject:@YES afterDelay:kDelay];
}
/// performSelector取消延迟方法  object 取消延迟参数必须和开始延迟参数
- (void)stopPerformSelectorMethod
{
    // 不带参取消延迟
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateDelay) object:nil];
    // 带参取消延迟 参数必须和延迟时参数保持一致，否则取消无效
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateDelay:) object:@YES];
    // 取消所有延迟执行操作
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}
/// NSTimer方法 不阻塞主线程 主线程执行
- (void)NSTimerMethod
{
    // 延迟
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:kDelay target:self selector:@selector(operateDelay) userInfo:nil repeats:YES];
    
//    self.myTimer = [NSTimer timerWithTimeInterval:kDelay target:self selector:@selector(operateDelay) userInfo:nil repeats:YES];
}
/// NSTimer在子线程
- (void)NSTimerChildThread
{
    // 创建一个子线程
    self.newThread = [[NSThread alloc] initWithTarget:self selector:@selector(newThreadRun) object:nil];
    
    [self.newThread start];
}

- (void)newThreadRun
{
    // 创建NSTimer
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:kDelay target:self selector:@selector(operateDelay) userInfo:nil repeats:YES];
    // 开启子线程的runloop
    [[NSRunLoop currentRunLoop] run];
}

- (void)stopNSTimerMethod
{
    [self.myTimer invalidate];
}

/// NSThread方法 阻塞主线程 主、子线程均可
- (void)NSThreadMethod
{
    [NSThread sleepForTimeInterval:kDelay];
}

- (void)stopNSThreadMethod
{
    
}
/// GCD方法  不阻塞主线程  主、子线程均可
- (void)GCDMethod
{
    // 在主线程执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.isContinue)
        {
            [self operateDelay];
            
            self.isContinue = NO;
        }
    });
    // 在子线程执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self operateDelay];
    });
}

/// 公用延迟方法1
- (void)operateDelay
{
    NSLog(@"延时后调用");
}
/// 公用延迟方法2
- (void)operateDelay:(BOOL)delay
{
    NSLog(@"延时后调用");
}

@end
