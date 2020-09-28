//
//  KXViewController.m
//  KXModuleOrz
//
//  Created by XiangqiTu on 09/23/2020.
//  Copyright (c) 2020 XiangqiTu. All rights reserved.
//

#import "KXViewController.h"
#import <KXModuleOrz/KXModuleOrz.h>
//#import <KXModuleQuestionRepo/Demo_Module_Question.h>
#import "Demo_Module_Question.h"

@interface KXViewController ()

@end

@implementation KXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.告诉其他模块，主界面已经开始加载了，开始对应的业务
    [[KXModuleOrz shareInstance] orz_triggerEvent:KXModuleEventMainViewDidLoad];
    
    
    //2.主界面发布了一些问题在Demo_Module_Question.h，希望得到问题的回答，来进行其他业务。
    //2.1主界面希望得到一个ViewController
    UIViewController *templeVC = orz_ask(@protocol(DemoHomeQuestion), @selector(homeMainViewController), nil);
    if (templeVC) {
        NSLog(@"顺利得到问题的响应，结果返回templeVC %@", templeVC);
    }
    
    //2.2 主界面希望其他模快  能呈现出一个SubController
    orz_ask(@protocol(DemoHomeQuestion), @selector(presentHomeSubController), nil);
    
    //2.3 主界面发布了一个超级复杂的问题，包含返回值，各种类型的参数
    //系统常用参数类型 支持
    dispatch_block_t block = ^{
        NSLog(@"block invoke");
    };
    
    //自定义结构体参数 不支持
    MAMapPoint mapPoint;
    mapPoint.x = 1.00;
    mapPoint.y = 99.00;
    
    id resultValue  = orz_ask(@protocol(DemoHomeQuestion),
                               @selector(complexMethodWithSEL:target:block:struction:count:point:size:rect:isBOOL:),
                               @selector(didReceiveMemoryWarning),
                               self,
                               block,
                               mapPoint,
                               99,
                               CGPointMake(-11, -22),
                               CGSizeMake(333, 333),
                               CGRectMake(8, 8, 8, 8),
                               YES,
                               nil);
    
    NSLog(@"complexMethodWithSEL resultValue: %@", resultValue);
}

@end
