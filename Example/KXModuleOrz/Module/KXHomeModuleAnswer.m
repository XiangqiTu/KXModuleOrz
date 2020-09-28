//
//  KXHomeModuleAnswer.m
//  KXModuleOrz_Example
//
//  Created by kk on 2020/9/24.
//  Copyright © 2020 XiangqiTu. All rights reserved.
//

#import "KXHomeModuleAnswer.h"
#import <KXModuleOrz/KXModuleOrz.h>
//#import <KXModuleQuestionRepo/Demo_Module_Question.h>
#import "Demo_Module_Question.h"

@interface KXHomeModuleAnswer () <KXModuleProtocol, DemoHomeQuestion>

@end

@implementation KXHomeModuleAnswer

KXModuleOrz_Auto_Regist()

+ (KXModulePriority)modulePriority {
    return KXModulePriorityLow;
}

- (void)moduleCatchEvent:(KXModuleEvent)event {
    switch (event) {
        case KXModuleEventSetup:
            //1.Regist QA Service
            [[KXModuleOrz shareInstance] orz_registAnswer:[self class] forQuestion:@protocol(DemoHomeQuestion)];
            
            //2.UnActive Module Event （后续不希望answer module 有 event 活性）
            [[KXModuleOrz shareInstance] orz_enableModuleActive:NO module:[self class]];
            
            //3.Unregist QA Service (特殊场景下，可能不希望有模块回答Question)
//            [[KXModuleOrz shareInstance] orz_unregistAnswer:[self class]];
            break;
            
        default:
            break;
    }
}

#pragma mark - Answer Questions

+ (UIViewController *)homeMainViewController __ORZ_ANSWER__
{
    return [UIViewController new];
}

+ (void)presentHomeSubController __ORZ_ANSWER__
{
    
}

+ (int)complexMethodWithSEL:(SEL)selector
                     target:(id)target
                      block:(dispatch_block_t)block
                  struction:(MAMapPoint)mapPoint
                     count:(NSInteger)count
                      point:(CGPoint)point
                      size:(CGSize)size
                        rect:(CGRect)rect
                     isBOOL:(BOOL)isBOOL __ORZ_ANSWER__
{
    NSLog(@"all kinds of parameters");
    
    return 200;
}

@end
