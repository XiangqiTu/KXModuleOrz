//
//  KXModuleManager.m
//  KXModuleOrz
//
//  Created by kk on 2020/9/23.
//

#import "KXModuleManager.h"
#import "KXModuleProtocol.h"

@interface KXModuleManager ()

@property (nonatomic, strong) NSMutableDictionary *totalModules;

@end

@implementation KXModuleManager

- (id)init {
    if (self = [super init]) {
        self.totalModules = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (BOOL)fetchModuleActive:(Class)moduleClass {
    BOOL result = NO;
    
    if (!moduleClass) return result;
    
    BOOL isConforms = [moduleClass conformsToProtocol:@protocol(KXModuleProtocol)];
    if (!isConforms) return result;
    
    id obj = [self.totalModules objectForKey:NSStringFromClass(moduleClass)];
    if (obj) {
        result = YES;
    }
    
    return result;
}

- (void)enableModuleActive:(BOOL)isActive module:(Class)moduleClass {
    if (!moduleClass) return;
    
    BOOL isConforms = [moduleClass conformsToProtocol:@protocol(KXModuleProtocol)];
    if (!isConforms) return;
    
    if (isActive) {
        //regist
        [self registModule:moduleClass];
    } else {
        //un-regist
        [self unRegistModule:moduleClass];
    }
}

- (void)registModule:(Class)moduleClass {
    
    BOOL isActive = [self fetchModuleActive:moduleClass];
    if (isActive) return;
    
    //Not Active
    id instance = [[moduleClass alloc] init];
    [self.totalModules setValue:instance forKey:NSStringFromClass(moduleClass)];
}

- (void)unRegistModule:(Class)moduleClass {
    BOOL isActive = [self fetchModuleActive:moduleClass];
    if (!isActive) return;
    
    //Active
    [self.totalModules removeObjectForKey:NSStringFromClass(moduleClass)];
}

- (void)triggerEvent:(KXModuleEvent)event {
    if (event == KXModuleEventNone) return;
    
    //1.根据优先级重新排序
    NSMutableArray *totoalInstanceArray = [NSMutableArray array];
    
    NSArray *insArray = self.totalModules.allValues;
    if (insArray && insArray.count) {
        [totoalInstanceArray addObjectsFromArray:insArray];
    }
    
    if (!totoalInstanceArray.count) return;
    
    [totoalInstanceArray sortUsingComparator:^NSComparisonResult(id  <KXModuleProtocol> obj1, id  <KXModuleProtocol> obj2) {
        NSInteger priority1 = KXModulePriorityLow;
        if ([obj1.class respondsToSelector:@selector(modulePriority)]) {
            priority1 = [obj1.class modulePriority];
        }
        
        NSInteger priority2 = KXModulePriorityLow;
        if ([obj2.class respondsToSelector:@selector(modulePriority)]) {
            priority2 = [obj2.class modulePriority];
        }
        
        if (priority1 > priority2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    //2.批量处理ModuleEvent
    for (id <KXModuleProtocol> instance in totoalInstanceArray) {
        if ([instance respondsToSelector:@selector(moduleCatchEvent:)]) {
            [instance moduleCatchEvent:event];
        }
    }
}

@end
