//
//  KXHomeModule.m
//  KXModuleOrz_Example
//
//  Created by kk on 2020/9/24.
//  Copyright © 2020 XiangqiTu. All rights reserved.
//

#import "KXHomeModule.h"

//This value may be changed for future
static NSInteger const __varModulePriority = KXModulePriorityLow;

@implementation KXHomeModule

KXModuleOrz_Auto_Regist()

+ (KXModulePriority)modulePriority {
    return __varModulePriority;
}

- (void)moduleCatchEvent:(KXModuleEvent)event {
    switch (event) {
        case KXModuleEventSetup:
            NSLog(@"HomeModule Setup");
            break;
        case KXModuleEventMainViewDidLoad: {
            NSLog(@"HomeModule Load Subviews");
            break;
        }
        default:
            break;
    }
}

@end
