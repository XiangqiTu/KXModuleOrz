//
//  KXModuleOrz.h
//  KXModuleOrz
//
//  Created by kk on 2020/9/23.
//

#import "KXModuleDefinition.h"
#import "KXModuleProtocol.h"

@interface KXModuleOrz : NSObject

+ (instancetype)shareInstance;

#pragma mark - Module Manager

- (BOOL)orz_fetchModuleActive:(Class)moduleClass;

- (void)orz_enableModuleActive:(BOOL)isActive module:(Class)moduleClass;

- (void)orz_triggerEvent:(KXModuleEvent)event;

#pragma mark - Module QAService

- (void)orz_registAnswer:(Class)answerCls forQuestion:(Protocol *)question;

- (void)orz_unregistAnswer:(Class)answerCls;

- (Class)orz_answerForQuestion:(Protocol *)question;

@end
