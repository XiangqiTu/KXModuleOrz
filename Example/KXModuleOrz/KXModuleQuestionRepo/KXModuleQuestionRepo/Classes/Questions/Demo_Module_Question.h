//
//  Demo_Module_Question.h
//  Pods
//
//  Created by kk on 2020/9/24.
//

#ifndef Demo_Module_Question_h
#define Demo_Module_Question_h

#import <Foundation/Foundation.h>

///平面投影坐标结构定义
struct MAMapPoint{
    double x; ///<x坐标
    double y; ///<y坐标
};
typedef struct MAMapPoint MAMapPoint;

@protocol DemoHomeQuestion <NSObject>

@optional

+ (UIViewController *)homeMainViewController;

+ (void)presentHomeSubController;

+ (int)complexMethodWithSEL:(SEL)selector
                     target:(id)target
                      block:(dispatch_block_t)block
                  struction:(MAMapPoint)mapPoint
                      count:(NSInteger)count
                      point:(CGPoint)point
                     size:(CGSize)size
                       rect:(CGRect)rect
                     isBOOL:(BOOL)isBOOL;

@end

#endif /* Demo_Module_Question_h */
