//
//  KXModuleManager.h
//  KXModuleOrz
//
//  Created by kk on 2020/9/23.
//

#import "KXModuleDefinition.h"

/// 线程不安全，需要在主线程操作
@interface KXModuleManager : NSObject

- (BOOL)fetchModuleActive:(Class)moduleClass;

- (void)enableModuleActive:(BOOL)isActive module:(Class)moduleClass;

- (void)triggerEvent:(KXModuleEvent)event;

@end
