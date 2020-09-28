//
//  KXAppConst_Question.h
//  Pods
//
//  Created by kk on 2020/9/27.
//

#ifndef KXAppConst_Question_h
#define KXAppConst_Question_h

@protocol KXAppConstQuestion <NSObject>

@optional

+ (NSString *)appHOST_URL;
+ (NSString *)appVersionCode;
+ (NSString *)appSECRET_KEY;
+ (NSString *)appHttpsSwitchKey; // 控制https请求是否要验证全部或验证部分或不验证
+ (NSString *)appHTTPSChangeReviewDate; // 1.7.0版时间是2019/9/1 12:00:00
+ (NSString *)appApiEnvironmentKey; //kApiEnvironment

@end

#endif /* KXAppConst_Question_h */
