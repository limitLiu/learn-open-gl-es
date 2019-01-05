//
//  Matrix4.m
//  learn-open-gl-es
//
//  Created by liuyu on 11/19/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import "Matrix4.h"

@implementation Matrix4

+ (GLKMatrix4)rotate:(float)degrees x:(float)x y:(float)y z:(float)z {
    float radians = GLKMathDegreesToRadians(degrees);
    return GLKMatrix4MakeRotation(radians, x, y, z);
}

+ (GLKMatrix4)translate:(float)x y:(float)y z:(float)z {
    return GLKMatrix4MakeTranslation(x, y, z);
}

+ (GLKMatrix4)perspective:(float)degrees aspect:(float)aspect near:(float)near far:(float)far {
    float radians = GLKMathDegreesToRadians(degrees);
    return GLKMatrix4MakePerspective(radians, aspect, near, far);
}

@end
