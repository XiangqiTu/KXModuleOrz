//
//  KXModuleDefinition.m
//  KXModuleOrz
//
//  Created by kk on 2020/9/24.
//

#import <Foundation/Foundation.h>
#import "KXModuleOrz.h"

BOOL orz_IsObjectType(const char *objCType);

const char *orz_TypeWithoutQualifiers(const char *objCType);
BOOL orz_IsUnqualifiedClassType(const char *unqualifiedObjCType);
BOOL orz_IsUnqualifiedBlockType(const char *unqualifiedObjCType);

id orz_returnValue(NSInvocation *invocation);

id NS_REQUIRES_NIL_TERMINATION  __moduleOrzAsk(Protocol *protocol, SEL selector, ...)
{
    Class answerCls = [[KXModuleOrz shareInstance] orz_answerForQuestion:protocol];
    if (!answerCls || ![answerCls conformsToProtocol:protocol]) return NULL;
    
    if(![answerCls respondsToSelector:selector]) return NULL;
    
    NSMethodSignature *clsMethodSignature = [answerCls methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:clsMethodSignature];
    [invocation setSelector:selector];
    [invocation setTarget:answerCls];
    
    NSString *selectorName = NSStringFromSelector(selector);
    NSArray *parameterArray = [selectorName componentsSeparatedByString:@":"];
    NSUInteger parameterCount = [parameterArray count] - 1;
    if (!parameterCount) {
        [invocation invoke];
        
        id returnValue = orz_returnValue(invocation);
        return returnValue;
    }
    
    va_list ap;
    va_start(ap, selector);
    NSInteger orignIndex = 2;
    
#define SET_NEXT_PARAMETER(type) \
    type parameter; \
    parameter = va_arg(ap, type);\
    if (!parameter) { \
        orignIndex ++; \
        continue; \
    }  \
    [invocation setArgument:&parameter atIndex:orignIndex];\
    orignIndex ++; \
    
    while ( parameterCount - (orignIndex - 2) > 0 ) {
        const char *argType = [invocation.methodSignature getArgumentTypeAtIndex:orignIndex];
        // Skip const type qualifier.
        if (argType[0] == 'r') {
            argType++;
        }
        
        if (orz_IsObjectType(argType)) {
            SET_NEXT_PARAMETER(id);
        }  else if (strcmp(argType, @encode(char)) == 0) {
            SET_NEXT_PARAMETER(char);
        } else if (strcmp(argType, @encode(int)) == 0) {
            SET_NEXT_PARAMETER(int);
        } else if (strcmp(argType, @encode(short)) == 0) {
            SET_NEXT_PARAMETER(short);
        } else if (strcmp(argType, @encode(long)) == 0) {
            SET_NEXT_PARAMETER(long);
        } else if (strcmp(argType, @encode(long long)) == 0) {
            SET_NEXT_PARAMETER(long long);
        } else if (strcmp(argType, @encode(unsigned char)) == 0) {
            SET_NEXT_PARAMETER(unsigned char);
        } else if (strcmp(argType, @encode(unsigned int)) == 0) {
            SET_NEXT_PARAMETER(unsigned int);
        } else if (strcmp(argType, @encode(unsigned short)) == 0) {
            SET_NEXT_PARAMETER(unsigned short);
        } else if (strcmp(argType, @encode(unsigned long)) == 0) {
            SET_NEXT_PARAMETER(unsigned long);
        } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
            SET_NEXT_PARAMETER(unsigned long long);
        } else if (strcmp(argType, @encode(float)) == 0) {
            SET_NEXT_PARAMETER(float);
        } else if (strcmp(argType, @encode(double)) == 0) {
            SET_NEXT_PARAMETER(double);
        } else if (strcmp(argType, @encode(BOOL)) == 0) {
            SET_NEXT_PARAMETER(BOOL);
        } else if (strcmp(argType, @encode(char *)) == 0) {
            SET_NEXT_PARAMETER(char *);
        } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
            SET_NEXT_PARAMETER(id);
        } else if (strcmp(argType, @encode(SEL)) == 0)  {
            SET_NEXT_PARAMETER(SEL);
        } else if (strcmp(argType, @encode(CGSize)) == 0)  {
            CGSize parameter = CGSizeZero;
            parameter = va_arg(ap, CGSize);
            [invocation setArgument:&parameter atIndex:orignIndex];
            orignIndex ++;
        } else if (strcmp(argType, @encode(CGPoint)) == 0)  {
            CGPoint parameter = CGPointZero;
            parameter = va_arg(ap, CGPoint);
            [invocation setArgument:&parameter atIndex:orignIndex];
            orignIndex ++;
        } else if (strcmp(argType, @encode(CGRect)) == 0) {
            CGRect parameter = CGRectZero;
            parameter = va_arg(ap, CGRect);
            [invocation setArgument:&parameter atIndex:orignIndex];
            orignIndex ++;
        } else {
            NSString *argDescStr = [NSString stringWithFormat:@"__moduleOrzAsk Argument type ['%s'] not supported", argType];
            NSLog(@"%@", argDescStr);
            orignIndex ++;
            continue;
        }
    }
    va_end(ap);
    
    [invocation invoke];
    id returnValue = orz_returnValue(invocation);
    return returnValue;
