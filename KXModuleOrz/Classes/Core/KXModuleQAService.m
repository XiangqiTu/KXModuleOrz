//
//  KXModuleQAService.m
//  KXModuleOrz
//
//  Created by kk on 2020/9/23.
//

#import "KXModuleQAService.h"

@interface KXModuleQAService ()

@property (nonatomic, strong) NSMutableDictionary *answersMap;
@property (nonatomic, strong) NSMutableDictionary *questionsMap;

@end

@implementation KXModuleQAService

- (id)init {
    if (self = [super init]) {
        self.answersMap = [NSMutableDictionary dictionary];
        self.questionsMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - 

- (void)registAnswer:(Class)answerCls forQuestion:(Protocol *)question {
    if (!answerCls || !question) return;
    
    if (![answerCls conformsToProtocol:question]) return;
    
    [self.questionsMap setValue:NSStringFromClass(answerCls) forKey:NSStringFromProtocol(question)];
    [self.answersMap setValue:NSStringFromProtocol(question) forKey:NSStringFromClass(answerCls)];
}

- (void)unregistAnswer:(Class)answerCls {
    if (!answerCls) return;
    
    NSString *strQeustion = [self.answersMap objectForKey:NSStringFromClass(answerCls)];
    if (strQeustion) {
        [self.questionsMap removeObjectForKey:strQeustion];
    }
    
    [self.answersMap removeObjectForKey:NSStringFromClass(answerCls)];
}

- (Class)answerForQuestion:(Protocol *)question {
    if (!question) return NULL;
    
    NSString *strCls = [self.questionsMap objectForKey:NSStringFromProtocol(question)];
    if (strCls) {
        return NSClassFromString(strCls);
    } else {
        return NULL;
    }
}

@end
