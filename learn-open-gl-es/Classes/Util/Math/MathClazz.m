//
//  Math.m
//  learn-open-gl-es
//
//  Created by liuyu on 11/19/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import "MathClazz.h"
#import "Matrix4.h"

@implementation MathClazz

+ (Matrix4 *)matrix4 {
    return [Matrix4 new];
}

+ (float)radians:(float)degrees {
    return GLKMathDegreesToRadians(degrees);
}

@end
