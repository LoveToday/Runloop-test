//
//  ThirdController.m
//  Runloop-test
//
//  Created by 陈江林 on 2020/6/26.
//  Copyright © 2020 陈江林. All rights reserved.
//

#import "ThirdController.h"
#import "ThirdTableCell.h"

typedef void(^RunloopBlock)(void);

@interface ThirdController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *tasks;
@property (nonatomic, assign) NSUInteger maxQueueLength;
@end

@implementation ThirdController

- (void)timerAction{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ThirdTableCell" bundle:nil] forCellReuseIdentifier:@"ThirdTableCell"];
    
    [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    _maxQueueLength = 10;
    self.tasks = [NSMutableArray array];
    
    [self addRunloopObserve];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThirdTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThirdTableCell" forIndexPath:indexPath];
    cell.titleLabel.text = @"test";
    
    [self addTask:^{
        NSString *file = [[NSBundle mainBundle] pathForResource:@"IMG_0561.PNG" ofType:nil];
        cell.imgView.image = [UIImage imageWithContentsOfFile:file];
    }];
    
    
    return cell;
}

- (void)addTask: (RunloopBlock)task{
    [self.tasks addObject:task];
    if (self.tasks.count > self.maxQueueLength) {
        [self.tasks removeObjectAtIndex:0];
    }
    
}


/// 添加观察者
- (void)addRunloopObserve{
    // 获取runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    // 定义观察者
    static CFRunLoopObserverRef defaultModeObserve;
    // 创建上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    // 创建
    defaultModeObserve = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &context);
    // 添加到当前runloop中
    CFRunLoopAddObserver(runloop, defaultModeObserve, kCFRunLoopCommonModes);
    
}

void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NSLog(@"执行");
    
    
    ThirdController *vc = (__bridge ThirdController *)(info);
    if (vc.tasks.count == 0) {
        return;
    }
    RunloopBlock task = vc.tasks.firstObject;
    
    task();
    [vc.tasks removeObjectAtIndex:0];
}

@end
