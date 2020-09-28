//
//  KXModuleProtocol.h
//  KXModuleOrz
//
//  Created by kk on 2020/9/23.
//

#ifndef KXModuleProtocol_h
#define KXModuleProtocol_h

#import "KXModuleDefinition.h"


/// 模块化架构协议
///不允许sharedInstance 单例/全局 对象实现此Protocol
@protocol KXModuleProtocol <NSObject>

@required

+ (BOOL)isModuleActive;
+ (void)setModuleActive:(BOOL)isActive;

@optional

+ (KXModulePriority)modulePriority;

- (void)moduleCatchEvent:(KXModuleEvent)event;

@end

#endif /* KXModuleProtocol_h */
