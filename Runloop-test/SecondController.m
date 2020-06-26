//
//  SecondController.m
//  Runloop-test
//
//  Created by 陈江林 on 2020/6/26.
//  Copyright © 2020 陈江林. All rights reserved.
//

#import "SecondController.h"

@interface SecondController ()
@property(nonatomic, strong)dispatch_source_t timer;
@end

@implementation SecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    // GCD timer
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    //设置定时器各种属性
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"-----%@", [NSThread currentThread]);
    });
    
    // 启动timer
    dispatch_resume(self.timer);
    
}

@end
