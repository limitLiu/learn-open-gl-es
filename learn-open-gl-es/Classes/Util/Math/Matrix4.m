//
//  Matrix4.m
//  learn-open-gl-es
//
//  Created by liuyu on 11/19/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import "Matrix4.h"

@implementation Matrix4

+ (GLKMatrix4)translate:(float)x y:(float)y z:(float)z {
    return GLKMatrix4MakeTranslation(x, y, z);
}

+ (GLKMatrix4)translate:(GLKMatrix4)mat4 x:(float)x y:(float)y z:(float)z {
    return GLKMatrix4Translate(mat4, x, y, z);
}

+ (GLKMatrix4)rotate:(float)radians x:(float)x y:(float)y z:(float)z {
    radians = GLKMathDegreesToRadians(radians);
    return GLKMatrix4MakeRotation(radians, x, y, z);
}

+ (GLKMatrix4)rotate:(GLKMatrix4)mat4 radians:(float)radians x:(float)x y:(float)y z:(float)z {
    radians = GLKMathDegreesToRadians(radians);
    return GLKMatrix4Rotate(mat4, radians, x, y, z);
}

+ (GLKMatrix4)scale:(float)x y:(float)y z:(float)z {
    return GLKMatrix4MakeScale(x, y, z);
}

@end
