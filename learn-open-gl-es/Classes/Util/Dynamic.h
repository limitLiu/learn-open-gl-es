//
//  Dynamic.h
//  learn-open-gl-es
//
//  Created by liuyu on 10/27/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dynamic : NSObject

+ (void)showMethodList:(Class)clazz;

+ (void)showVars:(Class)clazz;

+ (void)showProperties:(id)obj selector:(NSString *)sel;

@end
