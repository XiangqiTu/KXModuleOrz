//
//  KXModuleDefinition.h
//  Pods
//
//  Created by kk on 2020/9/24.
//

#ifndef KXModuleDefinition_h
#define KXModuleDefinition_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KXModulePriority) {
    KXModulePriorityLow = 0,
    KXModulePriorityNoromal = 200,
    KXModulePriorityHigh = 400,
};

typedef NS_ENUM(NSInteger, KXModuleEvent) {
    KXModuleEventNone = 0,
    
    //Load
    KXModuleEventSetup = 1,
    KXModuleEventWindowAppear = 2,
    KXModuleEventDidFinishLauch = 3,
    KXModuleEventMainViewDidLoad = 4,
    
    //Application Lifecycle
    KXModuleEventWillResignActiveEvent = 100,
    KXModuleEventDidEnterBackgroundEvent = 101,
    KXModuleEventWillEnterForegroundEvent = 102,
    KXModuleEventDidBecomeActiveEvent = 103,
    KXModuleEventWillTerminateEvent = 104,
};

#pragma mark - Macro

#define KXModuleOrz_Auto_Regist() \
+ (void)load { \
    [self setModuleActive:YES]; \
} \
+ (BOOL)isModuleActive { \
    return [[KXModuleOrz shareInstance] orz_fetchModuleActive:self]; \
} \
+ (void)setModuleActive:(BOOL)isActive { \
    [[KXModuleOrz shareInstance] orz_enableModuleActive:isActive module:self]; \
}

#define __ORZ_ANSWER__

///模块管理组件orz QA系统 ask简写方法(问题单 + 具体某个问题)
#define orz_ask(__protocol,__selector, ...) __moduleOrzAsk(__protocol, __selector, ##__VA_ARGS__)



/// 执行orzAsk方法，尝试获取问题答案
/// @param protocol 问题列表
/// @param selector 具体的某个问题
///注意：SEL 里的自定义参数 支持大多数常用OC参数，不支持:结构体，联合体, 若有新的类型不支持，可以报告给我，我试着优化完善一下
id NS_REQUIRES_NIL_TERMINATION  __moduleOrzAsk(Protocol *protocol, SEL selector, ...);

#endif /* KXModuleDefinition_h */
