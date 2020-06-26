//
//  ViewController.m
//  Runloop-test
//
//  Created by 陈江林 on 2020/6/26.
//  Copyright © 2020 陈江林. All rights reserved.
//

#import "ViewController.h"
#import "SecondController.h"
#import "ThirdController.h"

@interface ViewController ()
@property(nonatomic, strong)NSThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thread = [[NSThread alloc] initWithBlock:^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }];
    [self.thread start];
}

- (void)timerAction
{
    NSLog(@"timer action");
}

- (IBAction)sourceButtonAction:(id)sender{
    SecondController *secondVC = [[SecondController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}
- (IBAction)observeAction:(id)sender{
    ThirdController *thircVC = [[ThirdController alloc] initWithNibName:@"ThirdController" bundle:nil];
    [self.navigationController pushViewController:thircVC animated:YES];
    
}
@end
