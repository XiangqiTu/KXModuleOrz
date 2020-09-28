//
//  KXModuleQAService.h
//  KXModuleOrz
//
//  Created by kk on 2020/9/23.
//

#import <Foundation/Foundation.h>

/// QAService初衷就是为了Module之间的解耦，只能是Q 映射 A一对一
/// 线程不安全，需要在主线程操作
@interface KXModuleQAService : NSObject

- (void)registAnswer:(Class)answerCls forQuestion:(Protocol *)question;

- (void)unregistAnswer:(Class)answerCls;

- (Class)answerForQuestion:(Protocol *)question;

@end
