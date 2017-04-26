//
//  ViewController.m
//  DemoSYNumberEditView
//
//  Created by zhangshaoyu on 17/4/25.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "SYNumberEditView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"数量编辑视图";
    
    SYNumberEditView *numberView = [[SYNumberEditView alloc] initWithFrame:CGRectMake(10.0, 10.0, 80.0, 30.0)];
    [self.view addSubview:numberView];
    numberView.tag = 1000;
    numberView.backgroundColor = [UIColor whiteColor];
    // 按钮
    numberView.reduceImageNormal = [UIImage imageNamed:@"reduceCircle_Normal"];
    numberView.reduceImageHighlight = [UIImage imageNamed:@"reduceCircle_Highlight"];
    numberView.addImageNormal = [UIImage imageNamed:@"addCircle_Normal"];
    numberView.addImageHighlight = [UIImage imageNamed:@"addCircle_Highlight"];
    // 字体
    numberView.textColor = [UIColor redColor];
    numberView.textFont = [UIFont boldSystemFontOfSize:14.0];
    // 数量
    numberView.numberMax = 20;
    numberView.numberEdit = ^(NSInteger number){
        NSLog(@"1 number = %@", @(number));
    };
    // 边框
    numberView.borderShow = YES;
    numberView.borderColor = [UIColor redColor];
    numberView.borderWidth = 2.0;
    numberView.borderCornerRadius = 5.0;
    
    
    SYNumberEditView *numberView2 = [[SYNumberEditView alloc] init];
    [self.view addSubview:numberView2];
    numberView2.frame = CGRectMake(10.0, 50.0, 120.0, 30.0);
    numberView2.backgroundColor = [UIColor yellowColor];
    // 按钮
    numberView2.reduceImageNormal = [UIImage imageNamed:@"reduceDirection_Normal"];
    numberView2.reduceImageHighlight = [UIImage imageNamed:@"reduceDirection_Highlight"];
    numberView2.addImageNormal = [UIImage imageNamed:@"addDirection_Normal"];
    numberView2.addImageHighlight = [UIImage imageNamed:@"addDirection_Highlight"];
    // 数量
    numberView2.numberEdit = ^(NSInteger number){
        NSLog(@"2 number = %@", @(number));
    };
    
    
    SYNumberEditView *numberView3 = [[SYNumberEditView alloc] init];
    [self.view addSubview:numberView3];
    numberView3.frame = CGRectMake(10.0, 90.0, 120.0, 30.0);
    numberView3.backgroundColor = [UIColor orangeColor];
    // 按钮
    numberView3.reduceTitleNormal = @"减";
    numberView3.reduceTitleColorNormal = [UIColor greenColor];
    numberView3.reduceTitleColorHighlight = [UIColor purpleColor];
    numberView3.addTitleNormal = @"加";
    numberView3.addTitleColorNormal = [UIColor brownColor];
    numberView3.addTitleColorHighlight = [UIColor blueColor];
    // 数量
    numberView3.number = 10;
    numberView3.numberMax = 300;
    numberView3.numberEdit = ^(NSInteger number){
        NSLog(@"3 number = %@", @(number));
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SYNumberEditView *numberView = (SYNumberEditView *)[self.view viewWithTag:1000];
    NSLog(@"2 number = %@", @(numberView.number));
}

@end