#undef SET_NEXT_PARAMETER
}

BOOL orz_IsObjectType(const char *objCType)
{
    const char *unqualifiedObjCType = orz_TypeWithoutQualifiers(objCType);
    
    char objectType[] = @encode(id);
    if(strcmp(unqualifiedObjCType, objectType) == 0 || orz_IsUnqualifiedClassType(unqualifiedObjCType))
        return YES;
    
    // sometimes the name of an object's class is tacked onto the type, in double quotes
    if(strncmp(unqualifiedObjCType, objectType, sizeof(objectType) - 1) == 0 && unqualifiedObjCType[sizeof(objectType) - 1] == '"')
        return YES;
    
    // if the returnType is a typedef to an object, it has the form ^{OriginClass=#}
    NSString *regexString = @"^\\^\\{(.*)=#.*\\}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:0 error:NULL];
    NSString *type = [NSString stringWithCString:unqualifiedObjCType encoding:NSASCIIStringEncoding];
    if([regex numberOfMatchesInString:type options:0 range:NSMakeRange(0, type.length)] > 0)
        return YES;
    
    // if the return type is a block we treat it like an object
    return orz_IsUnqualifiedBlockType(unqualifiedObjCType);
}

const char *orz_TypeWithoutQualifiers(const char *objCType)
{
    while(strchr("rnNoORV", objCType[0]) != NULL)
        objCType += 1;
    return objCType;
}

BOOL orz_IsUnqualifiedClassType(const char *unqualifiedObjCType)
{
    return (strcmp(unqualifiedObjCType, @encode(Class)) == 0);
}

BOOL orz_IsUnqualifiedBlockType(const char *unqualifiedObjCType)
{
    char blockType[] = @encode(void(^)(void));
    if(strcmp(unqualifiedObjCType, blockType) == 0)
        return YES;
    
    // sometimes block argument/return types are tacked onto the type, in angle brackets
    if(strncmp(unqualifiedObjCType, blockType, sizeof(blockType) - 1) == 0 && unqualifiedObjCType[sizeof(blockType) - 1] == '<')
        return YES;
    
    return NO;
}

id orz_returnValue(NSInvocation *invocation) {
    #define WRAP_AND_RETURN(type) \
        do { \
            type val = 0; \
            [invocation getReturnValue:&val]; \
            return @(val); \
        } while (0)

        const char *returnType = invocation.methodSignature.methodReturnType;
        // Skip const type qualifier.
        if (returnType[0] == 'r') {
            returnType++;
        }

        if (strcmp(returnType, @encode(id)) == 0 || strcmp(returnType, @encode(Class)) == 0 || strcmp(returnType, @encode(void (^)(void))) == 0) {
            __autoreleasing id returnObj;
            [invocation getReturnValue:&returnObj];
            return returnObj;
        } else if (strcmp(returnType, @encode(char)) == 0) {
            WRAP_AND_RETURN(char);
        } else if (strcmp(returnType, @encode(int)) == 0) {
            WRAP_AND_RETURN(int);
        } else if (strcmp(returnType, @encode(short)) == 0) {
            WRAP_AND_RETURN(short);
        } else if (strcmp(returnType, @encode(long)) == 0) {
            WRAP_AND_RETURN(long);
        } else if (strcmp(returnType, @encode(long long)) == 0) {
            WRAP_AND_RETURN(long long);
        } else if (strcmp(returnType, @encode(unsigned char)) == 0) {
            WRAP_AND_RETURN(unsigned char);
        } else if (strcmp(returnType, @encode(unsigned int)) == 0) {
            WRAP_AND_RETURN(unsigned int);
        } else if (strcmp(returnType, @encode(unsigned short)) == 0) {
            WRAP_AND_RETURN(unsigned short);
        } else if (strcmp(returnType, @encode(unsigned long)) == 0) {
            WRAP_AND_RETURN(unsigned long);
        } else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
            WRAP_AND_RETURN(unsigned long long);
        } else if (strcmp(returnType, @encode(float)) == 0) {
            WRAP_AND_RETURN(float);
        } else if (strcmp(returnType, @encode(double)) == 0) {
            WRAP_AND_RETURN(double);
        } else if (strcmp(returnType, @encode(BOOL)) == 0) {
            WRAP_AND_RETURN(BOOL);
        } else if (strcmp(returnType, @encode(char *)) == 0) {
            WRAP_AND_RETURN(const char *);
        } else if (strcmp(returnType, @encode(void)) == 0) {
            return NULL;
        } else {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(returnType, &valueSize, NULL);

            unsigned char valueBytes[valueSize];
            [invocation getReturnValue:valueBytes];

            return [NSValue valueWithBytes:valueBytes objCType:returnType];
        }

        return nil;

    #undef WRAP_AND_RETURN
}
