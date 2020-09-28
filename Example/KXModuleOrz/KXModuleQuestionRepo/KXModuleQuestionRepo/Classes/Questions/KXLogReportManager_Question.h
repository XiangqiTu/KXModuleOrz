//
//  KXLogReportManager_Question.h
//  Pods
//
//  Created by kk on 2020/9/27.
//

#ifndef KXLogReportManager_Question_h
#define KXLogReportManager_Question_h

//避免重复定义
typedef NS_ENUM(NSUInteger, KXLogReportLevel) {
    KXLogReportLevelDebug = 1, // 调试信息
    KXLogReportLevelError, // 不该出现的异常 且影响业务流程
    KXLogReportLevelWarn // 不该出现的异常 且不影响业务流程
};

@protocol KXLogReportManagerQuestion <NSObject>

@optional

+ (void)writeLogLevel:(KXLogReportLevel)level
              message:(NSString *)message
            className:(Class)className
         selectorName:(SEL)selectorName;

@end

#endif /* KXLogReportManager_Question_h */
