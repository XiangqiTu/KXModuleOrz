//
//  KXModuleOrz.m
//  KXModuleOrz
//
//  Created by kk on 2020/9/23.
//

#import "KXModuleOrz.h"
#import "KXModuleManager.h"
#import "KXModuleQAService.h"

@interface KXModuleOrz ()

@property (nonatomic, strong) KXModuleManager *moduleManager;
@property (nonatomic, strong) KXModuleQAService *moduleQAService;

@end

@implementation KXModuleOrz

+ (instancetype)shareInstance
{
    static dispatch_once_t p;
    static KXModuleOrz *sharedInstance = nil;
    
    dispatch_once(&p, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.moduleManager = [KXModuleManager new];
        self.moduleQAService = [KXModuleQAService new];
    }
    
    return self;
}

#pragma mark - Module Manager

- (BOOL)orz_fetchModuleActive:(Class)moduleClass {
    return [self.moduleManager fetchModuleActive:moduleClass];
}

- (void)orz_enableModuleActive:(BOOL)isActive module:(Class)moduleClass {
    [self.moduleManager enableModuleActive:isActive module:moduleClass];
}

- (void)orz_triggerEvent:(KXModuleEvent)event {
    [self.moduleManager triggerEvent:event];
}

#pragma mark - Module QAService

- (void)orz_registAnswer:(Class)answerCls forQuestion:(Protocol *)question {
    [self.moduleQAService registAnswer:answerCls forQuestion:question];
}

- (void)orz_unregistAnswer:(Class)answerCls {
    [self.moduleQAService unregistAnswer:answerCls];
}

- (Class)orz_answerForQuestion:(Protocol *)question {
    return [self.moduleQAService answerForQuestion:question];
}

@end
