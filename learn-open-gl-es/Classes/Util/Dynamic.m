//
//  Dynamic.m
//  learn-open-gl-es
//
//  Created by liuyu on 10/27/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import "Dynamic.h"

#import <objc/message.h>
#import <objc/runtime.h>

@implementation Dynamic

+ (void)showMethodList:(Class)clazz {
    unsigned count = 0;
    Method *methods = class_copyMethodList(clazz, &count);
    for (int i = 0; i < count; i++) {
        NSLog(@"method: %@", NSStringFromSelector(method_getName(methods[i])));
    }
}

+ (void)showVars:(Class)clazz {
    unsigned count = 0;
    Ivar *vars = class_copyIvarList(clazz, &count);
    for (int i = 0; i < count; i++) {
        NSLog(@"properties: %@", @(ivar_getName(vars[i])));
    }
}

+ (void)showProperties:(id)obj selector:(NSString *)sel {
    NSLog(@"%@", objc_msgSend(obj, NSSelectorFromString(sel)));
}

@end
